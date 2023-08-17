//
//  GenAIChoosePetRepository.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/17.
//

import Foundation

protocol GenAIChoosePetRepository {
    func getTotalPet(completion: @escaping (NetworkResult<Any>) -> Void)
}

class GenAIChoosePetRepositoryImpl: GenAIChoosePetRepository {
    func getTotalPet(completion: @escaping (NetworkResult<Any>) -> Void) {
        RecordAPI.shared.getTotalPet(completion: completion)
    }
}

