//
//  ContentView.swift
//  Signify
//
//  Created by mandu shi on 16/11/2019.
//  Copyright © 2019 mandu. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    //let cameraViewController: CameraViewController
    @ObservedObject var scanData = ObservableScan()
    
    
    init() {
        //self.cameraViewController = CameraViewController(observed: scanData)

    }
    
    var body: some View {
        ZStack {
            CameraViweWrapper(viewController: CameraViewController(observed: scanData))
           
            CameraControlLayerView(scanData: self.scanData)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
