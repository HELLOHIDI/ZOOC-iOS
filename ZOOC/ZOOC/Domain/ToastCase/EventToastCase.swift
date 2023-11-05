//
//  EventToast.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/22.
//

import Foundation

enum EventToastCase: ToastCase {
    
    case inProgress
    case appliedEventSuccess
    case appliedEventFail
    case ended
    case unknown
    
    var message: String {
        switch self {
            
        case .inProgress:
            return "이미지를 생성하고 있어요\n 잠시만 기다려주세요"
        case .appliedEventSuccess:
            return "이벤트 참여에 성공하셨습니다!"
        case .appliedEventFail:
            return "이벤트 참여에 실패했습니다!"
        case .ended:
            return "이벤트가 종료되었습니다 😭"
        case .unknown:
            return "알 수 없는 오류가 발생했어요"
        }
    }
    
    var type: Toast.ToastType {
        switch self {
        case .inProgress:
            return .normal
        case .appliedEventSuccess:
            return .good
        case .appliedEventFail:
            return .bad
        case .ended:
            return .normal
        case .unknown:
            return .bad
        }
    }
    
}

