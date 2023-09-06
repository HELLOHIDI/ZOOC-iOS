//
//  OrderBasicAddress.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/04.
//

import UIKit

import RealmSwift

class OrderBasicAddress: Object {
    
    @Persisted(primaryKey: true) var postCode: String = ""
    @Persisted var name: String = ""
    @Persisted var address: String = ""
    @Persisted var detailAddress: String?
    @Persisted var phoneNumber: String = ""
    var isSelected: Bool = false
    
    convenience init(postCode: String, name: String, address: String, detailAddress: String? = nil, phoneNumber: String, isSelected: Bool) {
        self.init()
        self.postCode = postCode
        self.name = name
        self.address = address
        self.detailAddress = detailAddress
        self.phoneNumber = phoneNumber
        self.isSelected = isSelected
    }
}
