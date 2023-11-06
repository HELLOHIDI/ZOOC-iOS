//
//  PaymentMethod.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/15.
//

import Foundation
import UIKit

enum PaymentType: CaseIterable {
    case withoutBankBook
    case kakaoPay
    case toss
    case mobile

    var image: UIImage? {

        switch self {
        case .withoutBankBook:
            return nil
        default:
            return nil
        }
    }

    var text: String {
        switch self {
        case .withoutBankBook:
            return "무통장 입금"
        default:
            return "아직 개발 전"
        }
    }
}
