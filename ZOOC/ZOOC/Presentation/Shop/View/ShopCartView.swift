//
//  ShopCartView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/10/01.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class ShopCartView: UIView {
    
    //MARK: - UI Components
    
    let backButton: UIButton =  {
        let button = UIButton()
        button.setImage(Image.back, for: .normal)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "장바구니"
        label.font = .zoocHeadLine
        label.textColor = .zoocDarkGray2
        label.textAlignment = .left
        return label
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 24
        layout.itemSize = CGSize(width: Device.width - 60, height: 90)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        collectionView.register(ShopCartCollectionViewCell.self,
                                forCellWithReuseIdentifier: ShopCartCollectionViewCell.reuseCellIdentifier)
        return collectionView
    }()
    
    let bottomView = UIView()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .zoocLightGray
        return view
    }()
    
    let paymentInformationLabel: UILabel = {
        let label = UILabel()
        label.text = "결제 정보"
        label.font = .zoocSubhead2
        label.textColor = .zoocDarkGray2
        return label
    }()
    
    let productsPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "상품 가격"
        label.font = .pretendardFont(font: .medium, size: 16)
        label.textColor = .zoocGray2
        return label
    }()
    
    let productsPriceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardFont(font: .medium, size: 16)
        label.textColor = .zoocGray2
        label.textAlignment = .right
        return label
    }()
    
    let deliveryFeeLabel: UILabel = {
        let label = UILabel()
        label.text = "배송비"
        label.font = .pretendardFont(font: .medium, size: 16)
        label.textColor = .zoocGray2
        return label
    }()
    
    let deliveryFeeValueLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardFont(font: .medium, size: 16)
        label.textColor = .zoocGray2
        label.textAlignment = .right
        return label
    }()
    
    let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "총 결제 금액"
        label.font = .pretendardFont(font: .semiBold, size: 16)
        label.textColor = .zoocGray3
        return label
    }()
    
    let totalPriceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardFont(font: .semiBold, size: 16)
        label.textColor = .zoocMainGreen
        return label
    }()
    
    let orderButton: ZoocGradientButton = {
        let button = ZoocGradientButton()
        button.setTitle("\(0.priceText) 결제하기", for: .normal)
        return button
    }()
    
     let emptyCartView: UIView = {
        let view = UIView()
        view.backgroundColor = .zoocBackgroundGreen
        view.isHidden = true
        return view
    }()
    
     let emptyCartImageView: UIImageView = {
        let imageView = UIImageView(image: Image.cartLight)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let emptyCartLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 담은 상품이 없어요"
        label.font = .zoocHeadLine
        label.textColor = .zoocGray2
        label.textAlignment = .center
        return label
    }()
    
    let emptyCartButton: ZoocGradientButton = {
        let button = ZoocGradientButton(.order)
        button.setTitle("굿즈 담으러 가기", for: .normal)
        return button
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
    
     func style() {
        backgroundColor = .zoocBackgroundGreen
        
    }
    
     func hierarchy() {
        addSubviews(collectionView,
                         bottomView,
                         emptyCartView,
                         backButton,
                         titleLabel)
        
        bottomView.addSubviews(lineView,
                               paymentInformationLabel,
                               productsPriceLabel,
                               productsPriceValueLabel,
                               deliveryFeeLabel,
                               deliveryFeeValueLabel,
                               totalPriceLabel,
                               totalPriceValueLabel,
                               orderButton)
        
        emptyCartView.addSubviews(emptyCartImageView,
                                  emptyCartLabel,
                                  emptyCartButton)
    }
    
    private func layout() {
        
        //root View
        backButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(11)
            $0.leading.equalToSuperview().inset(17)
            $0.size.equalTo(42)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        
        bottomView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        // bottom View
        lineView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        paymentInformationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.equalToSuperview().inset(30)
        }
        
        productsPriceLabel.snp.makeConstraints {
            $0.top.equalTo(paymentInformationLabel.snp.bottom).offset(26)
            $0.leading.equalToSuperview().inset(30)
        }
        
        productsPriceValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(productsPriceLabel)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        deliveryFeeLabel.snp.makeConstraints {
            $0.top.equalTo(productsPriceLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(30)
        }
        
        deliveryFeeValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(deliveryFeeLabel)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        totalPriceLabel.snp.makeConstraints {
            $0.top.equalTo(deliveryFeeLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(30)
        }
        
        totalPriceValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(totalPriceLabel)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        orderButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(37)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(54)
        }
        
        
        emptyCartView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        emptyCartImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-40)
            $0.size.equalTo(95)
        }
        
        emptyCartLabel.snp.makeConstraints {
            $0.top.equalTo(emptyCartImageView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        emptyCartButton.snp.makeConstraints {
            $0.top.equalTo(emptyCartLabel.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(emptyCartLabel)
            $0.height.equalTo(52)
        }
    }
    
}

extension ShopCartView {
    func updateUI(_ data: [CartedProduct], deliveryFee: Int) {
        emptyCartView.isHidden = !data.isEmpty
        orderButton.isEnabled = !data.isEmpty
        
        let productsTotalPrice = data.reduce(0) { $0 + $1.productsPrice }
        let totalPrice = deliveryFee + productsTotalPrice
        
        productsPriceValueLabel.text = productsTotalPrice.priceText
        
        deliveryFeeValueLabel.text = deliveryFee.priceText
        totalPriceValueLabel.text = totalPrice.priceText
        orderButton.setTitle("\(totalPrice.priceText) 결제하기", for: .normal)
        totalPriceValueLabel.setAttributeLabel(
            targetString: ["원"],
            color: .zoocGray3,
            font: .zoocBody3,
            spacing: 0
        )
    }
}
