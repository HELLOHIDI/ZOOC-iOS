//
//  OnboardingWelcomeView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/07.
//

import UIKit

import SnapKit
import Then

final class OnboardingWelcomeView: UIView {

    //MARK: - UI Components
    
    public let welcomeLabel = UILabel()
    public let welcomeSubLabel = UILabel()
    public let welcomeImage = UIImageView()
    public lazy var nextButton = UIButton()
    
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
        
        welcomeLabel.do {
            $0.text = "쭉에 오신 것을/n진심으로 환영해요!"
            $0.textColor = .zoocDarkGray2
            $0.textAlignment = .left
            $0.font = .zoocDisplay1
            $0.numberOfLines = 2
            $0.setLineSpacing(spacing: 6)
        }
        
        welcomeSubLabel.do {
            $0.text = "사랑하는 반려동물과의 일상이/n특별하게 간직되도록 함께 할게요"
            $0.textColor = .zoocDarkGray2
            $0.textAlignment = .left
            $0.font = .zoocDisplay1
            $0.numberOfLines = 2
            $0.alpha = 0
            $0.setLineSpacing(spacing: 6)
        }
        
        welcomeImage.do {
            $0.contentMode = .scaleAspectFill
            $0.image = Image.graphics1
            $0.alpha = 0
        }
        
        nextButton.do {
            $0.setTitle("다음", for: .normal)
            $0.alpha = 0
        }
    }
    
    private func hierarchy() {
        self.addSubviews(welcomeLabel,
                         welcomeSubLabel,
                         welcomeImage,
                         nextButton)
    }
    
    private func layout() {
        welcomeLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(77)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(315)
            $0.height.equalTo(68)
        }
        
        welcomeSubLabel.snp.makeConstraints {
            $0.top.equalTo(self.welcomeLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(315)
            $0.height.equalTo(68)
        }
        
        welcomeImage.snp.makeConstraints {
            $0.top.equalTo(self.welcomeSubLabel.snp.bottom).offset(51)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.nextButton.snp.top).offset(-30)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(315)
            $0.height.equalTo(54)
        }
    }
}
