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
        label.text = "상품 정보"
        label.font = .zoocSubhead2
        label.textColor = .zoocDarkGray1
        label.textAlignment = .left
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
        label.text = "1개 | "
        label.textColor = .zoocGray2
        label.font = .zoocBody1
        label.textAlignment = .right
        return label
    }()
    
    private let phoneModelLabel: UILabel = {
        let label = UILabel()
        label.text = "갤럭시 노트 10"
        label.textColor = .zoocGray2
        label.font = .zoocBody1
        label.textAlignment = .right
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
                             priceLabel,
                             productCntLabel,
                             phoneModelLabel)
        
    }
    
    private func layout() {
        
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
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
            $0.size.equalTo(90)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        productNameLabel.snp.makeConstraints {
            $0.top.equalTo(productImageView)
            $0.leading.equalTo(productImageView.snp.trailing).offset(16)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(productNameLabel.snp.bottom).offset(7)
            $0.leading.equalTo(productNameLabel)
        }
        
        productCntLabel.snp.makeConstraints {
            $0.top.equalTo(self.priceLabel.snp.bottom).offset(18)
            $0.leading.equalTo(self.productImageView.snp.trailing).offset(16)
        }
        
        phoneModelLabel.snp.makeConstraints {
            $0.top.equalTo(self.productCntLabel)
            $0.leading.equalTo(self.productCntLabel.snp.trailing)
        }
    }
    
    func updateUI(_ data: [SelectedProductOption]) {
        
        //TODO: - data 배열을 사용하여 CollectionView 만들어야함!!
        
        productImageView.kfSetImage(url: data[0].image)
        productNameLabel.text = data[0].option
        priceLabel.text = data[0].price.priceText
    }
    
    //MARK: - Action Method
    
    @objc
    private func foldButtonDidTap() {
        foldButton.isSelected.toggle()
        
    }
    
    
}
