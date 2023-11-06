//
//  Product.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/30.
//

import Foundation

struct ProductDetailResult: Codable {
    let id: Int
    let name: String
    let description: String
    let price: Int
    let images: [String]
    let type: String
    let optionCategory: OptionCategoryResult
    
    init(id: Int = Int(),
         name: String = String(),
         description: String = String(),
         price: Int = Int(),
         images: [String] = [],
         type: String = String(),
         optionCategory: OptionCategoryResult = .init()) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.images = images
        self.type = type
        self.optionCategory = optionCategory
    }
}

