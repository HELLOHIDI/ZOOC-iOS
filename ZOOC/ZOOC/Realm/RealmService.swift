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
    func setCartedProduct(cartedProducts: CartedProduct) {
        try! localRealm.write {
            localRealm.add(cartedProducts, update: .all)
        }
    }
    
    @MainActor
    func deleteCartedProduct(_ product: CartedProduct) {
        try! localRealm.write {
            localRealm.delete(product)
        }
    }
    
    
    
    
   
}
     
