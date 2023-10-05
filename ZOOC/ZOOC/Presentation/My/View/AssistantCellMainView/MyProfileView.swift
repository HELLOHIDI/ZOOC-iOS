//
//  ProfileView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/01.
//

import UIKit

import SnapKit
import Then

final class MyProfileView: UIView {
    
    //MARK: - UI Components
    
    public var profileImageView = UIImageView()
    public var profileNameLabel = UILabel()
    public var editProfileButton = UIButton()
    
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
        profileImageView.do {
            $0.makeCornerRound(radius: 36)
            $0.setBorder(borderWidth: 2, borderColor: .zoocGray1)
            $0.contentMode = .scaleAspectFill
        }
        
        profileNameLabel.do {
            $0.textColor = .zoocDarkGray2
            $0.font = .zoocHeadLine
        }
        
        editProfileButton.do {
            $0.setTitle("편집", for: .normal)
            $0.titleLabel!.font = .zoocCaption
            $0.setTitleColor(.zoocGray2, for: .normal)
            $0.backgroundColor = .zoocWhite1
            $0.makeCornerRound(radius: 12)
            $0.setBorder(borderWidth: 1, borderColor: .zoocLightGreen)
        }
    }
    
    private func hierarchy() {
        self.addSubviews(
            profileImageView,
            profileNameLabel,
            editProfileButton
        )
    }
    
    private func layout() {
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(6)
            $0.size.equalTo(72)
        }
        
        profileNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(14)
        }
        
        editProfileButton.snp.makeConstraints {
            $0.centerY.equalTo(profileNameLabel)
            $0.trailing.equalToSuperview().inset(6)
            $0.width.equalTo(45)
            $0.height.equalTo(24)
        }
    }
}
