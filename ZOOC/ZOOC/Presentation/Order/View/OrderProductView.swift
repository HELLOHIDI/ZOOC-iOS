//
//  ProductView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/24.
//

import UIKit

import SnapKit

final class OrderProductView: UIView {
    
    //MARK: - Properties
    
    
    //MARK: - UI Components
    
    private let headerView = UIView()
    private let mainView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "주문 상품"
        label.font = .zoocHeadLine
        label.textColor = .zoocDarkGray1
        return label
    }()
    
    private lazy var foldButton: UIButton = {
        let button = UIButton()
        button.tintColor = .zoocDarkGray1
        button.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        button.setImage(UIImage(systemName: "chevron.down"), for: .selected)
        button.addTarget(self,
                         action: #selector(foldButtonDidTap),
                         for: .touchUpInside)
        button.isHidden = true //TODO: - 추후 폴더블한 애니메이션 구현
        return button
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.makeCornerRound(radius: 7)
        return imageView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .zoocDarkGray1
        label.font = .zoocSubhead1
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .zoocGray2
        label.font = .zoocSubhead1
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
        backgroundColor = .zoocBackgroundGreen
    }
    
    private func hierarchy() {
        headerView.addSubviews(titleLabel, foldButton)
        
        addSubviews(headerView, mainView)
        
        mainView.addSubviews(productImageView,
                             productNameLabel,
                             priceLabel)
        
    }
    
    private func layout() {
        
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        foldButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
        
        mainView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        productImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(30)
            $0.size.equalTo(80)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        productNameLabel.snp.makeConstraints {
            $0.top.equalTo(productImageView)
            $0.leading.equalTo(productImageView.snp.trailing).offset(10)
            
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(productNameLabel.snp.bottom).offset(7)
            $0.leading.equalTo(productNameLabel)
        }
        
    }
    
    func updateUI(_ data: OrderProduct) {
        productImageView.kfSetImage(url: data.imageURL)
        productNameLabel.text = data.name
        priceLabel.text = data.price.priceText
    }
    
    //MARK: - Action Method
    
    @objc
    private func foldButtonDidTap() {
        foldButton.isSelected.toggle()
        
    }
    
    
}
