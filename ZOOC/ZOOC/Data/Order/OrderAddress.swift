//
//  Address.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/27.
//

import Foundation

struct OrderAddress {
    var addressName: String
    var receiverName: String
    var receiverPhoneNumber: Int?
    var address: String
    var postCode: String
    var detailAddress: String?
    
    init() {
        self.addressName = ""
        self.receiverName = ""
        self.address = ""
        self.postCode = ""
    }
}
