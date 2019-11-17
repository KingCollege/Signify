//
//  SwiftUIView.swift
//  Signify
//
//  Created by Torge Adelin on 17/11/2019.
//  Copyright © 2019 mandu. All rights reserved.
//

import SwiftUI

struct SwiftUIView: View {
    @State var viewState: CGFloat = 0.0
    @State var index = 2
    
    
    var body: some View {
        ZStack {
            Screen(str: "1").offset(x: viewState - UIScreen.main.bounds.width, y:0)
            Screen(str: "2").offset(x: viewState, y:0)
            Screen(str: "3").offset(x: viewState  + UIScreen.main.bounds.width, y:0)
        }.gesture(DragGesture(minimumDistance: 10, coordinateSpace: .local).onChanged{ value in
            
        }.onEnded { value in
            print(value.translation.width)
            print(self.index)
            if (value.translation.width > 50 && self.index == 2) {
                self.viewState = UIScreen.main.bounds.width
                self.index = 1
            } else if(value.translation.width < 50 && self.index == 2) {
                print("UI")
                self.viewState = -UIScreen.main.bounds.width
                self.index = 3
            }
            
            if(value.translation.width < 50 && self.index == 1) {
                self.viewState = 0
                self.index = 2
            }
            
            if(value.translation.width > 50 && self.index == 3) {
                self.viewState = 0
                self.index = 2
            }
        }).animation(Animation.spring().speed(1.25))
    }
}

struct Screen: View {
    var str: String = "a"
    var body: some View {
        VStack {
            Text(self.str)
        }.frame(width: 300, height: 300, alignment: .center)
            .background(Color.blue)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
