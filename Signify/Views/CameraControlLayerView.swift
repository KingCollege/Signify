//
//  CameraControlLayerView.swift
//  Signify
//
//  Created by Torge Adelin on 16/11/2019.
//  Copyright © 2019 mandu. All rights reserved.
//

import SwiftUI

struct CameraControlLayerView: View {
    @ObservedObject var scanData: ObservableScan
    @State var isVisible = false
    
    var body: some View {
      
        VStack(alignment: .leading) {
            HStack {
                Text("Sign Language \nto Text")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .padding(.top, 30)
                Spacer()
                NavigationLink(destination: QuizView()) {
                Image(systemName: "bolt.horizontal.circle.fill")
                    .resizable().frame(width: 30, height: 30)
                    .foregroundColor(Color.white)
                }.onTapGesture {
                    self.isVisible.toggle()
                }
            }
            Spacer()
            ResultCard(letter: scanData.letter, sequence: $scanData.sequence, scanData: scanData)
            
        }.padding(.horizontal)
            .padding(.top, 64)
            .padding(.bottom, 44)
            .sheet(isPresented: $isVisible) {
                    QuizView()
        }
            
        }
    }


struct ResultCard: View {
    var letter: String
    @Binding var sequence: Array<Character>
    var scanData: ObservableScan
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            //            if image != nil{
            //                Image(uiImage: image!)
            //            }
            
            BlurView(style: .systemUltraThinMaterialLight)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 230)
                .cornerRadius(15)
            VStack(alignment:.leading) {
                Text("Current Letter")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(Color.white.opacity(0.6))
                VStack {
                    Text(self.letter)
                        .font(.system(size: 85))
                        .fontWeight(.light)
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 5)
                        .lineLimit(1)
                }.frame(minWidth: 0, maxWidth: .infinity)
                Text("Sequence")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(Color.white.opacity(0.6))
                HStack {
                    Text(String(self.sequence))
                        .font(.title)
                        .foregroundColor(Color.white)
                        .lineLimit(1)
                    Spacer()
                    
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color.white)
                        .onTapGesture {
                            self.scanData.letter = "_"
                            self.scanData.sequence = []
                            print("This")
                    }
                    
                    
                }
            }.padding(20)
        }.padding(.bottom, 90)
        
    }
}



