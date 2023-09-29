//
//  ShopError.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/30.
//

import Foundation

enum ShopError: Error {
    case productNotFound
    
    var message: String {
        switch self {
        case .productNotFound:
            return "상품 정보를 불러올 수 없습니다"
        }
    }
}
