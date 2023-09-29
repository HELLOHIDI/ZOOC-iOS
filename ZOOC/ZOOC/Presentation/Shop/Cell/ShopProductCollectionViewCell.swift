//
//  ShopProductCollectionViewCell.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/03.
//

import UIKit

import SnapKit
import Then

final class ShopProductCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    //MARK: - UI Components
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.makeCornerRound(radius: 6)
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .zoocFont(font: .semiBold, size: 14)
        label.textColor = .zoocGray3
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .zoocFont(font: .medium, size: 14)
        label.textColor = .zoocGray3
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    //MARK: - Custom Method
    
    
    private func style() {
        
    }
    
    private func hierarchy() {
        contentView.addSubviews(imageView,
                                nameLabel,
                                priceLabel)
    }
    
    private func layout() {
        let cellWidth = (Device.width - 69) / 2
      
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(cellWidth * 200/153)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(12)
            $0.leading.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview()
        }
        
        //setNeedsLayout()
        
    }
    
    func dataBind(data: ProductResult) {
        guard data != ProductResult() else {
            setCommingSoon()
            return
        }
        imageView.kfSetImage(url: data.thumbnail)
        nameLabel.text = data.name
        priceLabel.text = data.price.priceText
    }
    
    func setCommingSoon() {
        imageView.image = Image.graphics14
        nameLabel.text = "COMMING SOON"
        priceLabel.text = "오픈 예정 제품이에요"
    }
    
    //MARK: - Action Method
    
}
