//
//  ShopEmptyView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/17.
//

import UIKit

import SnapKit
import Then

final class ShopPetEmptyView: UIView {
    
    // MARK: - Properties
    
    private let petEmptyImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    lazy var registerButton = ZoocGradientButton()
    
    // MARK: - UI Components
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hieararchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func style() {
        petEmptyImageView.do {
            $0.image = Image.graphics15
        }
        
        titleLabel.do {
            $0.text = "등록된 반려동물이 없어요"
            $0.font = .zoocHeadLine
            $0.textColor = .zoocGray2
            $0.textAlignment = .center
            $0.setLineSpacing(spacing: 2)
        }
        
        subTitleLabel.do {
            $0.text = "AI 모델 생성을 위해 먼저 반려동물을 등록해보세요"
            $0.font = .zoocBody1
            $0.textColor = .zoocGray1
            $0.textAlignment = .center
        }
        
        registerButton.do {
            $0.setTitle("등록하기", for: .normal)
        }
    }
    
    private func hieararchy() {
        self.addSubviews(
            petEmptyImageView,
            titleLabel,
            subTitleLabel,
            registerButton
        )
    }
    
    private func layout() {
        petEmptyImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(190)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(160)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(petEmptyImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(3)
            $0.centerX.equalToSuperview()
        }
        
        registerButton.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(54)
        }
    }
}





