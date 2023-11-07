//
//  EditProfileView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/04.
//

import UIKit

import SnapKit
import Then

final class MyEditProfileView: UIView {
    
    //MARK: - UI Components
    
    let backButton = UIButton()
    private let titleLabel = UILabel()
    
    var profileImageButton = UIButton()
    private let cameraIconImageView = UIImageView()
    
    private let nameLabel = UILabel()
    private let requiredInputImageView = UIView()
    var nameTextField = ZoocEditTextField(textFieldType: .pet)
    private let breedLabel = UILabel()
    var breedTextField = UITextField()
    var completeButton = UIButton()
    
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        profileImageButton.makeCornerRound(ratio: 2)
        cameraIconImageView.makeCornerRound(ratio: 2)
        requiredInputImageView.makeCornerRound(radius: 2)
    }
    
    //MARK: - Custom Method
    
    private func style() {
        self.backgroundColor = .zoocBackgroundGreen
        
        backButton.do {
            $0.setImage(Image.back, for: .normal)
        }

        titleLabel.do {
            $0.font = .zw_Subhead2
            $0.text = "프로필 수정"
            $0.textColor = .zw_black
        }
        
        profileImageButton.do {
            $0.setImage(.zwImage(.mock_hidi), for: .normal)
            $0.imageView?.contentMode = .scaleAspectFill
        }
        
        cameraIconImageView.do {
            $0.image = .zwImage(.btn_picture)
            $0.contentMode = .scaleAspectFill
        }
        
        nameLabel.do {
            $0.text = "이름"
            $0.textColor = .zw_darkgray
            $0.font = .zw_Subhead4
        }
        
        requiredInputImageView.do {
            $0.backgroundColor = .zw_point
        }
        nameTextField.do {
            $0.addLeftPadding(inset: 20)
            $0.font = .zw_Body1
            $0.textColor = .zw_black
            $0.setBorder(borderWidth: 1, borderColor: .zw_brightgray)
        }
        breedLabel.do {
            $0.text = "종"
            $0.textColor = .zw_darkgray
            $0.font = .zw_Subhead4
        }
        breedTextField.do {
            $0.addLeftPadding(inset: 20)
            $0.font = .zw_Body1
            $0.textColor = .zw_black
            $0.setBorder(borderWidth: 1, borderColor: .zw_brightgray)
        }
        completeButton.do {
            $0.backgroundColor = .zw_black
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor(.zw_white, for: .normal)
        }
    }
    
    private func hierarchy() {
        self.addSubviews(
            backButton,
            titleLabel,
            profileImageButton,
            cameraIconImageView,
            nameLabel,
            requiredInputImageView,
            nameTextField,
            breedLabel,
            breedTextField,
            completeButton
        )
    }
    
    private func layout() {
        backButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(10)
            $0.leading.equalToSuperview().offset(17)
            $0.size.equalTo(42)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(19)
            $0.centerX.equalToSuperview()
        }
        profileImageButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(112)
            $0.leading.equalToSuperview().offset(28)
            $0.size.equalTo(90)
        }
        cameraIconImageView.snp.makeConstraints {
            $0.top.equalTo(profileImageButton).offset(60)
            $0.leading.equalTo(profileImageButton).offset(68)
            $0.size.equalTo(30)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageButton.snp.bottom).offset(36)
            $0.leading.equalTo(profileImageButton)
        }
        requiredInputImageView.snp.makeConstraints {
            $0.top.equalTo(profileImageButton.snp.bottom).offset(38)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(2)
            $0.size.equalTo(6)
        }
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(50)
        }
        breedLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(24)
            $0.leading.equalTo(profileImageButton)
        }
        breedTextField.snp.makeConstraints {
            $0.top.equalTo(breedLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(50)
        }
        completeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(77)
        }
    }
}

