//
//  OnboardingJoinFamilyViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/06.
//

import UIKit

import RxSwift
import RxCocoa

final class OnboardingJoinFamilyViewModel: ViewModelType {
    private let onboardingJoinFamilyUseCase: OnboardingJoinFamilyUseCase
    
    init(onboardingJoinFamilyUseCase: OnboardingJoinFamilyUseCase) {
        self.onboardingJoinFamilyUseCase = onboardingJoinFamilyUseCase
    }
    
    struct Input {
        let familyCodeTextFieldDidChangeEvent: Observable<String?>
        let nextButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var enteredCode = BehaviorRelay<String>(value: "")
        var ableToCheckCode = PublishRelay<Bool>()
        var errMessage = BehaviorRelay<String?>(value: nil)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.familyCodeTextFieldDidChangeEvent.subscribe(with: self, onNext: { owner, text in
            guard let text else { return }
            owner.onboardingJoinFamilyUseCase.updateEnteredCode(text)
        }).disposed(by: disposeBag)
        
        input.nextButtonDidTapEvent.subscribe(with: self, onNext: { owner, _ in
            owner.onboardingJoinFamilyUseCase.joinFamily()
        }).disposed(by: disposeBag)
        
        return output
    }
    
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        onboardingJoinFamilyUseCase.enteredCode.subscribe(onNext: { enteredCode in
            output.enteredCode.accept(enteredCode)
        }).disposed(by: disposeBag)
        
        onboardingJoinFamilyUseCase.ableToCheckCode.subscribe(onNext: { ableToCheckCode in
            output.ableToCheckCode.accept(ableToCheckCode)
        }).disposed(by: disposeBag)
        
        onboardingJoinFamilyUseCase.errMessage.subscribe(onNext: { errMessage in
            output.errMessage.accept(errMessage)
        }).disposed(by: disposeBag)
    }
}

