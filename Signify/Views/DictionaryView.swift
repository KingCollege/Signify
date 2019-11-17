//
//  DictionaryView.swift
//  ss
//
//  Created by dada on 16/11/2019.
//  Copyright © 2019 dada. All rights reserved.
//

import SwiftUI
import Foundation

struct DictionaryView: View {
    let screenTitle = "Dictionary"
    let alphabet = [["A","B","C"], ["D", "E", "F"], ["G", "H", "I"], ["J", "K", "L"],["M", "N", "O"],["P", "Q", "R"],["S", "T", "U"],["V", "W", "X"],["Y", "Z"]]
    
    
    @State var text = ""
    @State var isActive = false
    
    var body: some View {
        VStack {
            ZStack(){
                ScrollView(showsIndicators:false){
                    VStack(){
                        SearchBar(text: $text, isActiveField: $isActive)
                    }.padding(.horizontal).padding(.top, 45)
                    VStack(alignment:.leading){
                        ForEach(0..<alphabet.count, id: \.self) { index in
                            HStack(spacing:20) {
                                ForEach(self.alphabet[index].filter{$0.hasPrefix(self.text)}, id: \.self) { letter in
                                    CardView(title:letter, image:letter)
                                    
                                }
                                
                            }
                        }
                    }
                    BottomView()
                }
                
                
                GradientView()
                
            }
            
        }
        
    }
}

struct GradientView : View{
    var body: some View{
        VStack(){
            Spacer()
            Rectangle().fill(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0), Color.white.opacity(1)]), startPoint: .top, endPoint: .bottom)).frame(height: UIScreen.main.bounds.height/6, alignment:Alignment.bottomLeading)
        }.edgesIgnoringSafeArea(.bottom)
    }
}

struct BottomView : View{
    var body: some View{
        VStack(){
            Spacer()
            Rectangle().fill(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(1), Color.white.opacity(1)]), startPoint: .top, endPoint: .bottom)).frame(height: 70, alignment:Alignment.bottomLeading)
        }.edgesIgnoringSafeArea(.bottom)
    }
}

//
//struct BottomView : View{
//    var body: some View {
//        VStack(){
//            Spacer()
//            Rectangle().fill(.white).frame(width: .infinity, height: 50)
//    }.edgesIgnoringSafeArea(.bottom)
//}
//}


struct CardView :View{
    let title: String
    let image: String
    
    init(title: String, image: String) {
        self.title = title
        self.image = image
        
    }
    
    var body : some View{
        VStack() {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .padding(.top)
            
            Text(title)
                .font(.title)
                .foregroundColor(.black)
                .padding(.bottom)
        }
        .frame(width: UIScreen.main.bounds.width/3.8, height: UIScreen.main.bounds.height/6, alignment: Alignment.center)
        .background(Color("LightGrey"))
        .cornerRadius(10)
        .padding(.top)
    }
}

struct SearchBar: View {
    @Binding var text: String
    @Binding var isActiveField: Bool
    
    var isDisabled: Bool = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray)
                .opacity(0.2)
                .frame(height: 50)
                .cornerRadius(10)
            
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search", text: $text, onEditingChanged: { isActive in
                    self.isActiveField = isActive
                }).disabled(isDisabled)
                if !text.isEmpty {
                    Button(action: {
                        self.text = ""
                    }) {
                        Image(systemName: "multiply.circle")
                    }
                }
            }.padding()
        }.animation(.default)
    }
}



struct DictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryView()
    }
}
