//
//  OptionResult.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/04.
//

import Foundation

struct OptionResult: Codable {
    let id: Int
    let name: String
    let additionalPrice: Int
    let totalPrice: Int
}


extension OptionResult {
    func transform(withImage image: String) -> SelectedProductOption {
        return SelectedProductOption(id: id,
                                     name: name,
                                     image: image,
                                     price: totalPrice)
    }
}
