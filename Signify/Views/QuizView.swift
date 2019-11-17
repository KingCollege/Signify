//
//  QuizView.swift
//  Signify
//
//  Created by Torge Adelin on 17/11/2019.
//  Copyright © 2019 mandu. All rights reserved.
//

//
//  QuizView.swift
//  ss
//
//  Created by dada on 17/11/2019.
//  Copyright © 2019 dada. All rights reserved.
//

import Foundation
import SwiftUI

struct QuizView: View {
    let screenTitle = "Quiz"
    let alphabet = ["A","B","C","D", "E", "F","G", "H", "I","J", "K", "L","M", "N", "O","P", "Q", "R","S", "T", "U","V", "W", "X","Y", "Z"]
    @State var text = ""
    let randomNum = Int.random(in: 0 ..< 26)


   var body: some View {
    NavigationView {
    ZStack(){
        ScrollView(){
            QuizLayer(answer: alphabet[randomNum], image: alphabet[randomNum], text: $text)
        }.padding(.horizontal)
            .frame(minWidth: 0, maxWidth: .infinity)
        .navigationBarTitle(screenTitle)
        }
    }
    }
    
}

struct QuizLayer: View {
    var answer: String = ""
    var image: String = ""
    @Binding var text: String
    @State var defaultColor = Color.black
    
  

   var body: some View {
    VStack(){
               VStack() {
                   Image(image)
                   .resizable()
                   .scaledToFit()
                   .frame(width: 200, height: 200)
                    .padding(.top)
               }
               .frame(width: UIScreen.main.bounds.width/1.1, height: UIScreen.main.bounds.height/2.5, alignment: Alignment.center)
               .background(Color("LightGrey"))
               .cornerRadius(10)
               .padding(.top)
    
                Spacer()
        
        TextField("", text: $text).frame(width: UIScreen.main.bounds.width/6, alignment: Alignment.center).font(.system(size: 80)).foregroundColor(defaultColor) .accentColor(.black)
        
        Rectangle()
                 .fill(defaultColor)
                 .frame(width: UIScreen.main.bounds.width/2,height: 1.0, alignment: Alignment.center).edgesIgnoringSafeArea(.bottom)
        
        Spacer()
        
        Button(action: {
            print("asda")
            if(self.text == self.answer){
                self.defaultColor = Color.green
            }
            else{
                self.defaultColor = Color.red
            }
            
        }) {
            Text("Submit")
                .background(Color.white)
                .foregroundColor(.black)
                .font(.headline)
                .padding()
                .frame(width:UIScreen.main.bounds.width/2)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black, lineWidth: 2.5)
                )
        }
        
     
        
    }
    
    }
    
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
    }
}
