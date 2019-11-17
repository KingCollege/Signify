//
//  RootView.swift
//  Signify
//
//  Created by mandu shi on 17/11/2019.
//  Copyright © 2019 mandu. All rights reserved.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var textFieldObsver = TextFieldObservable()
    @State var offset: CGFloat = .zero
    @State var index = 2
    
    var navigation: some View {
        HStack{
            NavigationBtn(selected: false, iconName: "book.fill", name: "Dictionary")
            Spacer()
            CameraBtn()
            Spacer()
            NavigationBtn(selected: true, iconName: "textformat.size", name: "Translate")
        }
    }
    
    var body: some View {
       ZStack{
            CameraView()
            .frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)
                .offset(x: self.offset - UIScreen.main.bounds.width, y: 0)

            CameraView()
                .frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)
                .offset(x: self.offset, y: 0)
            TranslatorView(textFieldObsver: self.textFieldObsver)
                    .frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)
                .offset(x: self.offset + UIScreen.main.bounds.width, y: 0)
        VStack{
            Spacer()
            navigation.padding().frame(width: UIScreen.main.bounds.width)
        }.frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)
            
       }
       .gesture(DragGesture(minimumDistance: 10, coordinateSpace: .global).onEnded { value in
           if (value.translation.width > 50 && self.index == 2) {
               self.offset = UIScreen.main.bounds.width
               self.index = 1
           } else if(value.translation.width < 50 && self.index == 2) {
               self.offset = -UIScreen.main.bounds.width
               self.index = 3
           }
           
           if(value.translation.width < 50 && self.index == 1) {
               self.offset = 0
               self.index = 2
           }
           
           if(value.translation.width > 50 && self.index == 3) {
               self.offset = 0
               self.index = 2
           }
       }).animation(Animation.spring().speed(1.25))
       .frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
