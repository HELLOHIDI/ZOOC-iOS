//
//  ProductSelectedOption.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/02.
//

import Foundation

struct SelectedProductOption {
    let id: Int
    let option: String
    let price: Int
    
    var pieces: Int {
        willSet(newValue) {
            self.pieces = (newValue < 1) ? 1 : newValue
        }
    }
    
    var productsPrice: Int {
        price * pieces
    }
    
    
    init(id: Int,
         option: String,
         price: Int,
         amount: Int = 1) {
        
        self.id = id
        self.option = option
        self.price = price
        self.pieces = amount
    }
}

extension SelectedProductOption {
    mutating func increase() throws {
        guard pieces < 1000 else { throw AmountError.increase }
        pieces += 1
    }
    
    mutating func decrease() throws {
        guard pieces > 1 else { throw AmountError.decrease }
        pieces -= 1
        
    }
}
