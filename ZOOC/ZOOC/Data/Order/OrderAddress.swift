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
    var receiverPhoneNumber: String
    var address: String
    var postCode: String
    var detailAddress: String?
    var request: String?
    
    init() {
        self.addressName = ""
        self.receiverName = ""
        self.receiverPhoneNumber = ""
        self.address = ""
        self.postCode = ""
    }
}
