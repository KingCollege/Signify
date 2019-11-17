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
        HStack{
            Image(systemName: "textformat.size")
                .font(Font.body.weight(.bold))
                .foregroundColor(.white).animation(nil)
            Text( (self.textFieldObsver.editing && self.textFieldObsver.filteredText.count == 0) ? "Translating..." : "Done!")
                .bold()
                .foregroundColor(.white).animation(nil)
        }.frame(minWidth: 0, maxWidth: .infinity).padding().background(Color("greenishBlue"))
        .cornerRadius(10)
        
    }
    
    
    var body: some View {
        VStack(alignment: .center){
            VStack(alignment: .leading){
                Text("Translate Text to ").bold().font(.title)
                Text("Sign Language").bold().font(.title)
            }.padding(.top, 25).frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

            CustomTextField(textFieldObsver: textFieldObsver, iconName: "textformat.size")
            if self.textFieldObsver.filteredText.count > 0 {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center){
                        ForEach(self.textFieldObsver.filteredText, id: \.self) { letter in
                            SignLanguageCard(letter: letter)
                         }
                    }
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity).padding().font(.caption).transition(.opacity)
            }
            else{
                Text("Type something....")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .background(Color.white).opacity(0.7)
            }
            
            translateBnt.padding(.bottom, 100)
                .opacity((self.textFieldObsver.text.count  > 0 && self.textFieldObsver.editing) ? 1 : 0)

        }
        .padding().frame(minWidth: 0, maxWidth: .infinity)//.background(Color.yellow.opacity(0.1))

    }
}
