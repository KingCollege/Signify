//
//  ObservableScan.swift
//  Signify
//
//  Created by Torge Adelin on 17/11/2019.
//  Copyright © 2019 mandu. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


var image: UIImage? = nil

final class ObservableScan: ObservableObject {
    
    @Published var sequence:Array<Character> = []
    @Published var letter:String = "_"
    @Published var confidence:Float  = 0.0
    @Published var sample: [String] = []
    @Published var counter = 5
    
    init() {
        let _ = countDown.receive(on: RunLoop.main).assign(to: \.counter, on: self)
    }
     
    var countDown: AnyPublisher<Int, Never> {
        return $counter.debounce(for: 1, scheduler: RunLoop.main).map{ args in
            return args - 1
        }.eraseToAnyPublisher()
    }
    
}
