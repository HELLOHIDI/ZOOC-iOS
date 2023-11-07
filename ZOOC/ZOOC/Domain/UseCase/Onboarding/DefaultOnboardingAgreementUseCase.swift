//
//  DefaultOnboardingAgreementUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/05.
//

import RxSwift
import RxCocoa

final class DefaultOnboardingAgreementUseCase: OnboardingAgreementUseCase {
    
    private let disposeBag = DisposeBag()
    
    var agreementList = BehaviorRelay<[OnboardingAgreementModel]>(value: OnboardingAgreementModel.agreementData)
    var ableToSignUp = BehaviorRelay<Bool>(value: false)
    
    func updateAllAgreementState() {
        let updateAllAgreementState = !ableToSignUp.value
        ableToSignUp.accept(updateAllAgreementState)
        
        let updateAgreementList = agreementList.value.map { agreement in
            var updatedAgreement = agreement
            updatedAgreement.isSelected = updateAllAgreementState
            return updatedAgreement
        }
        agreementList.accept(updateAgreementList)
        checkAbleToSignUp()
    }
    
    func updateAgreementState(_ index: Int) {
        var updateAgreementList = agreementList.value
        updateAgreementList[index].isSelected.toggle()
        agreementList.accept(updateAgreementList)
        checkAbleToSignUp()
    }
}

extension DefaultOnboardingAgreementUseCase {
    private func checkAbleToSignUp() {
        let allChecked = agreementList.value.allSatisfy { $0.isSelected }
        self.ableToSignUp.accept(allChecked)
    }
}
