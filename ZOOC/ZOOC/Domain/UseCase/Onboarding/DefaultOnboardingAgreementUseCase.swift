//
//  DefaultOnboardingAgreementUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/05.
//

import UIKit

import RxSwift
import RxCocoa

final class DefaultOnboardingAgreementUseCase: OnboardingAgreementUseCase {
    
    private let disposeBag = DisposeBag()
    
    var agreementList = BehaviorRelay<[OnboardingAgreementModel]>(value: OnboardingAgreementModel.agreementData)
    var ableToSignUp = BehaviorRelay<Bool>(value: false)
    var allAgreed = BehaviorRelay<Bool>(value: false)
    
    func updateAllAgreementState() {
        let updateAllAgreementState = !allAgreed.value
        allAgreed.accept(updateAllAgreementState)
        
        let updateAgreementList = agreementList.value.map { agreement in
            var updatedAgreement = agreement
            updatedAgreement.isSelected = updateAllAgreementState
            return updatedAgreement
        }
        agreementList.accept(updateAgreementList)
        checkAllAgreedState()
        checkAbletToSignUp()

    }
    
    func updateAgreementState(_ index: Int) {
        var updateAgreementList = agreementList.value
        updateAgreementList[index].isSelected.toggle()
        agreementList.accept(updateAgreementList)
        checkAllAgreedState()
        checkAbletToSignUp()
        
    }
}

extension DefaultOnboardingAgreementUseCase {
    private func checkAbletToSignUp() {
        let ableToSignUp = agreementList.value.prefix(3).allSatisfy { $0.isSelected }
        self.ableToSignUp.accept(ableToSignUp)
    }
    
    private func checkAllAgreedState() {
        let allAgreed = agreementList.value.allSatisfy { $0.isSelected }
        self.allAgreed.accept(allAgreed)
    }
}
