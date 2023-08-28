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
    
    var message: String {
        switch self {
        case .ordererInvalid:
            return "구매자 정보를 입력해주세요."
        case .addressInvlid:
            return "배송지 정보를 입력해주세요."
        case .paymentMethodInvalid:
            return "결제수단을 확인해주세요."
        case .agreementInvalid:
            return "결제 진행 필수사항을 동의해주세요."
        }
    }
}
