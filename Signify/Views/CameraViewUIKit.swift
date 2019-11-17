import UIKit
import AVFoundation
import Vision
import Combine
import SwiftUI
import VideoToolbox

protocol CameraViewDelegate: class {
    func cameraViewDidFoundSign(frame: CGRect)
    func cameraViewFoundNoSign()
}


extension UIImage {
    public convenience init?(pixelBuffer: CVPixelBuffer) {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)
        
        if let cgImage = cgImage {
            self.init(cgImage: cgImage)
        } else {
            return nil
        }
    }
}

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}

final class CameraViewUIKit: UIView, AVCaptureVideoDataOutputSampleBufferDelegate{
    @ObservedObject var observableScan: ObservableScan
    
    unowned let delegate: CameraViewDelegate
    
    private var captureSession: AVCaptureSession? {
        get {
            return videoPreviewLayer.session
        } set {
            videoPreviewLayer.session = newValue
        }
    }
    
    private var maskLayer = [CAShapeLayer]()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    init(delegate: CameraViewDelegate, observed: ObservableScan) {
        self.delegate = delegate
        self.observableScan = observed
        super.init(frame: .zero)
        captureSession = AVCaptureSession()
        setupCaptureSession()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupCaptureSession() {
        captureSession?.beginConfiguration()
        captureSession?.sessionPreset = .high
        var defaultVideoDevice: AVCaptureDevice?
        if let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: .back) {
            defaultVideoDevice = dualCameraDevice
        } else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) {
            defaultVideoDevice = backCameraDevice
        } else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) {
            defaultVideoDevice = frontCameraDevice
        }
        guard defaultVideoDevice != nil else {
            captureSession?.commitConfiguration()
            captureSession = nil
            return
        }
        let input = try! AVCaptureDeviceInput(device: defaultVideoDevice!)
        captureSession?.addInput(input as AVCaptureInput)
        let captureMetadataOutput = AVCaptureVideoDataOutput()
        captureMetadataOutput.alwaysDiscardsLateVideoFrames = true
        captureMetadataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as String): Int(kCVPixelFormatType_32BGRA)]
        captureMetadataOutput.alwaysDiscardsLateVideoFrames = true
        let outputQueue = DispatchQueue(label: "outputQueue")
        captureMetadataOutput.setSampleBufferDelegate(self, queue: outputQueue)
        captureSession?.addOutput(captureMetadataOutput)
        captureSession?.commitConfiguration()
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
    }
    
    func startCaptureSession() {
        captureSession?.startRunning()
    }
    
    func stopCaptureSession() {
        captureSession?.stopRunning()
    }
    
    func buffer(from image: UIImage? ) -> CVPixelBuffer? {
        if let image = image {
            let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
            var pixelBuffer : CVPixelBuffer?
            let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
            guard (status == kCVReturnSuccess) else {
              return nil
            }

            CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
            let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
            let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

            context?.translateBy(x: 0, y: image.size.height)
            context?.scaleBy(x: 1.0, y: -1.0)

            UIGraphicsPushContext(context!)
            image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            UIGraphicsPopContext()
            CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

            return pixelBuffer
        }
        return nil

    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        
        //guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else
        guard var pixelBuffer1 : CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else

        {
            return
        }
        
        image = UIImage(pixelBuffer: self.resize(pixelBuffer: pixelBuffer1)!)
        image = image?.rotate(radians: .pi/2)
        
        
        
        guard let pixelBuffer = buffer(from: image) else {return }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        /* Initialise Core ML model
         We create a model container to be used with VNCoreMLRequest based on our HandSigns Core ML model.
         */
        guard let handSignsModel = try? VNCoreMLModel(for: model_5().model) else { return }
    
        
        if self.observableScan.counter > 0 { return }

        DispatchQueue.main.async {
           
            self.observableScan.counter = 5
        }
        /* Create a Core ML Vision request
         The completion block will execute when the request finishes execution and fetches a response.
         */
        let request =  VNCoreMLRequest(model: handSignsModel) { (finishedRequest, err) in
            
            /* Dealing with the result of the Core ML Vision request
             The request's result is an array of VNClassificationObservation object which holds
             identifier
             confidence - The confidence on the prediction made by the model on a scale of 0 to 1
             */
            
            
            guard let results = finishedRequest.results as? [VNClassificationObservation] else { return }
            //print(results)
            /* Results array holds predictions iwth decreasing level of confidence.
             Thus we choose the first one with highest confidence. */
            guard let firstResult = results.first else { return }
            
            var predictionString = ""
            
            /* Depending on the identifier we set the UILabel text with it's confidence.
             We update UI on the main queue. */
            DispatchQueue.main.async {
                switch firstResult.identifier {
                case Alphabet.A.rawValue:
                    predictionString = "A"
                case Alphabet.B.rawValue:
                    predictionString = "B"
                case Alphabet.C.rawValue:
                    predictionString = "C"
                case Alphabet.D.rawValue:
                    predictionString = "D"
                case Alphabet.E.rawValue:
                    predictionString = "E"
                case Alphabet.F.rawValue:
                    predictionString = "F"
                case Alphabet.G.rawValue:
                    predictionString = "G"
                case Alphabet.H.rawValue:
                    predictionString = "H"
                case Alphabet.I.rawValue:
                    predictionString = "I"
                case Alphabet.J.rawValue:
                    predictionString = "J"
                case Alphabet.K.rawValue:
                    predictionString = "K"
                case Alphabet.L.rawValue:
                    predictionString = "L"
                case Alphabet.M.rawValue:
                    predictionString = "M"
                case Alphabet.N.rawValue:
                    predictionString = "N"
                case Alphabet.O.rawValue:
                    predictionString = "O"
                case Alphabet.P.rawValue:
                    predictionString = "P"
                case Alphabet.Q.rawValue:
                    predictionString = "Q"
                case Alphabet.R.rawValue:
                    predictionString = "R"
                case Alphabet.S.rawValue:
                    predictionString = "S"
                case Alphabet.T.rawValue:
                    predictionString = "T"
                case Alphabet.U.rawValue:
                    predictionString = "U"
                case Alphabet.V.rawValue:
                    predictionString = "V"
                case Alphabet.W.rawValue:
                    predictionString = "W"
                case Alphabet.X.rawValue:
                    predictionString = "X"
                case Alphabet.Y.rawValue:
                    predictionString = "Y"
                case Alphabet.Z.rawValue:
                    predictionString = "Z"
                default:
                    predictionString = ""
                }
                
                let arrayOfText: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
                if arrayOfText.contains(predictionString){
                    self.observableScan.letter = predictionString
                    
                    self.observableScan.sequence.append(Character(predictionString))
                }
                
                //                if self.observableScan.sample.count <= 20 {
                //                    self.observableScan.sample.append(predictionString)
                //                }else{
                //                    var counts = [0 , 0, 0 ,0,0 ,0,0 ,0,0 ,0,0 ,0,0 ,0,0 ,0,0 ,0,0 ,0,0 ,0,0 ,0,0 ,0 ]
                //                    let arrayOfText: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
                //                    for i in self.observableScan.sample {
                //                        guard let letterIndex: Int = arrayOfText.firstIndex(of: i) else {continue}
                //                        counts[letterIndex] += 1
                //                    }
                //                    let index: Int = counts.firstIndex(of: counts.max()!)!
                //                    self.observableScan.letter = arrayOfText[index]
                //
                //                    self.observableScan.sequence.append(Character(arrayOfText[index]))
                //                    //self.observableScan.confidence = firstResult.confidence
                //                    self.observableScan.sample = []
                //
                //                }
                
            }
            
        }
        /* Perform the above request using Vision Image Request Handler
         We input our CVPixelbuffer to this handler along with the request declared above.
         */
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])

        //try? VNImageRequestHandler(ciImage: ciImage, orientation: .up, options: [VNImageOption.cameraIntrinsics:true]).perform([request])
        
        
    }
    
    func resize(pixelBuffer: CVPixelBuffer) -> CVPixelBuffer? {
        let imageSize = 224
        
        
        var ciImage = CIImage(cvPixelBuffer: pixelBuffer, options: [CIImageOption.applyOrientationProperty: true])
        let transform = CGAffineTransform(scaleX: 70 / CGFloat(CVPixelBufferGetWidth(pixelBuffer)), y: 70 / CGFloat(CVPixelBufferGetHeight(pixelBuffer)))
        ciImage = ciImage.transformed(by: transform)//.cropped(to: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        
        let ciContext = CIContext()
        var resizeBuffer: CVPixelBuffer?
        CVPixelBufferCreate(kCFAllocatorDefault, imageSize, imageSize, CVPixelBufferGetPixelFormatType(pixelBuffer), nil, &resizeBuffer)
        ciContext.render(ciImage, to: resizeBuffer!)
        return resizeBuffer
    }
}


extension CGImagePropertyOrientation {
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}
extension UIImage.Orientation {
    init(_ cgOrientation: UIImage.Orientation) {
        switch cgOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}

//extension CameraViewUIKit: AVCaptureVideoDataOutputSampleBufferDelegate {
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else
//        {
//            return
//        }
//
//
//
//        /* Initialise Core ML model
//         We create a model container to be used with VNCoreMLRequest based on our HandSigns Core ML model.
//         */
//        guard let handSignsModel = try? VNCoreMLModel(for: Model().model) else { return }
//
//        /* Create a Core ML Vision request
//         The completion block will execute when the request finishes execution and fetches a response.
//         */
//        let request =  VNCoreMLRequest(model: handSignsModel) { (finishedRequest, err) in
//
//            /* Dealing with the result of the Core ML Vision request
//             The request's result is an array of VNClassificationObservation object which holds
//             identifier
//             confidence - The confidence on the prediction made by the model on a scale of 0 to 1
//             */
//            guard let results = finishedRequest.results as? [VNClassificationObservation] else { return }
//
//            /* Results array holds predictions iwth decreasing level of confidence.
//             Thus we choose the first one with highest confidence. */
//            guard let firstResult = results.first else { return }
//
//
//            var predictionString = ""
//
//            /* Depending on the identifier we set the UILabel text with it's confidence.
//             We update UI on the main queue. */
//            DispatchQueue.main.async {
//                switch firstResult.identifier {
//                case Alphabet.A.rawValue:
//                    predictionString = "A"
//                case Alphabet.B.rawValue:
//                    predictionString = "B"
//                case Alphabet.C.rawValue:
//                    predictionString = "C"
//                case Alphabet.D.rawValue:
//                    predictionString = "D"
//                case Alphabet.E.rawValue:
//                    predictionString = "E"
//                case Alphabet.F.rawValue:
//                    predictionString = "F"
//                case Alphabet.G.rawValue:
//                    predictionString = "G"
//                case Alphabet.H.rawValue:
//                    predictionString = "H"
//                case Alphabet.I.rawValue:
//                    predictionString = "I"
//                case Alphabet.J.rawValue:
//                    predictionString = "J"
//                case Alphabet.K.rawValue:
//                    predictionString = "K"
//                case Alphabet.L.rawValue:
//                    predictionString = "L"
//                case Alphabet.M.rawValue:
//                    predictionString = "M"
//                case Alphabet.M.rawValue:
//                    predictionString = "O"
//                case Alphabet.M.rawValue:
//                    predictionString = "P"
//                case Alphabet.M.rawValue:
//                    predictionString = "Q"
//                case Alphabet.M.rawValue:
//                    predictionString = "R"
//                case Alphabet.M.rawValue:
//                    predictionString = "S"
//                case Alphabet.M.rawValue:
//                    predictionString = "T"
//                case Alphabet.M.rawValue:
//                    predictionString = "U"
//                case Alphabet.M.rawValue:
//                    predictionString = "V"
//                case Alphabet.M.rawValue:
//                    predictionString = "W"
//                case Alphabet.M.rawValue:
//                    predictionString = "X"
//                case Alphabet.M.rawValue:
//                    predictionString = "Y"
//                case Alphabet.M.rawValue:
//                    predictionString = "Z"
//                default:
//                    break
//                }
//
//
//
//            }
//            self.observableScan.letter = predictionString
//                           self.observableScan.confidence = firstResult.confidence
//        }
//        /* Perform the above request using Vision Image Request Handler
//         We input our CVPixelbuffer to this handler along with the request declared above.
//         */
//        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
//
//
//    }
//
//}
