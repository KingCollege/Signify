import UIKit
import AVFoundation
import Vision
import Combine
import SwiftUI

protocol CameraViewDelegate: class {
    func cameraViewDidFoundSign(frame: CGRect)
    func cameraViewFoundNoSign()
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
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else
        {
            return
        }
        
        
        
        /* Initialise Core ML model
         We create a model container to be used with VNCoreMLRequest based on our HandSigns Core ML model.
         */
        guard let handSignsModel = try? VNCoreMLModel(for: Model().model) else { return }
        
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
                case Alphabet.M.rawValue:
                    predictionString = "O"
                case Alphabet.M.rawValue:
                    predictionString = "P"
                case Alphabet.M.rawValue:
                    predictionString = "Q"
                case Alphabet.M.rawValue:
                    predictionString = "R"
                case Alphabet.M.rawValue:
                    predictionString = "S"
                case Alphabet.M.rawValue:
                    predictionString = "T"
                case Alphabet.M.rawValue:
                    predictionString = "U"
                case Alphabet.M.rawValue:
                    predictionString = "V"
                case Alphabet.M.rawValue:
                    predictionString = "W"
                case Alphabet.M.rawValue:
                    predictionString = "X"
                case Alphabet.M.rawValue:
                    predictionString = "Y"
                case Alphabet.M.rawValue:
                    predictionString = "Z"
                default:
                    break
                }
                
                print(predictionString)
               self.observableScan.letter = predictionString
               self.observableScan.confidence = firstResult.confidence
                
            }
            
        }
        /* Perform the above request using Vision Image Request Handler
         We input our CVPixelbuffer to this handler along with the request declared above.
         */
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        
        
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
