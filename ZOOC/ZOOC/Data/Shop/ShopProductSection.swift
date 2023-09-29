//
//  ShopProductSection.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/30.
//

import Foundation
import Differentiator

struct ShopProductSection {
    var items: [ProductResult]
}

extension ShopProductSection: SectionModelType {
  typealias Item = ProductResult

   init(original: ShopProductSection, items: [ProductResult]) {
    self = original
    self.items = items
  }
}
