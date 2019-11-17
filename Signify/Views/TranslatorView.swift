//
//  TranslatorView.swift
//  Signify
//
//  Created by mandu shi on 16/11/2019.
//  Copyright © 2019 mandu. All rights reserved.
//

import SwiftUI

struct TranslatorView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var textFieldObsver: TextFieldObservable
    @State var show = false
    var translateBnt: some View{
        Button(action: {
            if !self.show && self.textFieldObsver.text.count > 0 {
                self.textFieldObsver.arrayOfText = self.textFieldObsver.text.map { c in
                    return String(c).capitalized
                }
                withAnimation(.easeIn(duration: 0.5)){
                    self.show.toggle()
                }
            }
            else if self.show {
                self.textFieldObsver.text = ""
                self.textFieldObsver.arrayOfText = []
                self.show.toggle()
            }
        }){
            HStack{
                Image(systemName: "textformat.size")
                    .font(Font.body.weight(.bold))
                    .foregroundColor(.white).animation(nil)
                Text(!show ? "Translate" : "Clear")
                    .bold()
                    .foregroundColor(.white).animation(nil)
            }.frame(minWidth: 0, maxWidth: .infinity).padding()
        }
        .background(Color("greenishBlue"))
        .cornerRadius(10)
    }
    
    
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
        VStack(alignment: .center){
            VStack(alignment: .leading){
                Text("Translate Text to ").bold().font(.title)
                Text("Sign Language").bold().font(.title)
            }.padding(.top, 25).frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

            CustomTextField(textFieldObsver: textFieldObsver, iconName: "textformat.size")
            if show {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        ForEach(self.textFieldObsver.arrayOfText, id: \.self) { letter in
                            SignLanguageCard(letter: letter)
                         }
                    }
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity).padding().transition(.opacity)
            }
            else{
                Text("Type something....")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .background(Color.white)
            }
            translateBnt.padding(.bottom, 100)

        }
        .padding().frame(minWidth: 0, maxWidth: .infinity)

    }
}
