//
//  ProductOption.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/02.
//

import Foundation

struct ProductOption {
    let id: Int
    let option: String
    let price: Int
}

extension ProductOption {
    func transform() -> ProductSelectedOption {
        return ProductSelectedOption(id: id,
                                     option: option,
                                     price: price)
    }
}
