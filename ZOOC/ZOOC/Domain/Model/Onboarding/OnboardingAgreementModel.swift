//
//  AgreementModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/07.
//

import UIKit

struct OnboardingAgreementModel {
    let title: String
    var isSelected: Bool
}

extension OnboardingAgreementModel {
    
    static var agreementData: [OnboardingAgreementModel] = [
        OnboardingAgreementModel(title: "[필수] 이용약관 동의", isSelected: false),
        OnboardingAgreementModel(title: "[필수] 개인정보 처리방침 동의", isSelected: false),
        OnboardingAgreementModel(title: "[필수] 만 14세 이상 확인", isSelected: false),
        OnboardingAgreementModel(title: "[선택] 마케팅 정보 수신 동의", isSelected: false)
    ]
    
}


