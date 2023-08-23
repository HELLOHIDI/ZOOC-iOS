//
//  GenAIRegisterPetView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/17.
//

import UIKit

import SnapKit
import Then

final class GenAIRegisterPetView: UIView {
    
    //MARK: - UI Components
    
    public var cancelButton = UIButton()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    private let petProfileView = UIView()
    public var petProfileImageButton = UIButton()
    public var petProfileNameTextField = MyEditTextField(textFieldType: .pet)
    public var completeButton = ZoocGradientButton()
    
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
        
        cancelButton.do {
            $0.setImage(Image.back, for: .normal)
        }

        titleLabel.do {
            $0.font = .zoocHeadLine
            $0.text = "AI 모델을 만들기 위해 \n먼저 반려동물을 등록해볼까요?"
            $0.textColor = .zoocDarkGray1
            $0.numberOfLines = 2
            $0.textAlignment = .left
        }
        
        subTitleLabel.do {
            $0.font = .zoocBody3
            $0.text = "반려동물 등록"
            $0.textColor = .zoocDarkGray2
        }
        
        petProfileImageButton.do {
            $0.makeCornerBorder(borderWidth: 5, borderColor: UIColor.zoocWhite1)
            $0.makeCornerRound(radius: 35)
            $0.imageView?.contentMode = .scaleAspectFill
        }

        petProfileNameTextField.do {
            $0.attributedPlaceholder = NSAttributedString(string: "ex) 사랑,토리 (4자 이내)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.zoocGray1, NSAttributedString.Key.font: UIFont.zoocBody1])
            $0.addLeftPadding(inset: 10)
            $0.textColor = .zoocDarkGreen
            $0.font = .zoocBody1
            $0.makeCornerRound(radius: 20)
            $0.returnKeyType = .done
            $0.makeCornerBorder(borderWidth: 1, borderColor: UIColor.zoocLightGray)
        }

        completeButton.do {
            $0.setTitle("등록하기", for: .normal)
            $0.isEnabled = false
        }
    }
    
    private func hierarchy() {
        self.addSubviews(
            cancelButton,
            titleLabel,
            subTitleLabel,
            petProfileImageButton,
            petProfileNameTextField,
            completeButton)
    }
    
    private func layout() {
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            $0.trailing.equalToSuperview().offset(17)
            $0.size.equalTo(42)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(103)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(30)
        }
        
        petProfileView.snp.makeConstraints {
            $0.top.equalTo(self.subTitleLabel.snp.bottom).offset(34)
            $0.leading.equalToSuperview().offset(30)
            $0.height.equalTo(70)
        }
        
        petProfileImageButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.size.equalTo(70)
        }
        
        petProfileNameTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(17)
            $0.leading.equalTo(self.petProfileImageButton.snp.trailing).offset(9)
            $0.width.equalTo(236)
            $0.height.equalTo(36)
        }
        
        completeButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(27)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(315)
            $0.height.equalTo(54)
        }
    }
}







