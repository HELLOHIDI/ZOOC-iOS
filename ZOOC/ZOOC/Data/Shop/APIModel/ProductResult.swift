//
//  ProductResult.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/04.
//

import Foundation

struct ProductResult: Codable {
    let id: Int
    let thumbnail: String
    let name: String
    let price: Int
    
    init(id: Int = Int(),
         thumbnail: String = String(),
         name: String = String(),
         price: Int = Int())
    {
        self.id = id
        self.thumbnail = thumbnail
        self.name = name
        self.price = price
    }
}
