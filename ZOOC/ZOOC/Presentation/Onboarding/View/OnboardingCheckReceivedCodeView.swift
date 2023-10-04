//
//  OnboardingCompleteProfileView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/09.
//

import UIKit

import SnapKit
import Then

final class OnboardingCheckReceivedCodeView: OnboardingBaseView {
    
    //MARK: - UI Components
    
    public let titleLabel = UILabel()
    public let subTitleLabel = UILabel()
    public let completeImage = UIImageView()
    public lazy var getCodeButton = ZoocGradientButton.init(.network)
    public lazy var notGetCodeButton = ZoocGradientButton()
    
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
        
        titleLabel.do {
            $0.text = "가족 코드를 받았나요?"
            $0.textColor = .zoocDarkGray1
            $0.textAlignment = .left
            $0.font = .zoocDisplay1
            $0.asColor(targetString: "가족 코드", color: .zoocMainGreen)
        }
        
        subTitleLabel.do {
            $0.text = "ZOOC의 가족 코드는 8자리의\n알파벳과 숫자로 구성되어 있어요 "
            $0.textColor = .zoocGray1
            $0.textAlignment = .left
            $0.font = .zoocBody3
            $0.setLineSpacing(spacing: 6)
            $0.numberOfLines = 2
        }
        
        completeImage.do {
            $0.image = Image.graphics2
            $0.contentMode = .scaleAspectFit
        }
        
        getCodeButton.do {
            $0.setTitle("코드를 받았어요", for: .normal)
        }
        
        notGetCodeButton.do {
            $0.setTitle("아니요", for: .normal)
        }
    }
    
    private func hierarchy() {
        self.addSubviews(
            titleLabel,
            subTitleLabel,
            completeImage,
            getCodeButton,
            notGetCodeButton
        )
    }
    
    private func layout() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(103)
            $0.leading.equalToSuperview().offset(30)
            $0.height.equalTo(34)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(18)
            $0.leading.equalTo(titleLabel)
            $0.height.equalTo(48)
        }
        
        completeImage.snp.makeConstraints {
            $0.top.equalTo(self.subTitleLabel.snp.bottom).offset(74)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(335)
            $0.height.equalTo(264)
        }
        
        getCodeButton.snp.makeConstraints {
            $0.bottom.equalTo(self.notGetCodeButton.snp.top).offset(-10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(315)
            $0.height.equalTo(50)
        }
        
        notGetCodeButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(14)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(315)
            $0.height.equalTo(50)
        }
    }
}
