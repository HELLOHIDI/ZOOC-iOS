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
}

protocol MyNetworkHandlerProtocol {
    func requestMyPageAPI(myNetworkManager: MyAPI, completion: @escaping (Bool, String?) -> Void)
}


final class MyViewModel: MyViewModelInput, MyViewModelOutput {
    var myFamilyMemberData: [UserResult] = []
    var myPetMemberData: [PetResult] = []
    var myProfileData: UserResult?

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
    func requestMyPageAPI(myNetworkManager: MyAPI, completion: @escaping (Bool, String?) -> Void) {
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
}
