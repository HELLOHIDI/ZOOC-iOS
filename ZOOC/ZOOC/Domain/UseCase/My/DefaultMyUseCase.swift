//
//  DefaultMyUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/25.
//

import UIKit

import RxSwift
import RxCocoa

final class DefaultMyUseCase: MyUseCase {
    
    private let repository: MyRepository
    private let disposeBag = DisposeBag()
    
    init(repository: MyRepository) {
        self.repository = repository
    }
    
    var profileData = BehaviorRelay<UserResult?>(value: nil)
    var familyMemberData = BehaviorRelay<[UserResult]>(value: [])
    var petMemberData = BehaviorRelay<[PetResult]>(value: [])
    var inviteCode = BehaviorRelay<String?>(value: nil)
    var isloggedOut = BehaviorRelay<Bool>(value: false)
    var isDeletedAccount = BehaviorRelay<Bool>(value: false)
    
    func requestMyPage() {
        repository.requestMyPageAPI() {  result in
            switch result {
            case .success(let data):
                guard let result = data as? MyResult else { return }
                self.profileData.accept(result.user)
                self.familyMemberData.accept(result.familyMember)
                self.petMemberData.accept(result.pet)
            default:
                break
            }
        }
    }
    
    func logout() {
        repository.requestLogoutAPI() { [weak self] result in
            switch result {
            case .success(_):
                UserDefaultsManager.reset()
                self?.isloggedOut.accept(true)
            default:
                self?.isloggedOut.accept(false)
            }
        }
    }
    
    func deleteAccount() {
        repository.deleteAccount(completion: { [weak self] result in
            switch result {
            case .success(_):
                UserDefaultsManager.reset()
                self?.isDeletedAccount.accept(true)
            default:
                self?.isDeletedAccount.accept(false)
            }
        })
    }
    
    func getInviteCode() {
        repository.getInviteCode(completion: { [weak self] result in
            switch result {
            case .success(let data):
                guard let result = data as? OnboardingInviteResult else { return }
                self?.inviteCode.accept(TextLiteral.invitedMessage(invitedCode: result.code))
            default:
                break
            }
        })
    }
}
