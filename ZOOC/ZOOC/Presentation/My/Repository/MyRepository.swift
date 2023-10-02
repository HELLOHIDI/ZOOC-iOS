//
//  MyRepository.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/11.
//

import Foundation

protocol MyRepository {
    func requestMyPageAPI(completion: @escaping (NetworkResult<Any>) -> Void)
    func requestLogoutAPI(completion: @escaping (NetworkResult<Any>) -> Void)
    func getInviteCode(completion: @escaping (NetworkResult<Any>) -> Void)
    func deleteAccount(completion: @escaping (NetworkResult<Any>) -> Void)
    func patchPetProfile(request: EditPetProfileRequest, id: Int, completion: @escaping (NetworkResult<Any>) -> Void)
    func patchMyProfile(request: EditProfileRequest, completion: @escaping (NetworkResult<Any>) -> Void)
    func registerPets(request: MyRegisterPetsRequest, completion: @escaping (NetworkResult<Any>) -> Void)
}

class DefaultMyRepository: MyRepository {
    func requestMyPageAPI(completion: @escaping (NetworkResult<Any>) -> Void) {
        MyAPI.shared.getMyPageData(completion: completion)
    }
    
    func requestLogoutAPI(completion: @escaping (NetworkResult<Any>) -> Void) {
        MyAPI.shared.logout(completion: completion)
    }
    
    func getInviteCode(completion: @escaping (NetworkResult<Any>) -> Void) {
        OnboardingAPI.shared.getInviteCode(familyID: UserDefaultsManager.familyID, completion: completion)
    }
    
    func deleteAccount(completion: @escaping (NetworkResult<Any>) -> Void) {
        MyAPI.shared.deleteAccount(completion: completion)
    }
    
    func patchPetProfile(request: EditPetProfileRequest, id: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        print(#function)
        MyAPI.shared.patchPetProfile(requset: request, id: id, completion: completion)
    }
    
    func patchMyProfile(request: EditProfileRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        MyAPI.shared.patchMyProfile(requset: request, completion: completion)
    }
    
    func registerPets(request: MyRegisterPetsRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        MyAPI.shared.registerPets(request: request, completion: completion)
    }
}
