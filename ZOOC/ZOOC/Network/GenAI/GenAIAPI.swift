//
//  GenAIAPI.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/24.
//

import UIKit

import Moya

final class GenAIAPI: BaseAPI {
    static let shared = GenAIAPI()
    var aiProvider = MoyaProvider<GenAIService>(session: Session(interceptor: ZoocInterceptor()),
                                                plugins: [MoyaLoggingPlugin()])
}

extension GenAIAPI {
    public func postMakeDataset(petId: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        aiProvider.request(.postDataset(petId: petId)) {(result) in
            self.disposeNetwork(result,
                                dataModel: GenAIDatasetResult.self,
                                completion: completion)
        }
    }
    
    public func patchDatasetImages(datasetId: String, files: [UIImage], completion: @escaping ((NetworkResult<Any>) -> Void)) {
        aiProvider.request(.patchDatasetImages(datasetId: datasetId, files: files)) { result in
            self.disposeNetwork(result, dataModel: SimpleResponse.self, completion: completion)
        }
    }
}

