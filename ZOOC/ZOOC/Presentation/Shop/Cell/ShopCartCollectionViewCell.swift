//
//  ShopCartCollectionViewCell.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/07.
//

import UIKit

import SnapKit
import Then


protocol ShopCartCollectionViewCellDelegate: AnyObject {
    func adjustAmountButtonDidTap(row: Int, isPlus: Bool)
    func xButtonDidTap(row: Int)
}

final class ShopCartCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    weak var delegate: ShopCartCollectionViewCellDelegate?
    
    private var row: Int?
    
    //MARK: - UI Components
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.setBorder(borderWidth: 1, borderColor: .zoocLightGray)
        imageView.makeCornerRound(radius: 6)
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardFont(font: .semiBold, size: 16)
        label.textColor = .zoocGray3
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = 0.priceText
        label.font = .pretendardFont(font: .semiBold, size: 20)
        label.textColor = .zoocDarkGray2
        return label
    }()
    
    private let optionLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardFont(font: .medium, size: 14)
        label.textColor = .zoocGray2
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
    
    private lazy var minusButton: BaseButton = {
        let button = BaseButton()
        button.setImage(Image.minusCircle, for: .normal)
        button.addTarget(self,
                         action: #selector(minusButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardFont(font: .medium, size: 20)
        label.textColor = .zoocDarkGray2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var plusButton: BaseButton = {
        let button = BaseButton()
        button.setImage(Image.plusCircle, for: .normal)
        button.addTarget(self,
                         action: #selector(plusButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 8
        return stackView
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
        contentView.backgroundColor = .zoocBackgroundGreen
    }
    
    private func hierarchy() {
        contentView.addSubviews(imageView,
                                nameLabel,
                                priceLabel,
                                optionLabel,
                                xButton,
                                hStackView)
        
        hStackView.addArrangedSubViews(minusButton,
                                       amountLabel,
                                       plusButton)
    }
    
    private func layout() {
        
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.size.equalTo(90)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(imageView.snp.trailing).offset(16)
            
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(6)
            $0.leading.equalTo(nameLabel)
        }
        
        optionLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.equalTo(nameLabel)
        }
        
        xButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.size.equalTo(27)
        }
        
        hStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        minusButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        plusButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
    }
    
    func dataBind(row: Int,
                  selectedOption: CartedProduct) {
        self.row = row
        
        imageView.kfSetImage(url: selectedOption.image)
        nameLabel.text = selectedOption.name
        optionLabel.text = selectedOption.option
        amountLabel.text = String(selectedOption.pieces)
        priceLabel.text = selectedOption.productsPrice.priceText
    }
    
    //MARK: - Action Method
    
    @objc
    private func minusButtonDidTap() {
        guard let row else { return }
        delegate?.adjustAmountButtonDidTap(row: row, isPlus: false)
    }
    
    @objc
    private func plusButtonDidTap() {
        guard let row else { return }
        delegate?.adjustAmountButtonDidTap(row: row, isPlus: true)
    }
    
    @objc
    private func xButtonDidTap() {
        guard let row else { return }
        delegate?.xButtonDidTap(row: row)
    }
}

