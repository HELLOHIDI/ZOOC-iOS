//
//  OrderBasicAddress.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/04.
//

import UIKit

import RealmSwift

class OrderBasicAddress: Object {
    
    @Persisted(primaryKey: true) var fullAddress: String = ""
    @Persisted var postCode: String = ""
    @Persisted var name: String = ""
    @Persisted var address: String = ""
    @Persisted var detailAddress: String?
    @Persisted var phoneNumber: String = ""
    @Persisted var request: String?
    @Persisted var isSelected: Bool = false
    
    convenience init(postCode: String, name: String, address: String, detailAddress: String? = nil, phoneNumber: String, request: String? = nil, isSelected: Bool) {
        self.init()
        self.postCode = postCode
        self.name = name
        self.address = address
        self.detailAddress = detailAddress
        self.phoneNumber = phoneNumber
        self.request = request
        self.isSelected = isSelected
        self.fullAddress = "(\(postCode)) \(address) \(detailAddress ?? "")"
    }
}

extension OrderBasicAddress {
    func transform() -> OrderAddress {
        OrderAddress(addressName: "",
                     receiverName: name,
                     receiverPhoneNumber: phoneNumber,
                     address: address,
                     postCode: postCode,
                     detailAddress: detailAddress,
                     request: request)
    }
}
