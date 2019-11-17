//
//  TextfieldObservable.swift
//  Signify
//
//  Created by mandu shi on 16/11/2019.
//  Copyright © 2019 mandu. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final class TextFieldObservable: ObservableObject {
    @Published var text: String = ""
    @Published var arrayOfText: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
}
