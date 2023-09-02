//
//  ProductSelectedOption.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/02.
//

import Foundation

struct ProductSelectedOption {
    let id: Int
    let option: String
    let price: Int
    
    var amount: Int {
        willSet(newValue) {
            self.amount = (newValue < 1) ? 1 : newValue
        }
    }
    
    var totalPrice: Int {
        price * amount
    }
    
    
    init(id: Int,
         option: String,
         price: Int,
         amount: Int = 1) {
        
        self.id = id
        self.option = option
        self.amount = amount
        self.price = price
    }
}
