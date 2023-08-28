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
        label.font = .zoocHeadLine
        label.textColor = .zoocDarkGray1
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "상품 금액"
        label.font = .zoocBody2
        label.textColor = .zoocGray2
        return label
    }()
    
    private let priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .zoocBody2
        label.textColor = .zoocDarkGray2
        return label
    }()
    
    private let deliveryFeeLabel: UILabel = {
        let label = UILabel()
        label.text = "배송비"
        label.font = .zoocBody2
        label.textColor = .zoocGray2
        return label
    }()
    
    private let deliveryFeeValueLabel: UILabel = {
        let label = UILabel()
        label.font = .zoocBody2
        label.textColor = .zoocDarkGray1
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .zoocGray1
        return view
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "최종 결제 금액"
        label.font = .zoocHeadLine
        label.textColor = .zoocDarkGray1
        return label
    }()
    
    private let totalPriceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .zoocHeadLine
        label.textColor = .zoocDarkGray1
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
                             lineView,
                             totalPriceLabel,
                             totalPriceValueLabel)
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
        
        mainView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        priceValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(priceLabel)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        deliveryFeeLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        deliveryFeeValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(deliveryFeeLabel)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(deliveryFeeLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        
        totalPriceLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        totalPriceValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(totalPriceLabel)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(30)
        }
        
        
    }
    
    func updateUI(_ data: OrderPrice) {
        priceValueLabel.text = data.productPrice.priceText
        deliveryFeeValueLabel.text = data.deliveryFee.priceText
        totalPriceValueLabel.text = data.totalPrice.priceText
    }
    
    //MARK: - Action Method
    
    
    
}

