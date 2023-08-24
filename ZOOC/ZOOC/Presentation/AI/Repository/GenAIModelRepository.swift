//
//  GenAIModelRepository.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/24.
//

import UIKit

protocol GenAIModelRepository {
    func postMakeDataset(petId: Int, completion: @escaping (NetworkResult<Any>) -> Void)
    func patchDatasetImages(datasetId: String, files: [UIImage], completion: @escaping ((NetworkResult<Any>) -> Void))
}

class GenAIModelRepositoryImpl: GenAIModelRepository {
    func postMakeDataset(petId: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        GenAIAPI.shared.postMakeDataset(petId: petId, completion: completion)
    }
    
    func patchDatasetImages(datasetId: String, files: [UIImage], completion: @escaping ((NetworkResult<Any>) -> Void)) {
        GenAIAPI.shared.patchDatasetImages(datasetId: datasetId, files: files, completion: completion)
    }
}

