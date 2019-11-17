//
//  CameraBtn.swift
//  Signify
//
//  Created by mandu shi on 16/11/2019.
//  Copyright © 2019 mandu. All rights reserved.
//

import SwiftUI

struct CameraBtn: View {
    @Binding var offset: CGFloat
    var index: Int
    @Binding var current: Int
    var body: some View {
        Button(action: {
            if self.index == 2 {
                if self.current == 1 || self.current == 3 {
                    self.offset = 0
                    self.current = 2
                }
            }
        }){
            Text("✌🏻").font(.system(size: 80))
        }
    }
}
