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
    
    internal var scrollView = UIScrollView()
    private let contentView = UIView()
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
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    private func hierarchy() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            profileView,
            familyView,
            petView,
            settingView,
            deleteAccountView
        )
    }
    
    private func layout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(scrollView.frameLayoutGuide).priority(.low)
        }
        
        profileView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(38)
            $0.width.equalToSuperview()
            $0.height.equalTo(72)
        }
        
        familyView.snp.makeConstraints {
            $0.top.equalTo(self.profileView.snp.bottom).offset(30)
            $0.width.equalToSuperview()
            $0.height.equalTo(155)
        }
        
        petView.snp.makeConstraints {
            $0.top.equalTo(self.familyView.snp.bottom).offset(12)
            $0.width.equalToSuperview()
            $0.height.equalTo(127)
        }
        
        settingView.snp.makeConstraints {
            $0.top.equalTo(self.petView.snp.bottom).offset(24)
            $0.width.equalToSuperview()
            $0.height.equalTo(284)
        }
        
        deleteAccountView.snp.makeConstraints {
            $0.top.equalTo(self.settingView.snp.bottom).offset(40)
            $0.width.equalToSuperview()
            $0.height.equalTo(42)
            $0.bottom.equalToSuperview().inset(133)
        }
    }
}
