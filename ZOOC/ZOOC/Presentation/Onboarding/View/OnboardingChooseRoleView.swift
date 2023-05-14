//
//  OnboardingChooseFamilyRoleView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/08.
//

import UIKit

import SnapKit
import Then

final class OnboardingChooseRoleView: OnboardingBaseView {
    
    //MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let subLabel = UILabel()
    public lazy var roleTextField = UITextField()
    public let textFieldUnderLineView = UIView()
    public lazy var nextButton = ZoocGradientButton()
    
    //MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        
        firstStep()
        
        titleLabel.do {
            $0.text = "가족에서 \n어떤 역할을 맡고 있나요?"
            $0.textColor = .zoocDarkGray1
            $0.textAlignment = .left
            $0.font = .zoocDisplay1
            $0.numberOfLines = 2
        }
        
        subLabel.do {
            $0.text = "우리 가족에서 저는"
            $0.textColor = .zoocDarkGray1
            $0.textAlignment = .left
            $0.font = .zoocBody3
        }
        
        roleTextField.do {
            $0.font = .zoocBody3
            $0.textColor = .zoocGray1
            $0.textAlignment = .left
            $0.placeholder = "ex) 엄마, 아빠, 첫째딸, 둘째딸 (10자 이내)"
        }
        
        textFieldUnderLineView.do {
            $0.backgroundColor = .zoocGray1
        }
        
        nextButton.do {
            $0.setTitle("이렇게 불러주세요", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .zoocSubhead1
            $0.titleLabel?.textAlignment = .center
            $0.makeCornerRound(radius: 27)
            $0.isEnabled = false
            $0.inActiveColor = .zoocGray1
            $0.activeColorTop = .zoocGradientGreenFirst
            $0.activeColorBottom = .zoocGradientGreenLast
        }
    }
    
    private func hierarchy() {
        self.addSubviews(
            titleLabel,
            subLabel,
            roleTextField,
            textFieldUnderLineView,
            nextButton
        )
    }
    
    private func layout() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(56)
            $0.leading.equalTo(self.safeAreaLayoutGuide).offset(30)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(40)
            $0.leading.equalTo(self.titleLabel)
        }
        
        roleTextField.snp.makeConstraints {
            $0.top.equalTo(self.subLabel.snp.bottom).offset(17)
            $0.leading.equalTo(self.titleLabel)
        }
        
        textFieldUnderLineView.snp.makeConstraints {
            $0.top.equalTo(self.roleTextField.snp.bottom).offset(5)
            $0.leading.equalTo(self.titleLabel)
            $0.width.equalTo(314)
            $0.height.equalTo(1)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(315)
            $0.height.equalTo(54)
        }
    }
}
