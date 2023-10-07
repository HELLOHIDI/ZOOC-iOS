//
//  OnboardingCheckReceivedCodeViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/06.
//

import RxSwift
import RxCocoa

final class OnboardingCheckReceivedCodeViewModel: ViewModelType {
    private let onboardingCheckReceivedCodeUseCase: OnboardingCheckReceivedCodeUseCase
    
    init(onboardingCheckReceivedCodeUseCase: OnboardingCheckReceivedCodeUseCase) {
        self.onboardingCheckReceivedCodeUseCase = onboardingCheckReceivedCodeUseCase
    }
    
    struct Input {
        let notGetCodeButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var makeFamilySucceeded = PublishRelay<Bool>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.notGetCodeButtonDidTapEvent
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
            owner.onboardingCheckReceivedCodeUseCase.makeFamily()
        }).disposed(by: disposeBag)
        
        return output
    }
    
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        onboardingCheckReceivedCodeUseCase.makeFamilySucceeded.subscribe(onNext: { makeFamilySucceeded in
            output.makeFamilySucceeded.accept(makeFamilySucceeded)
        }).disposed(by: disposeBag)
    }
}
