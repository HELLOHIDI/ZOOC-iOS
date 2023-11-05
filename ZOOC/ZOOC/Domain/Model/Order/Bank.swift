//
//  Bank.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/31.
//

import UIKit

enum Bank: CaseIterable {
    case toss
    case kakaoBank
    case kakaoPay
    case kbStarBanking
    case bankSalad
    
    var urlSchema: String {
        switch self {
        case .toss:
            return "supertoss://"
        case .kakaoBank:
            return "kakaobank://"
        case .kakaoPay:
            return "kakaopay://"
        case .kbStarBanking:
            return "kbbank://"
        case .bankSalad:
            return "banksalad://"
            
        }
    }
}
