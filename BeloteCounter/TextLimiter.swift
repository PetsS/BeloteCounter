//
//  TextLimiter.swift
//  BeloteCounter
//
//  Created by Peter Szots on 09/07/2022.
//

import Foundation

class TextLimiter: ObservableObject {
    var limit: Int
    
    init(limit: Int) {
        self.limit = limit
    }
    
    @Published var value = "" {
        didSet {
            if value.count > self.limit {
                value = String(value.prefix(self.limit))
            }
        }
    }
}
