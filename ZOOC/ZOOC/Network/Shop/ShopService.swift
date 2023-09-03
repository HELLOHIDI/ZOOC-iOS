//
//  ShopService.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/30.
//

import Foundation

import Moya

enum ShopService {
    case getTotalProducts
    case getProduct(productID: Int)
    case postOrder(_ request: OrderRequest)
}

extension ShopService: BaseTargetType {
    var path: String {
        switch self {
        case .getTotalProducts:
            return URLs.getTotalProducts
        case .getProduct(let productID):
            return URLs.getProduct
                .replacingOccurrences(of: "{productId}",
                                      with: String(productID))
        case .postOrder:
            return URLs.postOrder
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTotalProducts:
            return .get
        case .getProduct:
            return .get
        case .postOrder:
            return .post
        }
        
    }
    
    var task: Moya.Task {
        switch self {
        case .getTotalProducts:
            return .requestPlain
        case .getProduct:
            return .requestPlain
        case .postOrder(let request):
            return .requestJSONEncodable(request)
        }
    }
}
