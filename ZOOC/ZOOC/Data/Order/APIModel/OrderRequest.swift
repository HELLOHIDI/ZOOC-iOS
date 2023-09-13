//
//  OrderRequest.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/30.
//

import Foundation

struct ProductRequest: Codable {
    let petId: Int
    let productId: Int
    let optionId: Int
    let pieces: Int
}

struct OrderRequest: Codable {
    let products: [ProductRequest]
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
         products: [OrderProduct],
         deliveryFee: Int) {
        
        self.products = products.map { $0.transform() }
        self.ordererName = orderer.name
        self.ordererPhone = orderer.phoneNumber
        self.addressName = address.addressName
        self.receiverName = address.receiverName
        self.receiverPhone = address.receiverPhoneNumber
        self.address = address.address
        self.postcode = address.postCode
        self.detailAddress = address.detailAddress
        self.request = address.request
        self.deliveryFee = deliveryFee
        self.totalPrice = products.reduce(0) { $0 + $1.productsPrice} + deliveryFee
    }
    
}
