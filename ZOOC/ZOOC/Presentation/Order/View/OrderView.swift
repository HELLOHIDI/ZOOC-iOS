//
//  OrderView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/10/07.
//

import UIKit

import SnapKit

final class OrderView: UIView {
    
    //MARK: - Properties
    
    let backButton = UIButton()
    let titleLabel = UILabel()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let productView = OrderProductView()
    let ordererView = OrderOrdererView()
    let addressView = OrderAddressView()
    let paymentMethodView = OrderPaymentMethodView()
    let priceView = OrderPriceView()
    let agreementView = OrderAgreementView()
    
    let orderButton = ZoocGradientButton()
    
    
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
        
        backButton.do {
            $0.setImage(Image.back, for: .normal)
        }
        
        titleLabel.do {
            $0.text = "주문하기"
            $0.font = .zoocHeadLine
            $0.textColor = .zoocDarkGray2
            $0.textAlignment = .left
        }
        
        scrollView.do {
            $0.backgroundColor = .zoocBackgroundGreen
            $0.alwaysBounceVertical = true
            $0.showsVerticalScrollIndicator = false
        }
        
        contentView.do {
            $0.backgroundColor = .zoocLightGray
        }
        
        orderButton.do {
            $0.setTitle("결제하기", for: .normal)
        }
    }
    
    private func hierarchy() {
        addSubviews(backButton, titleLabel, scrollView, orderButton)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(addressView,
                                productView,
                                ordererView,
                                paymentMethodView,
                                priceView,
                                agreementView)
    }
    
    private func layout() {
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(53)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(42)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.centerX.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(orderButton.snp.top).offset(-5)
        }
        
        orderButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(54)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(scrollView.frameLayoutGuide).priority(.low)
        }
        
        productView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.greaterThanOrEqualTo(400)
        }
        
        ordererView.snp.makeConstraints {
            $0.top.equalTo(productView.snp.bottom).offset(1)
            $0.horizontalEdges.equalToSuperview()
        }
        
        addressView.snp.makeConstraints {
            $0.top.equalTo(ordererView.snp.bottom).offset(1)
            $0.horizontalEdges.equalToSuperview()
        }
        
        paymentMethodView.snp.makeConstraints {
            $0.top.equalTo(addressView.snp.bottom).offset(1)
            $0.horizontalEdges.equalToSuperview()
        }
        
        priceView.snp.makeConstraints {
            $0.top.equalTo(paymentMethodView.snp.bottom).offset(1)
            $0.horizontalEdges.equalToSuperview()
        }
        
        agreementView.snp.makeConstraints {
            $0.top.equalTo(priceView.snp.bottom).offset(1)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Update UI
    
    func updateUI(_ deliveryFee: Int,
                  _ productsTotalPrice: Int,
                  _ totalPrice: Int) {
        
        priceView.updateUI(deliveryFee, productsTotalPrice, totalPrice)
        orderButton.setTitle("\(totalPrice.priceText) 원", for: .normal)
    }
    
    func updateUI(_ productData: [OrderProduct]) {
        productView.updateUI(productData)
        
        let totalHeight = 60 + productData.count * 90 + (productData.count - 1) * 24 + 30
        productView.snp.remakeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(totalHeight)
        }
    }
    
    
    
}
