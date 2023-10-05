//
//  ShopView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/30.
//

import UIKit

import SnapKit

final class ShopView: UIView {
    
    //MARK: - UI Components
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.back, for: .normal)
        button.isHidden = true //MARK: Shopping몰 <-> 마이페이지 위치 바뀌며 삭제된 버튼 (23.10.05)
        return button
    }()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView(image: Image.logoCombination)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let cartButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.cart, for: .normal)
        return button
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 9
        var width = (Device.width - 60 - 9) / 2
        let height = (width * 200 / 153) + 50
        layout.itemSize = CGSize(width: width, height: height)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .init(top: 0, left: 30, bottom: 0, right: 30)
        collectionView.register(ShopProductCollectionViewCell.self,
                                forCellWithReuseIdentifier: ShopProductCollectionViewCell.reuseCellIdentifier)
        return collectionView
    }()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI & Layout
    
    private func hierarchy() {
        addSubviews(backButton,
                    logoImageView,
                    cartButton,
                    collectionView)
    }
    
    private func layout() {
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(11)
            $0.leading.equalToSuperview().inset(17)
            $0.size.equalTo(42)
        }
        
        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton)
            $0.height.equalTo(30)
        }
        
        cartButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(11)
            $0.trailing.equalToSuperview().inset(17)
            $0.size.equalTo(42)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(69)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
    }
    
}
