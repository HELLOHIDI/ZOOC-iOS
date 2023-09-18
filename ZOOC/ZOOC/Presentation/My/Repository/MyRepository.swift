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
}

class MyRepositoryImpl: MyRepository {
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
}
