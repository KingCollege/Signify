//
//  DictionaryBtn.swift
//  Signify
//
//  Created by mandu shi on 16/11/2019.
//  Copyright © 2019 mandu. All rights reserved.
//

import SwiftUI

struct NavigationBtn: View {
    var selected = false
    var iconName = "book.fill"
    var height: CGFloat = 30
    var width: CGFloat = 36
    var name = "Name"
    
    var body: some View {
        Button(action: {}){
            VStack(spacing: 5){
                Image(systemName: iconName).resizable()
                    .frame(width: width, height: height)
                .foregroundColor(.black)
                Text(name).bold().foregroundColor(.black)
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Color("greenishBlue"))
                    .frame(minWidth: 0, maxWidth: 70, minHeight: 0, maxHeight: 5)
                    .opacity(selected ? 1 : 0)

            }

        }
    }
}

struct NavigationBtn_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBtn()
    }
}
