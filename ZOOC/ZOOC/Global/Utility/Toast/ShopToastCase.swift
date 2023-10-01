//
//  ShopToast.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/30.
//

import Foundation

enum ShopToastCase: ToastCase {
    
    case commingSoon
    case cartedCompleted
    case notChooseOption
    case alreadySelectedOption
    case custom(message: String)
    case unknown
    
    var message: String {
        switch self {
            
        case .commingSoon:
            return "오픈 예정 상품이에요"
        case .cartedCompleted:
            return "상품이 장바구니에 담겼어요"
        case .notChooseOption:
            return "상품 옵션을 선택해주세요"
        case .alreadySelectedOption:
            return "이미 추가된 옵션이에요"
        case .custom(let message):
            return message
        case .unknown:
            return "알 수 없는 오류가 발생했어요"
        }
    }
    
    var type: Toast.ToastType {
        switch self {
            
        case .commingSoon:
            return .normal
        case .cartedCompleted:
            return .good
        case .notChooseOption:
            return .bad
        case .alreadySelectedOption:
            return .bad
        case .custom:
            return .bad
        case .unknown:
            return .bad
        }
    }
    
}
