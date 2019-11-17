//
//  CameraView.swift
//  Signify
//
//  Created by Torge Adelin on 16/11/2019.
//  Copyright © 2019 mandu. All rights reserved.
//

import SwiftUI
import UIKit
import AVFoundation

final class CameraViewController: UIViewController {
    @ObservedObject var scanData : ObservableScan
    init(observed: ObservableScan) {
        self.scanData = observed
        super.init(nibName: nil, bundle: nil)
        
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        let view = CameraViewUIKit(delegate: self, observed: scanData)
        self.view = view
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (view as? CameraViewUIKit)?.startCaptureSession()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (view as? CameraViewUIKit)?.stopCaptureSession()
    }
}

extension CameraViewController: CameraViewDelegate {
    
    func cameraViewDidFoundSign(frame: CGRect) {
        // to be called whenever we get a sign
        
    }

    func cameraViewFoundNoSign() {
        // to be called whenever we don't get a sign
    }
}
