//
//  OrderProductCollectionViewCell.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/08.
//

import UIKit

import SnapKit

final class OrderProductCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    //MARK: - UI Components
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.makeCornerRound(radius: 7)
        return imageView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .zoocGray3
        label.font = .zoocSubhead1
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 64, g: 64, b: 64)
        label.font = .zoocHeadLine
        return label
    }()
    
    private let productCntLabel: UILabel = {
        let label = UILabel()
        label.textColor = .zoocGray2
        label.font = .zoocBody1
        label.textAlignment = .right
        return label
    }()
    
    private let phoneModelLabel: UILabel = {
        let label = UILabel()
        label.textColor = .zoocGray2
        label.font = .zoocBody1
        label.textAlignment = .right
        return label
    }()
    
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
        contentView.addSubviews(productImageView,
                                productNameLabel,
                                priceLabel,
                                productCntLabel,
                                phoneModelLabel)
        
    }
    
    private func layout() {
        productImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.size.equalTo(90)
        }
        
        productNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(productImageView.snp.trailing).offset(16)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(productNameLabel.snp.bottom).offset(6)
            $0.leading.equalTo(productNameLabel)
        }
        
        productCntLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(18)
            $0.leading.equalTo(productNameLabel)
        }
        
        phoneModelLabel.snp.makeConstraints {
            $0.top.equalTo(productCntLabel)
            $0.leading.equalTo(productCntLabel.snp.trailing)
        }
    }
   
    
    //MARK: - Public Methods
    
    func dataBind(_ data: SelectedProductOption) {
        productImageView.kfSetImage(url: data.image)
        productNameLabel.text = data.name
        priceLabel.text = "\(data.price)원"
        productCntLabel.text = "\(data.amount)개"
        phoneModelLabel.text = " | \(data.option)"
    }
}
