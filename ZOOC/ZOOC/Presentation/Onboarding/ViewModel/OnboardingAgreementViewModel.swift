//
//  OnboardingAgreementViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/02/22.
//

import UIKit

import RxSwift
import RxCocoa

final class OnboardingAgreementViewModel: ViewModelType {
    private let onboardingAgreementUseCase: OnboardingAgreementUseCase
    
    init(onboardingAgreementUseCase: OnboardingAgreementUseCase) {
        self.onboardingAgreementUseCase = onboardingAgreementUseCase
    }
    
    struct Input {
        let allAgreementCheckButtonDidTapEvent: Observable<Void>
        let agreementCheckButtonDidTapEvent: Observable<Int>
    }
    
    struct Output {
        var ableToSignUp = BehaviorRelay<Bool>(value: false)
        var allAgreed = BehaviorRelay<Bool>(value: false)
        var agreementList = BehaviorRelay<[OnboardingAgreementModel]>(value: OnboardingAgreementModel.agreementData)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.allAgreementCheckButtonDidTapEvent.subscribe(with: self, onNext: { owner, _ in
            owner.onboardingAgreementUseCase.updateAllAgreementState()
        }).disposed(by: disposeBag)
        
        input.agreementCheckButtonDidTapEvent.subscribe(with: self, onNext: { owner, index in
            owner.onboardingAgreementUseCase.updateAgreementState(index)
        }).disposed(by: disposeBag)
        
        return output
    }
    
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        onboardingAgreementUseCase.ableToSignUp.subscribe(onNext: { canSignUp in
            output.ableToSignUp.accept(canSignUp)
            if output.ableToSignUp.value { print("가능함")}
        }).disposed(by: disposeBag)
        
        onboardingAgreementUseCase.allAgreed.subscribe(onNext: { allAgreed in
            output.ableToSignUp.accept(allAgreed)
        }).disposed(by: disposeBag)
        
        onboardingAgreementUseCase.agreementList.subscribe(onNext: { agreementList in
            output.agreementList.accept(agreementList)
        }).disposed(by: disposeBag)
    }
}

extension OnboardingAgreementViewModel {
    func getAllAgreed() -> Bool {
        return onboardingAgreementUseCase.allAgreed.value
    }
}
