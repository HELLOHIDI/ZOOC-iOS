//
//  OnboardingAgreementUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/05.
//

import UIKit

import RxSwift
import RxCocoa
import KakaoSDKAuth
import KakaoSDKUser

protocol OnboardingAgreementUseCase {
    var agreementList: BehaviorRelay<[OnboardingAgreementModel]> { get set }
    var ableToSignUp: BehaviorRelay<Bool> { get }
    var allAgreed: BehaviorRelay<Bool> { get }
    
    func updateAllAgreementState()
    func updateAgreementState(_ index: Int)
}

