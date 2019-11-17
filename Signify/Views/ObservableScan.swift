//
//  ObservableScan.swift
//  Signify
//
//  Created by Torge Adelin on 17/11/2019.
//  Copyright © 2019 mandu. All rights reserved.
//

import Foundation



final class ObservableScan: ObservableObject {
    
    @Published var sequence:Array<Character> = []
    @Published var letter:String = "Nothing..."
    @Published var confidence:Float  = 0.0
    
    
}
