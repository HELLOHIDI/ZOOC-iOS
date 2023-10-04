//
//  OnboardingInviteFamilyView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/10.
//

import UIKit

import SnapKit
import Then

final class OnboardingInviteFamilyView: OnboardingBaseView {
    
    //MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let inviteImageView = UIImageView()
    public lazy var inviteLatelyButton = UIButton()
    public lazy var inviteButton = ZoocGradientButton()
    
    //MARK: - Life Cycle
    
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
            $0.text = "가족을 초대해보세요"
            $0.textColor = .zoocDarkGray1
            $0.font = .zoocDisplay1
            $0.textAlignment = .left
        }
        
        descriptionLabel.do {
            $0.text = "함께 추억을 공유하고 싶은 가족들에게 \n초대링크를 보내보세요"
            $0.textColor = .zoocGray1
            $0.textAlignment = .left
            $0.font = .zoocBody3
            $0.numberOfLines = 2
            $0.setLineSpacing(spacing: 2)
        }
        
        inviteImageView .do {
            $0.image = Image.graphics3
            $0.contentMode = .scaleAspectFill
        }
        
        inviteLatelyButton.do {
            $0.setTitle("나중에 초대할게요", for: .normal)
            $0.setTitleColor(.zoocGray1, for: .normal)
            $0.titleLabel?.font = .zoocSubhead1
            $0.setUnderline()
        }
        
        inviteButton.do {
            $0.setTitle("초대하기", for: .normal)
        }
    }
    
    private func hierarchy() {
        self.addSubviews(
            titleLabel,
            descriptionLabel,
            inviteImageView,
            inviteLatelyButton,
            inviteButton
        )
    }
    
    private func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(103)
            $0.leading.equalToSuperview().offset(30)
            $0.width.equalTo(215)
            $0.height.equalTo(34)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(16)
            $0.leading.equalTo(self.titleLabel)
            $0.width.equalTo(250)
            $0.height.equalTo(48)
        }
        
        inviteImageView.snp.makeConstraints {
            $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(86)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.inviteLatelyButton.snp.top).offset(-30)
        }
        
        inviteLatelyButton.snp.makeConstraints {
            $0.bottom.equalTo(self.inviteButton.snp.top).offset(-15)
            $0.centerX.equalToSuperview()
        }
        
        inviteButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(315)
            $0.height.equalTo(54)
        }
    }
}
