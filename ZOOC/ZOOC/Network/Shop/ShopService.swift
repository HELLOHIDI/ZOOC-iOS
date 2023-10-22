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
    case getEvent
    case getEventProgress
    case postEvent(petID: Int)
    case getEventResult
}

extension ShopService: BaseTargetType {
    var path: String {
        switch self {
        case .getTotalProducts:
            return URLs.getTotalProducts
        case .getProduct(let productID):
            return URLs.getProduct
                .replacingOccurrences(of: "{productId}", with: String(productID))
        case .postOrder:
            return URLs.postOrder
        case .getEvent:
            return URLs.getEvent
                .replacingOccurrences(of: "{eventId}", with: "1")
        case .getEventProgress:
            return URLs.getEventProgress
                .replacingOccurrences(of: "{eventId}", with: "1")
        case .postEvent:
            return URLs.postEvent
                .replacingOccurrences(of: "{eventId}", with: "1")
        case .getEventResult:
            return URLs.getEventResult.replacingOccurrences(of: "{eventId}", with: "1")
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
        case .getEvent:
            return .get
        case .getEventProgress:
            return .get
        case .postEvent:
            return .post
        case .getEventResult:
            return .get
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
        case .getEvent:
            return .requestPlain
        case .getEventProgress:
            return .requestPlain
        case .postEvent(let petID):
            return .requestParameters(parameters: ["petId" : petID], encoding: JSONEncoding.default)
        case .getEventResult:
            return .requestPlain
        }
    }
}
