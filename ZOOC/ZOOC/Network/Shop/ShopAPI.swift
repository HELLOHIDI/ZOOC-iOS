//
//  ShopAPI.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/30.
//

import Foundation

import Moya

final class ShopAPI: BaseAPI {
    static let shared = ShopAPI()
    private var shopProvider = MoyaProvider<ShopService>(session: Session(interceptor: ZoocInterceptor()),
                                                plugins: [MoyaLoggingPlugin()])
}

extension ShopAPI {
    public func getProducts(completion: @escaping (NetworkResult<Any>) -> Void) {
        shopProvider.request(.getProducts) {(result) in
            self.disposeNetwork(result,
                                dataModel: [ProductResult].self,
                                completion: completion)
        }
    }
    
    public func postOrder(request: OrderRequest,
                          completion: @escaping (NetworkResult<Any>) -> Void) {
        shopProvider.request(.postOrder(request)) {(result) in
            self.disposeNetwork(result,
                                dataModel: VoidResult.self,
                                completion: completion)
        }
    }
}

