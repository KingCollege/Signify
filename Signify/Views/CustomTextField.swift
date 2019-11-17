//
//  SearchBar.swift
//  Signify
//
//  Created by mandu shi on 16/11/2019.
//  Copyright © 2019 mandu. All rights reserved.
//

import SwiftUI

struct CustomTextField: View {
    @ObservedObject var textFieldObsver: TextFieldObservable
    private var iconName: String
    init (textFieldObsver: TextFieldObservable, iconName: String){
        self.textFieldObsver = textFieldObsver
        self.iconName = iconName
    }
    
    var body: some View {
        HStack{
            Image(systemName: iconName)
            .font(Font.body.weight(.bold))
            .foregroundColor(Color("lightGray"))
            TextField("Type Something...", text: $textFieldObsver.text, onEditingChanged: { value in
                if !value {
                    self.textFieldObsver.editing = false
                }
            }).autocapitalization(.allCharacters)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 30)
            .font(.headline)
        }.padding(.all, 10)
        .background(Color("lightGray")
        .opacity(0.25)).cornerRadius(10)
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(textFieldObsver: TextFieldObservable(), iconName: "textformat.size")
    }
}
