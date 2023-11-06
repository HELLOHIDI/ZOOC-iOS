//
//  OrderToastCase.swift
//  ZOOC
//
//  Created by 장석우 on 2023/10/07.
//

import Foundation

enum OrderToastCase: ToastCase {
    
    case orderSuccess
    case ordererInvalid
    case addressInvlid
    case paymentMethodInvalid
    case agreementInvalid
    case noAddressSelected
    case serverFail
    case custom(message: String)
    case unknown

    var message: String {
        switch self {
        case.orderSuccess:
            return ""
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
        case .serverFail:
            return "서버 오류가 발생했어요"
        case .custom(message: let message):
            return message
        case .unknown:
            return "알 수 없는 오류가 발생했어요"
        }
    }
    
    var type: Toast.ToastType {
        switch self {
        case .orderSuccess:
            return .good
        default: return .bad
            
        }
    }
}
