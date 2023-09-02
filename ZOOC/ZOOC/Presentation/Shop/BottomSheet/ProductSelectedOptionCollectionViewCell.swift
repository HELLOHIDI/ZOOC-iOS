//
//  ProductOptionSelectedCollectionViewCell.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/02.
//

import UIKit

import SnapKit

final class ProductSelectedOptionCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    
    
    //MARK: - UI Components
    
    let optionLabel: UILabel = {
        let label = UILabel()
        label.text = "아이폰 13 플러스"
        label.font = .zoocBody3
        label.textColor = .zoocDarkGray1
        return label
    }()
    
    private lazy var xButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.xmark, for: .normal)
        button.addTarget(self,
                         action: #selector(xButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private let minusButton: BaseButton = {
        let button = BaseButton()
        button.setImage(Image.minusCircle, for: .normal)
        return button
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = .zoocBody3
        label.textColor = .zoocDarkGray2
        label.textAlignment = .center
        return label
    }()
    
    private let plusButton: BaseButton = {
        let button = BaseButton()
        button.setImage(Image.plusCircle, for: .normal)
        return button
    }()
    
    private let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = 999.priceText
        label.font = .zoocBody3
        label.textColor = .zoocDarkGray2
        return label
    }()
    
    //MARK: - Life Cycle
    
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
        contentView.makeCornerRound(radius: 4)
        contentView.backgroundColor = .zoocBackgroundGreen
    }
    
    private func hierarchy() {
        contentView.addSubviews(optionLabel,
                                xButton,
                                hStackView,
                                priceLabel)
        
        hStackView.addArrangedSubViews(minusButton,
                                       amountLabel,
                                       plusButton)
    }
    
    private func layout() {
        optionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.leading.equalToSuperview().inset(10)
        }
        
        xButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.size.equalTo(27)
        }
        
        hStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(10)
        }
        
        priceLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        minusButton.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        
        plusButton.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        
    }
    
    //MARK: - Action Method
    
    @objc
    private func xButtonDidTap() {
        print(#function)
    }
}

