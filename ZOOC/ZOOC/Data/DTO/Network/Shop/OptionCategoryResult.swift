//
//  OptionCategoriesResult.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/04.
//

import Foundation

struct OptionCategoryResult: Codable {
    let name: String
    let options: [OptionResult]
    
    init(name: String = String(),
         options: [OptionResult] = []) {
        self.name = name
        self.options = options
    }
}

