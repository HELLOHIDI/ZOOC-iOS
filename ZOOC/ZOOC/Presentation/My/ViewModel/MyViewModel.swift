//
//  MyViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/04.
//

import Foundation

protocol MyViewModelInput {}

protocol MyViewModelOutput {
    var myFamilyMemberData: [UserResult] { get }
    var myPetMemberData: [PetResult] { get }
    var myProfileData: UserResult? { get }
    var myNetworkManager: MyAPI  { get }
    var onboardingNetworkManager: OnboardingAPI  { get }
}

protocol MyNetworkHandlerProtocol {
    func requestMyPageAPI(completion: @escaping (Bool, String?) -> Void)
    func requestLogoutAPI(completion: @escaping () -> Void)
    func getInviteCode(completion: @escaping () -> Void)
    func deleteAccount(completion: @escaping() -> Void)
}


final class MyViewModel: MyViewModelInput, MyViewModelOutput {
    var myFamilyMemberData: [UserResult] = []
    var myPetMemberData: [PetResult] = []
    var myProfileData: UserResult?
    var inviteCode: String?
    
    var myNetworkManager: MyAPI
    var onboardingNetworkManager: OnboardingAPI
    
    init(myNetworkManager: MyAPI, onboardingNetworkManager: OnboardingAPI) {
        self.myNetworkManager = myNetworkManager
        self.onboardingNetworkManager = onboardingNetworkManager
    }
    
    @discardableResult
    func validateResult(_ result: NetworkResult<Any>) -> Any?{
        switch result{
        case .success(let data):
            print("성공했습니다.")
            print(data)
            return data
        case .requestErr(let message):
            return message
        case .pathErr:
            return "path 혹은 method 오류입니다."
        case .serverErr:
            return "서버 내 오류입니다."
        case .networkFail:
            return "네트워크가 불안정합니다."
        case .decodedErr:
            return "디코딩 오류가 발생했습니다."
        case .authorizationFail(_):
            return "인증 오류가 발생했습니다. 다시 로그인해주세요"
        }
    }
}

extension MyViewModel: MyNetworkHandlerProtocol {
    func deleteAccount(completion: @escaping () -> Void) {
        myNetworkManager.deleteAccount() { result in
            User.shared.clearData()
        }
    }
    
    func requestMyPageAPI(completion: @escaping (Bool, String?) -> Void) {
        myNetworkManager.getMyPageData() { [weak self] result in
            guard let result = self?.validateResult(result) as? MyResult else {
                let errorMessage = self?.validateResult(result) as? String
                completion(false, errorMessage)
                return
            }
            self?.myProfileData = result.user
            self?.myFamilyMemberData = result.familyMember
            self?.myPetMemberData = result.pet
            completion(true, nil)
        }
    }
    
    func requestLogoutAPI(completion: @escaping () -> Void) {
        myNetworkManager.logout() { result in
            User.shared.clearData()
            completion()
        }
    }
    
    func getInviteCode(completion: @escaping () -> Void) {
        onboardingNetworkManager.getInviteCode(familyID: User.shared.familyID) { result in
            guard let result = self.validateResult(result) as? OnboardingInviteResult else { return }
            let code = result.code
            self.inviteCode = code
        }
    }
}
