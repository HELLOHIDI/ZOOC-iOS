//
//  ShopChoosePetView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/17.
//



import UIKit

import SnapKit
import Then

final class ShopChoosePetView: UIView {
    
    // MARK: - Properties
    
    let shopPetEmptyView = ShopPetEmptyView()
    let shopChoosePetCollectionView = ShopChoosePetCollectionView()
    
    // MARK: - UI Components
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hieararchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func style() {
        shopPetEmptyView.do {
            $0.isHidden = true
        }
    }
    
    private func hieararchy() {
        self.addSubviews(
            shopPetEmptyView,
            shopChoosePetCollectionView
        )
    }
    
    private func layout() {
        shopPetEmptyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        shopChoosePetCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
