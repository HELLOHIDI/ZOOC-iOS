//
//  MyEditProfileRepository.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/11.
//

import Foundation

protocol MyEditProfileRepository {
    func patchMyProfile(request: EditProfileRequest, completion: @escaping (NetworkResult<Any>) -> Void)
}

class MyEditProfileRepositoryImpl: MyEditProfileRepository {
    func patchMyProfile(request: EditProfileRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        MyAPI.shared.patchMyProfile(requset: request, completion: completion)
    }
}
