//
//  GenAIAPI.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/24.
//

import Foundation

import Moya

final class GenAIAPI: BaseAPI {
    static let shared = GenAIAPI()
    var aiProvider = MoyaProvider<GenAIService>(session: Session(interceptor: ZoocInterceptor()),
                                                             plugins: [MoyaLoggingPlugin()])
}

extension GenAIAPI {
    
   
}

