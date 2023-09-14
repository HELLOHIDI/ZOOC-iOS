//
//  OrderBasicAddressView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/04.
//

import UIKit

import SnapKit
import RealmSwift

protocol OrderBasicAddressViewDelegate: AnyObject {
    func basicAddressCheckButtonDidTap(tag: Int)
    func basicAddressTextFieldDidChange(tag: Int, request: String?)
}

final class OrderBasicAddressView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: OrderBasicAddressViewDelegate?
    
    private var basicAddressDatas: Results<OrderBasicAddress>?  {
        didSet {
            basicAddressCollectionView.reloadData()
            let selectedIndex = basicAddressDatas?.firstIndex(where: { data in
                data.isSelected == true
            })
            guard let selectedIndex else { return }
            basicAddressCollectionView.selectItem(at: IndexPath(item: selectedIndex,
                                                                section: 0),
                                                  animated: true, scrollPosition: .centeredVertically)
        }
    }
    
    //MARK: - UI Components
    
    let basicAddressCollectionView: UICollectionView = {
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
        addSubviews(basicAddressCollectionView)
    }
    
    private func layout() {
        basicAddressCollectionView.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func register() {
        basicAddressCollectionView.delegate = self
        basicAddressCollectionView.dataSource = self
        
        basicAddressCollectionView.register(OrderBasicAddressCollectionViewCell.self,
                                            forCellWithReuseIdentifier: OrderBasicAddressCollectionViewCell.cellIdentifier)
    }
    
    func updateUI(_ data: Results<OrderBasicAddress>? = nil,
                  hasBasicAddressData: Bool = true) {
        basicAddressDatas = data
        
        if !hasBasicAddressData {
            self.isHidden = true
        }
    }
}

extension OrderBasicAddressView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width - 60
        var size = CGSize(width: width, height: 0) // 기본 높이 설정
        
        guard let basicAddressDatas = basicAddressDatas else { return size }
        
        let address = basicAddressDatas[indexPath.item]
        
        if address.isSelected {
            size.height = 229 // 선택된 주소의 높이
        } else {
            size.height = 138 // 선택되지 않은 주소의 높이
        }
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.basicAddressCheckButtonDidTap(tag: indexPath.row)
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
        cell.dataBind(tag: indexPath.item, basicAddressDatas[indexPath.item])
        cell.delegate = self
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
}

extension OrderBasicAddressView: OrderBasicAddressCollectionViewCellDelegate {
    
    func basicAddressTextFieldDidChange(tag: Int, request: String?) {
        delegate?.basicAddressTextFieldDidChange(tag: tag, request: request)
    }
}

