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
    @ObservedObject var scanData: ObservableScan
    
    var body: some View {
        ZStack {
            CameraViweWrapper(viewController: CameraViewController(observed: scanData))
            VStack { LottieView(fileName: "3165-loader") }.offset(x: 0, y: -100)
            CameraControlLayerView(scanData: self.scanData)
            
            Text("\(scanData.counter)").bold().font(.system(size: 50)).foregroundColor(Color.white).opacity(0.8).frame(minWidth: 0, maxWidth: .infinity).offset(x: 0, y: -100)
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
