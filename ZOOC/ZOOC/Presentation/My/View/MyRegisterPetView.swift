//
//  MyRegisterPetCollectionView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/11.
//



import UIKit

import SnapKit
import Then

final class MyRegisterPetView: UIView {
    
    // MARK: - Properties
    
    lazy var backButton = UIButton()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let subDescriptionLabel = UILabel()
    
    private let nameLabel = UILabel()
    private let requiredInputImageView = UIView()
    var nameTextField = ZoocEditTextField(textFieldType: .profile)
    private let breedLabel = UILabel()
    var breedTextField = ZoocEditTextField(textFieldType: .breed)
    var completeButton = UIButton()
    
    
    // MARK: - UI Components
    
    // MARK: - Life Cycle
    
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
            $0.text = "반려동물 등록"
            $0.textColor = .zw_black
        }
        descriptionLabel.do {
            $0.font = .zw_Subhead1
            $0.text = "반려동물의 정보를 입력해주세요"
            $0.textAlignment = .left
            $0.textColor = .zw_black
        }
        subDescriptionLabel.do {
            $0.font = .zw_Body1
            $0.text = "해당 정보는 상품 제작 및 관리에 활용돼요"
            $0.textColor = .zw_gray
            $0.textAlignment = .left
        }
        nameLabel.do {
            $0.text = "이름"
            $0.textColor = .zw_darkgray
            $0.font = .zw_Subhead4
        }
        
        requiredInputImageView.do {
            $0.backgroundColor = .zw_point
        }
        breedLabel.do {
            $0.text = "종"
            $0.textColor = .zw_darkgray
            $0.font = .zw_Subhead4
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
            nameLabel,
            descriptionLabel,
            subDescriptionLabel,
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
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(122)
            $0.leading.equalToSuperview().offset(28)
        }
        subDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(28)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(subDescriptionLabel.snp.bottom).offset(60)
            $0.leading.equalTo(descriptionLabel)
        }
        requiredInputImageView.snp.makeConstraints {
            $0.top.equalTo(subDescriptionLabel.snp.bottom).offset(62)
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
            $0.leading.equalTo(descriptionLabel)
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





