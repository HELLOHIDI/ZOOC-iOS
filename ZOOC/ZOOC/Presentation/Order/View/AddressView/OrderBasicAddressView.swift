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
//            collectionView.reloadData()
//            let selectedIndex = basicAddressDatas?.firstIndex(where: { data in
//                data.isSelected == true
//            })
//            guard let selectedIndex else { return }
//            collectionView.selectItem(at: IndexPath(item: selectedIndex,
//                                                                section: 0),
//                                                  animated: true, scrollPosition: .centeredVertically)
        }
    }
    
    //MARK: - UI Components
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
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
        addSubviews(collectionView)
    }
    
    private func layout() {
        collectionView.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func register() {
        collectionView.delegate = self
        //collectionView.dataSource = self
        
        collectionView.register(OrderBasicAddressCollectionViewCell.self,
                                            forCellWithReuseIdentifier: OrderBasicAddressCollectionViewCell.cellIdentifier)
    }
    
    func dataBind(_ data: Results<OrderBasicAddress>?) {
        basicAddressDatas = data
    }
}

extension OrderBasicAddressView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width - 60
        var size = CGSize(width: width, height: 0) // 기본 높이 설정
        
        switch collectionView.indexPathsForSelectedItems?.first {
        case .some(indexPath):
            size.height = 229 // 선택된 주소의 높이
        default:
            size.height = 138 // 선택되지 않은 주소의 높이
        }
        
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        let cell = collectionView.cellForItem(at: indexPath) as! OrderBasicAddressCollectionViewCell
        return !cell.isSelected
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.performBatchUpdates(nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
}

extension OrderBasicAddressView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let basicAddressDatas else { return 0 }
        return basicAddressDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderBasicAddressCollectionViewCell.cellIdentifier, for: indexPath) as! OrderBasicAddressCollectionViewCell
        
        guard let basicAddressDatas = basicAddressDatas else { return UICollectionViewCell()}
        cell.dataBind(basicAddressDatas[indexPath.item])
        collectionView.performBatchUpdates(nil)
        return cell
    }
    
}

