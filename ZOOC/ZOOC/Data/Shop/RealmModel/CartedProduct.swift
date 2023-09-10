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
    
    var productsPrice: Int {
        price * pieces
    }
    
    convenience init(product: ProductDetailResult,
                     selectedProductOption: SelectedProductOption) {
        self.init()
        self.productID = product.id
        self.name = product.name
        self.image = product.images.first ?? ""
        self.optionID = selectedProductOption.id
        self.option = selectedProductOption.option
        self.price = selectedProductOption.price
        self.pieces = selectedProductOption.amount
    }
}
