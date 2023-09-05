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
    let price: Int
    let images: [String]
    let type: String
    let optionCategories: [OptionCategoriesResult]
}

