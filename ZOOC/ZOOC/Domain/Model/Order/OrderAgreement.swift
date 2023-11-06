//
//  OrderAgreement.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/29.
//

import Foundation

struct OrderAgreement {
    var agreeWithOnwardTransfer: Bool
    var agreeWithTermOfUse: Bool
    
    init() {
        self.agreeWithOnwardTransfer = false
        self.agreeWithTermOfUse = false
    }
}
