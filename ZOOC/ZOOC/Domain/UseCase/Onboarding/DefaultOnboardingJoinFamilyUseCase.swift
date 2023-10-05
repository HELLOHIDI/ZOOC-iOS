//
//  DefaultOnboardingJoinFamilyUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/06.
//

import UIKit

import RxSwift
import RxCocoa

final class DefaultOnboardingJoinFamilyUseCase: OnboardingJoinFamilyUseCase {
    
    private let disposeBag = DisposeBag()
    private let repository: OnboardingRepository
    
    init(repository: OnboardingRepository) {
        self.repository = repository
    }
    
    var ableToCheckCode = PublishRelay<Bool>()
    var enteredCode = BehaviorRelay<String>(value: "")
    var errMessage = BehaviorRelay<String?>(value: nil)
    
    func joinFamily() {
        let param = OnboardingJoinFamilyRequest(code: enteredCode.value)
        repository.postJoinFamily(requset: param) { [weak self] result in
            switch result {
            case .success(let data):
                guard let result = data as? OnboardingJoinFamilyResult else { return }
                UserDefaultsManager.familyID = String(result.familyID)
                self?.requestFCMTokenAPI()
            case .requestErr(let err):
                self?.errMessage.accept(err)
                self?.ableToCheckCode.accept(false)
            default:
                self?.ableToCheckCode.accept(false)
            }
        }
    }
    
    func requestFCMTokenAPI() {
        repository.patchFCMToken { [weak self] result in
            switch result {
            case .success(_):
                self?.ableToCheckCode.accept(true)
            default:
                self?.ableToCheckCode.accept(false)
            }
        }
    }
    
    func updateEnteredCode(_ text: String) {
        enteredCode.accept(text)
        ableToCheckCode.accept(text.hasText)
    }
}

