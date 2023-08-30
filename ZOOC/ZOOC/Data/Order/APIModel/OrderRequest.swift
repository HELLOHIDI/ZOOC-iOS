//
//  OrderRequest.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/30.
//

import Foundation

struct OrderRequest: Codable {
    let productIds: [Int]
    let ordererName: String
    let ordererPhone: String
    let addressName: String
    let receiverName: String
    let receiverPhone: String
    let address: String
    let postcode: String
    let detailAddress: String?
    let request: String?
    let deliveryFee: Int
    let totalPrice: Int
    
    init(orderer: OrderOrderer,
         address: OrderAddress,
         product: OrderProduct,
         price: OrderPrice) {
        
        self.productIds = [product.id]
        self.ordererName = orderer.name
        self.ordererPhone = orderer.phoneNumber
        self.addressName = address.addressName
        self.receiverName = address.receiverName
        self.receiverPhone = address.receiverPhoneNumber
        self.address = address.address
        self.postcode = address.postCode
        self.detailAddress = address.detailAddress
        self.request = address.request
        self.deliveryFee = price.deliveryFee
        self.totalPrice = price.totalPrice
    }
    
}
