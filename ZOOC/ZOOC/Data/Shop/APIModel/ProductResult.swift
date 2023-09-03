//
//  Product.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/30.
//

import Foundation

struct ProductResult: Codable {
    let id: Int
    let name: String
    let price: Int
    let image: String
    let type: String
    let optionCategories: [OptionCategoriesResult]
}

struct OptionCategoriesResult: Codable {
    let name: String
    let options: [OptionResult]
}

struct OptionResult: Codable {
    let id: Int
    let name: String
}
