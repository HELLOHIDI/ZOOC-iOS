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
}

