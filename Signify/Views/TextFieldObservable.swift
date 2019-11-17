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
    @Published var filteredText: [String] = []
    @Published var editing = false
    var cancel: AnyCancellable?
    
    init() {
        cancel = charPubliser.receive(on: RunLoop.main).assign(to: \.filteredText, on: self)
    }
    
    var charPubliser: AnyPublisher<[String], Never> {
        return $text.map{ s in
            self.filteredText = []
            if s.count > 0 {
                self.editing = true
            }
            return s.map{ l in return String(l)}
        }.debounce(for: 1, scheduler: RunLoop.main).eraseToAnyPublisher()
    }
}
