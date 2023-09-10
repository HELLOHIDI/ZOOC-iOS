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
    
    private var productData: [OrderProduct] = [] {
        didSet {
            productCollectionView.reloadData()
        }
    }
    
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
    
    private let productCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        register()
        delegate()
        
        style()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    //MARK: - Custom Method
    
    private func delegate() {
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
    }
    
    private func register() {
        productCollectionView.register(
            OrderProductCollectionViewCell.self,
            forCellWithReuseIdentifier: OrderProductCollectionViewCell.cellIdentifier
        )
    }
    
    private func style() {
        backgroundColor = .zoocBackgroundGreen
    }
    
    private func hierarchy() {
        headerView.addSubviews(titleLabel)
        
        addSubviews(headerView, mainView)
        
        mainView.addSubview(productCollectionView)
        
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
        
        mainView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(30)
        }
        
        productCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func updateUI(_ data: [OrderProduct]) {
        productData = data
    }
    
    //MARK: - Action Method
    
}

extension OrderProductView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        
        return CGSize(width: width, height: 90)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
}

extension OrderProductView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderProductCollectionViewCell.cellIdentifier, for: indexPath) as? OrderProductCollectionViewCell else { return UICollectionViewCell() }
        cell.dataBind(productData[indexPath.item])
        return cell
    }
}
