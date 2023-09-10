//
//  OrderError.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/11.
//

import Foundation

enum OrderError: Error {
    case existedAddress
    case orederFail
    
    var message: String {
        switch self {
        case .existedAddress:
            return "이미 존재하는 주소입니다."
        case .orederFail:
            return "주문에 실패했습니다. 다시 시도해주세요."
        }
    }
}
