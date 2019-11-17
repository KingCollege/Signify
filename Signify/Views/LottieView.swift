//
//  LottieView.swift
//  Signify
//
//  Created by Torge Adelin on 17/11/2019.
//  Copyright © 2019 mandu. All rights reserved.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let animationView = AnimationView()
    var fileName = "LottieLogo"
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()
        let animation = Animation.named(fileName)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        animationView.loopMode = .loop
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
    
    }

}


