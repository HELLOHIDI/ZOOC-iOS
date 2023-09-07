//
//  AmountError.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/02.
//

import Foundation

enum AmountError: Error {
    case decrease
    case increase
    
    var message: String {
        switch self {
        case .decrease:
            return "상품 1개 미만 선택이 불가합니다."
        case .increase:
            return "최대 999개까지 주문 가능합니다."
        }
    }
}
