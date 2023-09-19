//
//  MyViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/04.
//

import Foundation

protocol MyViewModelInput {
    func viewWillAppearEvent()
    func logoutButtonDidTapEvent()
    func deleteAccountButtonDidTapEvent()
    func inviteCodeButtonDidTapEvent()
}

protocol MyViewModelOutput {
    var myFamilyMemberData: Observable<[UserResult]> { get }
    var myPetMemberData: Observable<[PetResult]> { get }
    var myProfileData: Observable<UserResult?> { get }
    var inviteCodeMessage: Observable<String?> { get }
    var logoutOutput: Observable<Bool?> { get }
    var deleteAccoutOutput: Observable<Bool?> { get }
}

typealias MyViewModel = MyViewModelInput & MyViewModelOutput

final class DefaultMyViewModel: MyViewModel {
    
    var myFamilyMemberData: Observable<[UserResult]> = Observable([])
    var myPetMemberData: Observable<[PetResult]> = Observable([])
    var myProfileData: Observable<UserResult?> = Observable(nil)
    var inviteCodeMessage: Observable<String?> = Observable(nil)
    var logoutOutput: Observable<Bool?> = Observable(nil)
    var deleteAccoutOutput: Observable<Bool?> = Observable(nil)
    
    let repository: MyRepository
    
    init(repository: MyRepository) {
        self.repository = repository
    }
    
    func viewWillAppearEvent() {
        requestMyPageAPI()
    }
    
    func logoutButtonDidTapEvent() {
        requestLogoutAPI()
    }
    
    func deleteAccountButtonDidTapEvent() {
        deleteAccount()
    }
    
    func inviteCodeButtonDidTapEvent() {
        getInviteCode()
    }
    
}

extension DefaultMyViewModel {
    func getInviteCode() {
        repository.getInviteCode {  result in
            switch result {
            case .success(let data):
                guard let result = data as? OnboardingInviteResult else { return }
                self.inviteCodeMessage.value = TextLiteral.invitedMessage(invitedCode: result.code)
            default:
                break
            }
        }
    }
    
    func deleteAccount() {
        repository.deleteAccount() { result in
            switch result {
            case .success(_):
                UserDefaultsManager.reset()
                self.deleteAccoutOutput.value = true
            default:
                self.deleteAccoutOutput.value = true
            }
        }
    }

    func requestMyPageAPI() {
        repository.requestMyPageAPI() {  result in
            switch result {
            case .success(let data):
                guard let result = data as? MyResult else { return }
                self.myProfileData.value = result.user
                self.myFamilyMemberData.value = result.familyMember
                self.myPetMemberData.value = result.pet
            default:
                break
            }
        }
    }
    
    func requestLogoutAPI() {
        repository.requestLogoutAPI() { result in
            switch result {
            case .success(_):
                UserDefaultsManager.reset()
                self.logoutOutput.value = true
            default:
                self.logoutOutput.value = false
            }
        }
    }
}
