//
//  ViewRouter.swift
//  Signify
//
//  Created by mandu shi on 17/11/2019.
//  Copyright © 2019 mandu. All rights reserved.
//

import Foundation
import Combine
import SwiftUI


enum ViewName: String {
    case TranslatorView
    case ContentView
}


final class ViewRouter: ObservableObject {
    @Published var current = ""
    var previousViews: [String] = []
    
    init(initial: String){
        current = initial
    }
    
    func appendView(view: String) {
        previousViews.append(view)
    }
    
    func popView() -> String? {
        return previousViews.popLast()
    }
}
