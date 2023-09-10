//
//  OrderProduct.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/28.
//

import Foundation

struct OrderProduct {
    let productID: Int
    let name: String
    let image: String
    let price: Int
    
    let optionID: Int
    let option: String
    let pieces: Int
    
    var productsPrice: Int {
        price * pieces
    }
}

extension OrderProduct {
    
    init(product: ProductDetailResult,
         selectedProductOption: SelectedProductOption) {
        self.productID = product.id
        self.name = product.name
        self.image = product.images.first ?? ""
        self.price =  product.price
        
        self.optionID = selectedProductOption.id
        self.option = selectedProductOption.option
        self.pieces = selectedProductOption.pieces
    }
    
    init (cartedProduct: CartedProduct) {
        self.productID = cartedProduct.productID
        self.name = cartedProduct.name
        self.image = cartedProduct.image
        self.price =  cartedProduct.price
        
        self.optionID = cartedProduct.optionID
        self.option = cartedProduct.option
        self.pieces = cartedProduct.pieces
    }
    
    
}


extension OrderProduct {
    func transform() -> ProductRequest {
        return ProductRequest(productId: productID,
                              optionId: optionID,
                              pieces: pieces)
    }
}
