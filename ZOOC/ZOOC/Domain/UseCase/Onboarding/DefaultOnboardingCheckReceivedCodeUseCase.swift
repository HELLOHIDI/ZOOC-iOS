//
//  DefaultOnboardingCheckReceivedCodeUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/06.
//

import RxSwift
import RxCocoa

final class DefaultOnboardingCheckReceivedCodeUseCase: OnboardingCheckReceivedCodeUseCase {
    
    private let disposeBag = DisposeBag()
    private let repository: OnboardingRepository
    
    init(repository: OnboardingRepository) {
        self.repository = repository
    }
    
    var makeFamilySucceeded = PublishRelay<Bool>()
    
    func makeFamily() {
        repository.postMakeFamily() { [weak self] result in
            switch result {
            case .success(let data):
                guard let result = data as? OnboardingMakeFamilyResult else { return }
                UserDefaultsManager.familyID = String(result.familyId)
                self?.makeFamilySucceeded.accept(true)
            default:
                self?.makeFamilySucceeded.accept(false)
            }
        }
    }
}
