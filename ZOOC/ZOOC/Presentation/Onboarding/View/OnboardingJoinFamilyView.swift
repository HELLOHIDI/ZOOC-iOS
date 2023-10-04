//
//  OnboardingParticipateView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/09.
//

import UIKit

import SnapKit
import Then

final class OnboardingJoinFamilyView: OnboardingBaseView {
    
    //MARK: - UI Components
    
    private let participateTitleLabel = UILabel()
    public lazy var familyCodeTextField = UITextField()
    private let participateImage = UIImageView()
    public lazy var nextButton = ZoocGradientButton()
    
    //MARK: - Life Cycles
    
    override init(onboardingState: OnboardingState) {
        super.init(onboardingState: onboardingState)
        
        style()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    private func style() {
        self.backgroundColor = .zoocBackgroundGreen
        
        participateTitleLabel.do {
            $0.text = "전달받은 가족코드를 \n입력해주세요"
            $0.textColor = .zoocDarkGray1
            $0.textAlignment = .left
            $0.font = .zoocDisplay1
            $0.numberOfLines = 2
            $0.setAttributeLabel(
                targetString: ["가족코드"],
                color: .zoocMainGreen,
                font: .zoocDisplay1,
                spacing: 6)
        }
        
        familyCodeTextField.do {
            $0.backgroundColor = .zoocWhite2
            $0.font = .zoocBody2
            $0.textColor = .zoocDarkGreen
            $0.placeholder = "  ex) SEF33210"
            $0.makeCornerRound(radius: 8)
            $0.addLeftPadding(inset: 6)
        }
        
        participateImage.do {
            $0.image = Image.graphics5
            $0.contentMode = .scaleAspectFit
        }
        
        nextButton.do {
            $0.setTitle("입력하기", for: .normal)
            $0.isEnabled = false
        }
    }
    
    private func hierarchy() {
        self.addSubviews(
            participateTitleLabel,
            familyCodeTextField,
            participateImage,
            nextButton
        )
    }
    
    private func layout() {
        participateTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(103)
            $0.leading.equalToSuperview().offset(30)
            $0.width.equalTo(200)
            $0.height.equalTo(68)
        }
        
        familyCodeTextField.snp.makeConstraints {
            $0.top.equalTo(self.participateTitleLabel.snp.bottom).offset(40)
            $0.leading.equalTo(self.participateTitleLabel)
            $0.width.equalTo(162)
            $0.height.equalTo(41)
        }
        
        participateImage.snp.makeConstraints {
            $0.top.equalTo(self.familyCodeTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.nextButton.snp.top).offset(-20)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(315)
            $0.height.equalTo(54)
        }
    }
}
