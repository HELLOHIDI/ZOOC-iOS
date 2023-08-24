//
//  PaymentMethodView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/24.
//

import UIKit

import SnapKit

final class PaymentMethodView: UIView {
    
    //MARK: - Properties
    
    
    //MARK: - UI Components
    
    private let headerView = UIView()
    private let mainView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "결제 수단"
        label.font = .zoocHeadLine
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
        label.text = "현재 무통장만 됩니당"
        label.backgroundColor = .zoocLightGray
        label.makeCornerRound(radius: 7)
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
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        mainView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        paymentCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(80)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(paymentCollectionView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
        }
        
    }
    
    private func register() {
        paymentCollectionView.delegate = self
        paymentCollectionView.dataSource = self
        
        paymentCollectionView.register(PaymentMethodCollectionViewCell.self,
                                       forCellWithReuseIdentifier: PaymentMethodCollectionViewCell.cellIdentifier)
    }
    
    //MARK: - Action Method
    
    
    
}

extension PaymentMethodView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        
        return CGSize(width: width, height: 60)
    }
    
}

extension PaymentMethodView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaymentMethodCollectionViewCell.cellIdentifier, for: indexPath) as! PaymentMethodCollectionViewCell
        
        cell.dataBind(.withoutBankBook)
        return cell
    }
    
    
    
}
