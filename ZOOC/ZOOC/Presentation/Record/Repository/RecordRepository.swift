//
//  RecordRepository.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/03.
//

import UIKit

protocol RecordRepository {
    func getTotalPet(familyID: String, completion: @escaping (NetworkResult<Any>) -> Void)
    func postRecord(familyID: String, photo: UIImage, content: String?, pets: [Int], completion: @escaping (NetworkResult<Any>) -> Void)
}

class DefaultRecordRepository: RecordRepository {
    func getTotalPet(familyID: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        RecordAPI.shared.getTotalPet(completion: completion)
    }
    
    func postRecord(familyID: String, photo: UIImage, content: String?, pets: [Int], completion: @escaping (NetworkResult<Any>) -> Void) {
        RecordAPI.shared.postRecord(photo: photo, content: content, pets: pets, completion: completion)
    }
}

