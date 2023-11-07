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
        self.backgroundColor = .zw_background
        
        welcomeLabel.do {
            $0.text = "쭉에 오신 것을\n진심으로 환영해요!"
            $0.textColor = .zw_black
            $0.textAlignment = .left
            $0.font = .gmarket(font: .light, size: 30)
            $0.numberOfLines = 3
            $0.setLineSpacing(spacing: 10)
            $0.setAttributeLabel(
                targetString: ["쭉"],
                color: .zw_black,
                font: .gmarket(font: .medium, size: 30),
                spacing: 10
            )
        }
        
        welcomeSubLabel.do {
            $0.text = "사랑하는 반려동물과의 일상이\n특별하게 간직되도록 함께 할게요"
            $0.textColor = .zw_gray
            $0.textAlignment = .left
            $0.font = .pretendard(font: .light, size: 16)
            $0.numberOfLines = 2
            $0.setLineSpacing(spacing: 4)
        }
        
        nextButton.do {
            $0.backgroundColor = .zw_black
            $0.setTitle("홈으로 돌아가기", for: .normal)
            $0.titleLabel?.font = .zw_Subhead1
            $0.setTitleColor(.zw_white, for: .normal)
        }
    }
    
    private func hierarchy() {
        self.addSubviews(
            welcomeLabel,
            welcomeSubLabel,
            nextButton
        )
    }
    
    private func layout() {
        welcomeLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(97)
            $0.leading.equalToSuperview().offset(28)
        }
        
        welcomeSubLabel.snp.makeConstraints {
            $0.top.equalTo(welcomeLabel.snp.bottom).offset(24)
            $0.leading.equalTo(welcomeLabel)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(77)
        }
    }
}
