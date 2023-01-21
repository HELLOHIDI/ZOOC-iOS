//
//  ProfileView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/01.
//

import UIKit

import SnapKit
import Then

protocol EditButtonTappedDelegate: AnyObject {
    func editButtonTapped()
}

final class MyProfileSectionCollectionViewCell: UICollectionViewCell  {
    
    //MARK: - Properties
    
    weak var delegate: EditButtonTappedDelegate?
    
    //MARK: - UI Components
    
    public var profileImageView = UIImageView().then {
        $0.layer.cornerRadius = 36
        $0.layer.borderColor = UIColor.zoocGray1.cgColor
        $0.layer.borderWidth = 2
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    public var profileNameLabel = UILabel().then {
        $0.textColor = .zoocDarkGray2
        $0.font = .zoocHeadLine
    }
    
    public var editProfileButton = UIButton().then {
        $0.setTitle("편집", for: .normal)
        $0.titleLabel!.font = .zoocCaption
        $0.setTitleColor(.zoocGray2, for: .normal)
        $0.backgroundColor = .zoocWhite1
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.zoocLightGreen.cgColor
        $0.clipsToBounds = true
    }
    
    //MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method

    private func setLayout() {
        addSubviews(profileImageView, profileNameLabel, editProfileButton)
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(38)
            $0.leading.equalToSuperview().offset(38)
            $0.size.equalTo(72)
        }
        
        profileNameLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(62)
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(14)
        }
        
        editProfileButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(62)
            $0.trailing.equalToSuperview().inset(36)
            $0.width.equalTo(45)
            $0.height.equalTo(24)
        }
    }
    
    func dataBind(data: MyUser?) {
        
        if let imageURL = data?.photo{
            profileImageView.kfSetImage(url: imageURL)
        }
        else {
            profileImageView.image = Image.defaultProfile
        }
        profileNameLabel.text = data?.nickName
    }
}

