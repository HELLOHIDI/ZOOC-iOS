//
//  OrderPrice.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/28.
//

import Foundation

struct OrderPrice {
    let productPrice: Int
    let deliveryFee: Int
    
    var totalPrice: Int {
        get {
            productPrice + deliveryFee
        }
    }
    
    init() {
        self.productPrice = 0
        self.deliveryFee = 0
    }
    
    init(productPrice: Int, deleiveryFee: Int) {
        self.productPrice = productPrice
        self.deliveryFee = deleiveryFee
    }
}

