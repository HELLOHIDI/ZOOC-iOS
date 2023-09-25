//
//  SavedProductObject.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/08.
//

import Foundation

import RealmSwift

class CartedProduct: Object {
    
    @Persisted(primaryKey: true) var optionID: Int
    @Persisted var productID: Int
    @Persisted var name: String = ""
    @Persisted var option: String = ""
    @Persisted var image: String = ""
    @Persisted var price: Int = 0
    @Persisted var pieces: Int = 0
    
    @Persisted var petID: Int = 0
    
    var productsPrice: Int {
        price * pieces
    }
    
    convenience init(petID: Int,
                     product: ProductDetailResult,
                     selectedProduct: SelectedProductOption) {
        self.init()
        self.petID = petID
        
        self.productID = product.id
        self.name = product.name
        self.image = product.images.first ?? ""
        self.optionID = selectedProduct.id
        self.option = selectedProduct.option
        self.price = selectedProduct.price
        self.pieces = selectedProduct.pieces
    }
}
