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
}

