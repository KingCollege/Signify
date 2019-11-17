//
//  CameraViewWrapper.swift
//  Signify
//
//  Created by Torge Adelin on 16/11/2019.
//  Copyright © 2019 mandu. All rights reserved.
//

import SwiftUI

struct CameraViweWrapper: UIViewControllerRepresentable {

    typealias UIViewControllerType = CameraViewController
    typealias Context = UIViewControllerRepresentableContext

    let viewController: CameraViewController

    func makeUIViewController(context: Context<CameraViweWrapper>) -> CameraViewController {
        return viewController
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context<CameraViweWrapper>) {}
}

