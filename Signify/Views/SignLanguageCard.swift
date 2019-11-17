//
//  SignLanguageCard.swift
//  Signify
//
//  Created by mandu shi on 16/11/2019.
//  Copyright © 2019 mandu. All rights reserved.
//

import SwiftUI

struct SignLanguageCard: View {
    var letter = "A"
    var body: some View {
        VStack(spacing: 50){
            if letter != " " { Image(letter).resizable().frame(width: 60, height: 80) }
            else{ Text("")}
            Text(letter).bold().font(.system(size: 45))
        }.padding()
        .frame(width: 200, height: 300, alignment: .bottom)
        .background(Color.yellow.opacity(0.2))
        .cornerRadius(20).shadow(radius: 5)
    }
}

