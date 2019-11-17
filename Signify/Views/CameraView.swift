//
//  ContentView.swift
//  Signify
//
//  Created by mandu shi on 16/11/2019.
//  Copyright © 2019 mandu. All rights reserved.
//

import SwiftUI

struct CameraView: View {
    //let cameraViewController: CameraViewController
    @ObservedObject var scanData = ObservableScan()
    
    
    init() {
        //self.cameraViewController = CameraViewController(observed: scanData)

    }
    
    var body: some View {
        ZStack {
            CameraViweWrapper(viewController: CameraViewController(observed: scanData))
           
            CameraControlLayerView(scanData: self.scanData)
            
            Text("\(scanData.counter)").bold().font(.system(size: 80)).opacity(0.8).frame(minWidth: 0, maxWidth: .infinity)
        }.edgesIgnoringSafeArea(.all)
        .expand()
    }
}

extension View {
    func expand() -> some View {
        return frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )
    }
}
