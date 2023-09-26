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
    
    public lazy var myView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = false
        $0.alwaysBounceVertical = true
        $0.backgroundColor = .zoocBackgroundGreen
    }
    internal let profileView = MyProfileView()
    internal let familyView = MyFamilyView()
    internal let petView = MyPetView()
    internal let settingView = MySettingView()
    internal let deleteAccountView = MyDeleteAccountView()
    
    //MARK: - Life Cycles
    
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
        myView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
            $0.alwaysBounceVertical = true
            $0.backgroundColor = .zoocBackgroundGreen
        }
    }
    
    private func hierarchy() {
        self.addSubview(myView)
        myView.addSubviews(
            profileView,
            familyView,
            petView,
            settingView,
            deleteAccountView
        )
    }
    
    private func layout() {
        myView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview()
        }
        
        profileView.snp.makeConstraints {
            $0.top.equalTo(self.myView.snp.bottom).offset(38)
            $0.width.equalToSuperview()
            $0.height.equalTo(140)
        }
        familyView.snp.makeConstraints {
            $0.top.equalTo(self.profileView.snp.bottom).offset(30)
            $0.width.equalToSuperview()
            $0.height.equalTo(155)
        }
        petView.snp.makeConstraints {
            $0.top.equalTo(self.familyView.snp.bottom).offset(22)
            $0.width.equalToSuperview()
            $0.height.equalTo(127)
        }
        settingView.snp.makeConstraints {
            $0.top.equalTo(self.petView.snp.bottom).offset(40)
            $0.width.equalToSuperview()
            $0.height.equalTo(284)
        }
        deleteAccountView.snp.makeConstraints {
            $0.top.equalTo(self.settingView.snp.bottom).offset(103)
            $0.width.equalToSuperview()
            $0.height.equalTo(17)
        }
    }
}
