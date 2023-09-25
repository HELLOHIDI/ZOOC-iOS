//
//  OrderInvalid.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/29.
//

import Foundation

enum OrderInvalidError: Error {
    case ordererInvalid
    case addressInvlid
    case paymentMethodInvalid
    case agreementInvalid
    case noAddressSelected
    
    var message: String {
        switch self {
        case .ordererInvalid:
            return "구매자 정보를 모두 입력해주세요"
        case .addressInvlid:
            return "필수 배송 정보를 모두 입력해주세요"
        case .paymentMethodInvalid:
            return "결제수단을 선택해주세요"
        case .agreementInvalid:
            return "필수 동의 항목을 확인해주세요"
        case .noAddressSelected:
            return "선택된 주소지가 없습니다."
        }
    }
}
