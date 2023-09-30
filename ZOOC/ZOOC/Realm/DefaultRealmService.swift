//
//  RealmService.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/08.
//

import Foundation

import RealmSwift

protocol RealmService {
    
    // 장바구니
    func getCartedProducts() async -> [CartedProduct]
    func getCartedProduct(optionID: Int) async -> CartedProduct?
    func setCartedProduct(_ newProduct: CartedProduct) async
    func updateCartedProductPieces(optionID: Int, isPlus: Bool) async throws
    func deleteCartedProduct(_ product: CartedProduct) async 
    
    // 기존 배송지
    func getBasicAddress() -> Results<OrderBasicAddress>
    func getSelectedAddress() -> OrderBasicAddress?
    func setAddress(_ newAddress: OrderBasicAddress)
    func updateBasicAddress(_ data: OrderAddress) throws
    func resetBasicAddressSelected()
}

final class DefaultRealmService: RealmService {
    
    static let shared = DefaultRealmService()
    
    private let localRealm: Realm
    
    private init() {
        do {
            localRealm = try Realm()
            print("Realm Location: ", localRealm.configuration.fileURL ?? "cannot find location.")
        } catch {
            fatalError("Failed to initialize local Realm: \(error)")
        }
    }
    
    //MARK: - 장바구니 Realm
    
    @MainActor
    func getCartedProducts() async -> [CartedProduct] {
        let realm = try! await Realm()
        return realm.objects(CartedProduct.self).toArray(ofType: CartedProduct.self) as [CartedProduct]
    }
    
    @MainActor
    func getCartedProduct(optionID: Int) async -> CartedProduct? {
        let realm = try! await Realm()
        return realm.objects(CartedProduct.self).filter("optionID == \(optionID)").first
    }
    
    @MainActor
    func updateCartedProductPieces(optionID: Int, isPlus: Bool) async throws {
        let realm = try! await Realm()
        
        let delta = isPlus ? +1 : -1
        
        guard let product = await getCartedProduct(optionID: optionID) else { return }
        
        if isPlus {
            guard product.pieces < 1000 else { throw AmountError.increase }
        } else {
            guard product.pieces > 1 else { throw AmountError.decrease }
        }
        try! realm.write {
            product.pieces += delta
        }
    }
    
    @MainActor
    func deleteCartedProducts() async {
        let realm = try! await Realm()
        
        try! realm.write {
            let products = realm.objects(CartedProduct.self)
            realm.delete(products)
        }
    }
    
    
 
    @MainActor
    func setCartedProduct(_ newProduct: CartedProduct) async {
        let realm = try! await Realm()
        
        if let existedProduct = await getCartedProduct(optionID: newProduct.optionID) {
            try! realm.write {
                realm.create(CartedProduct.self,
                                  value: ["optionID": newProduct.optionID,
                                          "pieces": existedProduct.pieces + newProduct.pieces],
                                  update: .modified)
            }
        } else {
            try! realm.write {
                realm.add(newProduct, update: .modified)
            }
        }
        
    }
    
    @MainActor
    func deleteCartedProduct(_ product: CartedProduct) async {
        let realm = try! await Realm()
        try! realm.write {
            realm.delete(product)
        }
    }
    
    //MARK: - 기존 배송지
    
    @MainActor
    func getBasicAddress() -> Results<OrderBasicAddress> {
        return localRealm.objects(OrderBasicAddress.self).sorted(byKeyPath: "isSelected", ascending: false)
    }
    
    @MainActor
    func getSelectedAddress() -> OrderBasicAddress? {
        return localRealm.objects(OrderBasicAddress.self).filter("isSelected == true").first
    }
    
    @MainActor
    func updateBasicAddress(_ data: OrderAddress) {
        let newAddress = OrderBasicAddress(postCode: data.postCode,
                                           name: data.receiverName,
                                           address: data.address,
                                           detailAddress: data.detailAddress,
                                           phoneNumber: data.receiverPhoneNumber,
                                           request: data.request,
                                           isSelected: false)
        
        let filter = getBasicAddress().filter("fullAddress=='\(newAddress.fullAddress)'")
        
        if filter.isEmpty {
            self.setAddress(newAddress)
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
        let basicAddress = getBasicAddress()
        
        try! localRealm.write {
            basicAddress.forEach {
                $0.isSelected = false
            }
            basicAddress.first?.isSelected = true
        }
    }
    
    @MainActor
    func selectBasicAddress(_ object: OrderBasicAddress) {
        let objects = getBasicAddress()
        try! localRealm.write {
            objects.forEach { data in
                data.isSelected = false
            }
            object.isSelected = true
        }
    }
    
    @MainActor
    func updateBasicAddressRequest(_ object: OrderBasicAddress, request: String) {
        try! localRealm.write {
            object.request = request
        }
    }
   
}
     
