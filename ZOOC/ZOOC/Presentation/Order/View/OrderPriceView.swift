//
//  AmountOfPaymentView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/24.
//

import UIKit

import SnapKit

final class OrderPriceView: UIView {
    
    //MARK: - Properties
    
    
    //MARK: - UI Components
    
    private let headerView = UIView()
    private let mainView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "결제 금액"
        label.font = .zoocSubhead2
        label.textAlignment = .left
        label.textColor = .zoocDarkGray1
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "상품 금액"
        label.font = .zoocBody3
        label.textColor = .zoocGray2
        return label
    }()
    
    private let priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .zoocBody3
        label.textColor = .zoocGray2
        return label
    }()
    
    private let deliveryFeeLabel: UILabel = {
        let label = UILabel()
        label.text = "배송비"
        label.font = .zoocBody3
        label.textColor = .zoocGray2
        return label
    }()
    
    private let deliveryFeeValueLabel: UILabel = {
        let label = UILabel()
        label.font = .zoocBody3
        label.textColor = .zoocGray2
        return label
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "총 결제금액"
        label.font = .zoocSubhead1
        label.textColor = .zoocGray3
        return label
    }()
    
    private let totalPriceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .zoocHeadLine
        label.textColor = .zoocMainGreen
        label.setAttributeLabel(
            targetString: ["원"],
            color: .zoocGray3,
            font: .zoocBody3,
            spacing: 0
        )
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
        addSubviews(headerView, mainView)
        
        headerView.addSubviews(titleLabel)
        
        mainView.addSubviews(priceLabel,
                             priceValueLabel,
                             deliveryFeeLabel,
                             deliveryFeeValueLabel,
                             totalPriceLabel,
                             totalPriceValueLabel)
    }
    
    private func layout() {
        
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(75)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.centerY.equalToSuperview()
        }
        
        mainView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(30)
        }
        
        priceValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(priceLabel)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        deliveryFeeLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(30)
        }
        
        deliveryFeeValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(deliveryFeeLabel)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        totalPriceLabel.snp.makeConstraints {
            $0.top.equalTo(deliveryFeeValueLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(30)
        }
        
        totalPriceValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(totalPriceLabel)
            $0.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().inset(30)
        }
        
        
    }
    
    func updateUI(_ deliveryFee: Int,
                  _ productsTotalPrice: Int,
                  _ totalPrice: Int) {
        
        priceValueLabel.text = productsTotalPrice.priceTextWithSpacing
        deliveryFeeValueLabel.text = deliveryFee.priceTextWithSpacing
        totalPriceValueLabel.text = (productsTotalPrice + deliveryFee).priceTextWithSpacing
        
        totalPriceValueLabel.setAttributeLabel(
            targetString: ["원"],
            color: .zoocGray3,
            font: .zoocBody3,
            spacing: 0
        )
    }
    
    //MARK: - Action Method
    
    
    
}

