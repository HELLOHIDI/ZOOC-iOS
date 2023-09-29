//
//  ShopProductModel.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/30.
//

import Foundation

struct ShopProductModel {
    let petID: Int
    let productID: Int
    
    init(petID: Int = Int(),
         productID: Int = Int()) {
        self.petID = petID
        self.productID = productID
    }
}
