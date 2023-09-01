//
//  ShopService.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/30.
//

import Foundation

import Moya

enum ShopService {
    case getProducts
    case postOrder(_ request: OrderRequest)
}

extension ShopService: BaseTargetType {
    var path: String {
        switch self {
        case .getProducts:
            return URLs.getProduct
        case .postOrder:
            return URLs.postOrder
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getProducts:
            return .get
        case .postOrder:
            return .post
        }
        
    }
    
    var task: Moya.Task {
        switch self {
        case .getProducts:
            return .requestPlain
        case .postOrder(let request):
            return .requestJSONEncodable(request)
        }
    }
}
