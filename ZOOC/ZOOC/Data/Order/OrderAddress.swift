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
    
    init(addressName: String = "",
         receiverName: String = "",
         receiverPhoneNumber: String = "",
         address: String = "",
         postCode: String = "",
         detailAddress: String? = nil,
         request: String? = nil) {
        
        self.addressName = receiverName //TODO: - 리디자인 피그마에 배송지명 개념이 사라져서 receiverName으로 대체
        self.receiverName = receiverName
        self.receiverPhoneNumber = receiverPhoneNumber
        self.address = address
        self.postCode = postCode
        self.detailAddress = detailAddress
        self.request = request
        
    }
}
