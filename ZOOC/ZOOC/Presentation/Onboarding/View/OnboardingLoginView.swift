//
//  OnboardingLoginView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/07.
//

import UIKit

import AuthenticationServices
import SnapKit
import Then

final class OnboardingLoginView: UIView {
    
    //MARK: - UI Components
    
    private let loginTitleLabel = UILabel()
    private let loginDescribeLabel = UILabel()
    private let lineView = UIView()
    public lazy var kakaoLoginButton = UIButton()
    public lazy var appleLoginButton = UIButton()
    
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
        loginTitleLabel.do {
            $0.text = "반려동물과의 일상을\n쭉\n간직하는 특별한 방법"
            $0.textColor = .zw_black
            $0.textAlignment = .left
            $0.font = .gmarket(font: .light, size: 30)
            $0.numberOfLines = 3
            $0.setLineSpacing(spacing: 10)
            $0.setAttributeLabel(
                targetString: ["일상", "쭉", "간직"],
                color: .zw_black,
                font: .gmarket(font: .medium, size: 30),
                spacing: 10
            )
        }
        lineView.backgroundColor = .zw_darkgray
        loginDescribeLabel.do {
            $0.text = "1초만에 가입하고 우리집 반려동물 굿즈 만들기"
            $0.textColor = .zw_gray
            $0.textAlignment = .left
            $0.font = .zoocBody2
            $0.setLineSpacing(spacing: 8)
        }
        kakaoLoginButton.do {
            $0.setImage(.zwImage(.btn_kakao), for: .normal)
        }
        appleLoginButton.do {
            $0.setImage(.zwImage(.btn_apple), for: .normal)
        }
    }
    
    private func hierarchy() {
        self.addSubviews(
            loginTitleLabel,
            lineView,
            loginDescribeLabel,
            appleLoginButton,
            kakaoLoginButton
        )
    }
    
    private func layout() {
        loginTitleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(97)
            $0.leading.equalToSuperview().offset(28)
        }
        lineView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(157)
            $0.leading.equalToSuperview().offset(70)
            $0.trailing.equalToSuperview().inset(77)
            $0.height.equalTo(1)
        }
        loginDescribeLabel.snp.makeConstraints {
            $0.top.equalTo(loginTitleLabel.snp.bottom).offset(24)
            $0.leading.equalTo(loginTitleLabel)
        }
        appleLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(kakaoLoginButton.snp.top)
            $0.width.equalToSuperview()
            $0.height.equalTo(77)
        }
        kakaoLoginButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(77)
        }
    }
}
