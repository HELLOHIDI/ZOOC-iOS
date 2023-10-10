//
//  DefaultOnboardingJoinFamilyUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/06.
//

import RxSwift
import RxCocoa

final class DefaultOnboardingJoinFamilyUseCase: OnboardingJoinFamilyUseCase {
    
    private let disposeBag = DisposeBag()
    private let repository: OnboardingRepository
    
    init(repository: OnboardingRepository) {
        self.repository = repository
    }
    
    var enteredFamilyCode = BehaviorRelay<String?>(value: nil)
    var errMessage = BehaviorRelay<String?>(value: nil)
    var ableToCheckFamilyCode = PublishRelay<Bool>()
    var isJoinedFamily = PublishRelay<Bool>()
    var isTextCountExceeded = PublishRelay<Bool>()
    
    func updateEnteredFamilyCode(_ text: String) {
        enteredFamilyCode.accept(text)
        guard let code = enteredFamilyCode.value else { return }
        checkEnteredCode(code)
    }
    
    func joinFamily() {
        guard let code = enteredFamilyCode.value else { return }
        let param = OnboardingJoinFamilyRequest(code: code)
        repository.postJoinFamily(request: param) { [weak self] result in
            switch result {
            case .success(let data):
                guard let result = data as? OnboardingJoinFamilyResult else { return }
                UserDefaultsManager.familyID = String(result.familyID)
                self?.requestFCMTokenAPI()
            case .requestErr(let err):
                self?.errMessage.accept(err)
                self?.isJoinedFamily.accept(false)
            default:
                self?.isJoinedFamily.accept(false)
            }
        }
    }
    
    func requestFCMTokenAPI() {
        repository.patchFCMToken() { [weak self] result in
            switch result {
            case .success(_):
                self?.isJoinedFamily.accept(true)
            default:
                self?.isJoinedFamily.accept(false)
            }
        }
    }
}

extension DefaultOnboardingJoinFamilyUseCase {
    func checkEnteredCode(_ code: String) {
        ableToCheckFamilyCode.accept(code.hasText)
        isTextCountExceeded.accept(code.count <= 6)
    }
}
