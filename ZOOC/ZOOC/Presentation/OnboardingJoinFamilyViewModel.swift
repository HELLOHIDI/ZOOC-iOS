//
//  OnboardingJoinFamilyViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/06.
//

import RxSwift
import RxCocoa

final class OnboardingJoinFamilyViewModel: ViewModelType {
    private let onboardingJoinFamilyUseCase: OnboardingJoinFamilyUseCase
    
    init(onboardingJoinFamilyUseCase: OnboardingJoinFamilyUseCase) {
        self.onboardingJoinFamilyUseCase = onboardingJoinFamilyUseCase
    }
    
    struct Input {
        let familyCodeTextFieldDidChange: Observable<String>
        let nextButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var enteredFamilyCode = BehaviorRelay<String?>(value: nil)
        var errMessage = BehaviorRelay<String?>(value: nil)
        var ableToCheckFamilyCode = PublishRelay<Bool>()
        var isJoinedFamily = PublishRelay<Bool>()
        var isTextCountExceeded = PublishRelay<Bool>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.familyCodeTextFieldDidChange.subscribe(with: self, onNext: { owner, text in
            owner.onboardingJoinFamilyUseCase.updateEnteredFamilyCode(text)
        }).disposed(by: disposeBag)
        
        input.nextButtonDidTapEvent.subscribe(with: self, onNext: { owner, _ in
            owner.onboardingJoinFamilyUseCase.joinFamily()
        }).disposed(by: disposeBag)
        
        return output
    }
    
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        onboardingJoinFamilyUseCase.enteredFamilyCode.subscribe(onNext: { code in
            output.enteredFamilyCode.accept(code)
        }).disposed(by: disposeBag)
        
        onboardingJoinFamilyUseCase.errMessage.subscribe(onNext: { err in
            output.errMessage.accept(err)
        }).disposed(by: disposeBag)
        
        onboardingJoinFamilyUseCase.ableToCheckFamilyCode.subscribe(onNext: { canCheck in
            output.ableToCheckFamilyCode.accept(canCheck)
        }).disposed(by: disposeBag)
        
        onboardingJoinFamilyUseCase.isJoinedFamily.subscribe(onNext: { isJoinedFamily in
            output.isJoinedFamily.accept(isJoinedFamily)
        }).disposed(by: disposeBag)
        
        onboardingJoinFamilyUseCase.isTextCountExceeded.subscribe(onNext: { isTextCountExceeded in
            output.isTextCountExceeded.accept(isTextCountExceeded)
        }).disposed(by: disposeBag)
    }
}
