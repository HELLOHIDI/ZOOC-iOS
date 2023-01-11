//
//  MyView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/01.
//

import UIKit

import SnapKit
import Then

final class MyView: UIView  {
    
    //MARK: - UI Components
    
    public lazy var myCollectionView = UICollectionView(
        frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
            $0.alwaysBounceVertical = true
            $0.register(MyProfileSectionCollectionViewCell.self, forCellWithReuseIdentifier: MyProfileSectionCollectionViewCell.cellIdentifier)
            $0.register(MyFamilySectionCollectionViewCell.self, forCellWithReuseIdentifier: MyFamilySectionCollectionViewCell.cellIdentifier)
            $0.register(MyPetSectionCollectionViewCell.self, forCellWithReuseIdentifier: MyPetSectionCollectionViewCell.cellIdentifier)
            $0.register(MySettingSectionCollectionViewCell.self, forCellWithReuseIdentifier: MySettingSectionCollectionViewCell.cellIdentifier)
            $0.register(MyDeleteAccountSectionCollectionViewCell.self, forCellWithReuseIdentifier: MyDeleteAccountSectionCollectionViewCell.cellIdentifier)
            
        }
    
    //MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    private func setUI() {
        myCollectionView.backgroundColor = .zoocBackgroundGreen
    }
    
    private func setLayout() {
        addSubviews(myCollectionView)
        
        myCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}



