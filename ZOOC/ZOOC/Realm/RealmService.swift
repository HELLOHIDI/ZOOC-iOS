//
//  RealmService.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/08.
//

import Foundation

import RealmSwift

final class RealmService {
    
    private let localRealm: Realm
    
    init() {
        do {
            localRealm = try Realm()
            print("Realm Location: ", localRealm.configuration.fileURL ?? "cannot find location.")
        } catch {
            fatalError("Failed to initialize local Realm: \(error)")
        }
    }
    
    //MARK: - 장바구니 Realm
    
    @MainActor
    func getCartedProducts() -> [CartedProduct] {
        return localRealm.objects(CartedProduct.self).toArray(ofType: CartedProduct.self) as [CartedProduct]
    }
    
    @MainActor
    func getCartedProduct(optionID: Int) -> CartedProduct? {
        return localRealm.objects(CartedProduct.self).filter("optionID == \(optionID)").first
    }
    
    @MainActor
    func updateCartedProductPieces(optionID: Int, isPlus: Bool) throws {
        let delta = isPlus ? +1 : -1
        
        guard let product = getCartedProduct(optionID: optionID) else { return }
        
        if isPlus {
            guard product.pieces < 1000 else { throw AmountError.increase }
        } else {
            guard product.pieces > 1 else { throw AmountError.decrease }
        }
        try! localRealm.write {
            product.pieces += delta
        }
    }
    
    
 
    @MainActor
    func setCartedProduct(_ newProduct: CartedProduct) {
        
        if let existedProduct = getCartedProduct(optionID: newProduct.optionID) {
            try! localRealm.write {
                localRealm.create(CartedProduct.self,
                                  value: ["optionID": newProduct.optionID,
                                          "pieces": existedProduct.pieces + newProduct.pieces],
                                  update: .modified)
            }
        } else {
            try! localRealm.write {
                localRealm.add(newProduct, update: .modified)
            }
        }
        
    }
    
    @MainActor
    func deleteCartedProduct(_ product: CartedProduct) {
        try! localRealm.write {
            localRealm.delete(product)
        }
    }
    
    //MARK: - 기존 배송지
    
    @MainActor
    func getBasicAddress() -> Results<OrderBasicAddress> {
        return localRealm.objects(OrderBasicAddress.self)
    }
    
    @MainActor
    func getSelectedAddress() -> OrderBasicAddress? {
        return localRealm.objects(OrderBasicAddress.self).filter("isSelected == true").first
    }
    
    @MainActor
    func updateBasicAddress(_ data: OrderAddress) throws {
        let fullAddress = "(\(data.postCode)) \(data.address)"
        let newAddress = OrderBasicAddress(postCode: data.postCode,
                                           name: data.receiverName,
                                           address: fullAddress,
                                           detailAddress: data.detailAddress,
                                           phoneNumber: data.receiverPhoneNumber,
                                           request: data.request,
                                           isSelected: false)
        
        let filter = getBasicAddress().filter("fullAddress=='\(newAddress.fullAddress)'")
        
        if filter.isEmpty {
            self.setAddress(newAddress)
        } else {
            throw OrderError.existedAddress
        }
    }
    
    @MainActor
    func setAddress(_ newAddress: OrderBasicAddress) {
        try! localRealm.write {
            localRealm.add(newAddress)
        }
    }
    
    @MainActor
    func resetBasicAddressSelected() {
        let basicAddress = localRealm.objects(OrderBasicAddress.self)
        
        try! localRealm.write {
            basicAddress.forEach {
                $0.isSelected = false
            }
            basicAddress.first?.isSelected = true
        }
    }
    
    
    
    
    
   
}
     
