//
//  DictionaryBtn.swift
//  Signify
//
//  Created by mandu shi on 16/11/2019.
//  Copyright © 2019 mandu. All rights reserved.
//

import SwiftUI

struct NavigationBtn: View {
    
    @Binding var offset: CGFloat
    var index: Int
    @Binding var current: Int
    var selected = false
    var iconName = "book.fill"
    var height: CGFloat = 25
    var width: CGFloat = 29
    var name = "Name"
    
    var body: some View {
        Button(action: {
            if self.index == 3{
                if self.current == 1 || self.current == 2{
                    self.offset = -UIScreen.main.bounds.width
                    self.current = 3
                }
                
            }
            else if self.index == 1 {
                if self.current == 3 || self.current == 2{
                    self.offset = UIScreen.main.bounds.width
                    self.current = 1
                }
                
            }
        }){
            VStack(spacing: 5){
                Image(systemName: iconName).resizable()
                    .frame(width: width, height: height)
                    .foregroundColor(self.current  == 2 ? .white : .black)
                Text(name)
                    .font(.caption).fontWeight(.bold).foregroundColor(self.current  == 2 ? .white : .black)
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Color("greenishBlue"))
                    .frame(minWidth: 0, maxWidth: 70, minHeight: 0, maxHeight: 5)
                    .opacity(selected ? 1 : 0)

            }

        }
    }
}

