//
//  PaymentMethodView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/24.
//

import UIKit

import SnapKit


protocol OrderPaymentMethodViewDelegate: AnyObject {
    
}

final class OrderPaymentMethodView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: OrderPaymentMethodViewDelegate?
    
    //MARK: - UI Components
    
    private let headerView = UIView()
    private let mainView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "결제 수단"
        label.font = .zoocSubhead2
        label.textColor = .zoocDarkGray1
        return label
    }()
    
    private let paymentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 결제 수단은 무통장 입금만 가능합니다. \n추후 업데이트에 다른 결제 수단이 추가될 예정입니다."
        label.numberOfLines = 2
        label.textColor = .zoocGray1
        label.font = .zoocBody2
        label.textAlignment = .left
        label.setLineSpacing(spacing: 8)
        return label
    }()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hierarchy()
        layout()
        register()
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
        
        mainView.addSubviews(paymentCollectionView,
                             descriptionLabel)
    }
    
    private func layout() {
        
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().offset(30)
        }
        
        mainView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        paymentCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(41)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(paymentCollectionView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().inset(28)
        }
        
    }
    
    private func register() {
        paymentCollectionView.delegate = self
        paymentCollectionView.dataSource = self
        
        paymentCollectionView.register(OrderPaymentMethodCollectionViewCell.self,
                                       forCellWithReuseIdentifier: OrderPaymentMethodCollectionViewCell.cellIdentifier)
    }
    
    //MARK: - Action Method
    
    
    
}

extension OrderPaymentMethodView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width - 60
        
        return CGSize(width: width, height: 40)
    }
    
}

extension OrderPaymentMethodView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderPaymentMethodCollectionViewCell.cellIdentifier, for: indexPath) as! OrderPaymentMethodCollectionViewCell
        
        cell.dataBind(.withoutBankBook)
        return cell
    }
}
