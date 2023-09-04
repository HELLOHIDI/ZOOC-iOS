//
//  ProductSelectedOption.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/02.
//

import Foundation

struct SelectedProductOption {
    let id: Int
    let name: String
    let image: String
    let price: Int
    
    var amount: Int {
        willSet(newValue) {
            self.amount = (newValue < 1) ? 1 : newValue
        }
    }
    
    var productsPrice: Int {
        price * amount
    }
    
    
    init(id: Int,
         name: String,
         image: String,
         price: Int,
         amount: Int = 1) {
        
        self.id = id
        self.name = name
        self.image = image
        self.price = price
        self.amount = amount
    }
}

extension SelectedProductOption {
    mutating func increase() throws {
        guard amount < 1000 else { throw AmountError.increase }
        amount += 1
    }
    
    mutating func decrease() throws {
        guard amount > 1 else { throw AmountError.decrease }
        amount -= 1
        
    }
}

extension SelectedProductOption {
    func transform() -> ProductOptionRequest {
        return ProductOptionRequest(optionId: id,
                                    pieces: amount)
    }
}
