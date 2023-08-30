//
//  WithoutBankbookStep.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/30.
//

import Foundation

enum WithoutBankBookStep: Int, CaseIterable {
    case copy = 1
    case deposit = 2
    case complete = 3
    
  
    var title: String {
        switch self {
        case .copy:
            return "계좌번호 복사"
        case .deposit:
            return "입금"
        case .complete:
            return "결제 완료"
        }
    }
    
    var cellHeight: CGFloat {
        switch self {
        case .copy:
            return 200
        case .deposit:
            return 540
        case .complete:
            return 200
        }
    }
}
