//
//  OrderBasicAddressView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/04.
//

import UIKit

import SnapKit
import RealmSwift

final class OrderBasicAddressView: UIView {
    
    //MARK: - Properties
    
    private var basicAddressDatas: Results<OrderBasicAddress>?  {
        didSet {
            basicAddressCollectionView.reloadData()
        }
    }
    
    //MARK: - UI Components
    
    private let basicAddressCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        return collectionView
    }()
    
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
        addSubviews(basicAddressCollectionView)
    }
    
    private func layout() {
        basicAddressCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func register() {
        basicAddressCollectionView.delegate = self
        basicAddressCollectionView.dataSource = self
        
        basicAddressCollectionView.register(OrderBasicAddressCollectionViewCell.self,
                                       forCellWithReuseIdentifier: OrderBasicAddressCollectionViewCell.cellIdentifier)
    }
    
    func updateUI(_ data: Results<OrderBasicAddress>? = nil, isPostData: Bool = false) {
        basicAddressDatas = data
    }
}

extension OrderBasicAddressView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        
        return CGSize(width: width, height: 189)
    }
    
}

extension OrderBasicAddressView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let basicAddressDatas = basicAddressDatas else { return 0}
        return basicAddressDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderBasicAddressCollectionViewCell.cellIdentifier, for: indexPath) as! OrderBasicAddressCollectionViewCell
        
        guard let basicAddressDatas = basicAddressDatas else { return UICollectionViewCell()}
        cell.dataBind(basicAddressDatas[indexPath.item])
        
        return cell
    }
}

