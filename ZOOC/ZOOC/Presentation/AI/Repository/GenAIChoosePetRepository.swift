//
//  GenAIChoosePetRepository.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/17.
//

import Foundation

protocol GenAIPetRepository {
    func getTotalPet(completion: @escaping (NetworkResult<Any>) -> Void)
    func registerPet(request: MyRegisterPetRequest, completion: @escaping (NetworkResult<Any>) -> Void)
}

class GenAIPetRepositoryImpl: GenAIPetRepository {
    func getTotalPet(completion: @escaping (NetworkResult<Any>) -> Void) {
        RecordAPI.shared.getTotalPet(completion: completion)
    }
    func registerPet(request: MyRegisterPetRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        MyAPI.shared.registerPet(request: request, completion: completion)
    }
}
