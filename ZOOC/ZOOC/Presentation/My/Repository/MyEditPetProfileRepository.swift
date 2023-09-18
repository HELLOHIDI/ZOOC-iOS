//
//  MyEditPetProfileRepository.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/11.
//

import Foundation

protocol MyEditPetProfileRepository {
    func patchPetProfile(request: EditPetProfileRequest, id: Int, completion: @escaping (NetworkResult<Any>) -> Void)
}

class MyEditPetProfileRepositoryImpl: MyEditPetProfileRepository {
    func patchPetProfile(request: EditPetProfileRequest, id: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        MyAPI.shared.patchPetProfile(requset: request, id: id, completion: completion)
    }
}
