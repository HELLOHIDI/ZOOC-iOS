//
//  ProfileView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/01.
//

import Foundation
import UIKit

import SnapKit
import Then

final class ProfileView : UIView  {
    
    //MARK: - UI Components
    
    private var profileImage = UIImageView().then {
        $0.image = Image.profileImage
        $0.layer.cornerRadius = 40.5
        $0.layer.borderColor = UIColor.zoocGray1.cgColor
        $0.layer.borderWidth = 2
        $0.clipsToBounds = true
    }
    
    private var profileNameLabel = UILabel().then {
        $0.text = "복실맘"
        $0.textColor = UIColor.zoocDarkGray2
        $0.font = UIFont.zoocHeadLine
    }
    
    private var profileEmailLabel = UILabel().then {
        $0.text = "02rin@naver.com"
        $0.textColor = UIColor.zoocDarkGreen
        $0.font = UIFont.zoocBody1
    }
    
    private var editProfileButton = UIButton().then {
        $0.setTitle("편집", for: .normal)
        $0.titleLabel!.font = UIFont.zoocCaption
        $0.setTitleColor(UIColor.zoocGray2, for: .normal)
        $0.backgroundColor = UIColor.zoocWhite2
        $0.layer.cornerRadius = 21.5
        $0.clipsToBounds = true
    }
    
    //MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    private func setUI() {
        a
        addSubviews(profileImage, profileNameLabel, profileEmailLabel, editProfileButton)
    }
    
    
    private func setLayout() {
        profileImage.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(39)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(81)
        }
        
        profileNameLabel.snp.makeConstraints {
            $0.top.equalTo(self.profileImage.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        profileEmailLabel.snp.makeConstraints {
            $0.top.equalTo(self.profileNameLabel.snp.bottom).offset(3)
            $0.centerX.equalToSuperview()
        }
        
        editProfileButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(38)
            $0.leading.equalTo(self.profileImage.snp.trailing).offset(62)
            $0.width.equalTo(53)
            $0.height.equalTo(24)
        }
    }
}

