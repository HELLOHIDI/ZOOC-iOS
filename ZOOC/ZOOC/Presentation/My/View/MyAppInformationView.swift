//
//  AppInformationView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/03.
//

import UIKit

import SnapKit
import Then

final class MyAppInformationView: UIView {
    
    //MARK: - UI Components
    
    public var backButton = UIButton()
    private var appInformationLabel = UILabel()
    public var appInformationTableView = UITableView(frame: .zero, style: .plain)
    
    //MARK: - Life Cycles
    
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
    
    private func register() {
        appInformationTableView.register(
            AppInformationTableViewCell.self,
            forCellReuseIdentifier: AppInformationTableViewCell.cellIdentifier)
        
        appInformationTableView.register(MyAppInformationHeaderView.self, forHeaderFooterViewReuseIdentifier: MyAppInformationHeaderView.cellIdentifier)
    }
    
    private func style() {
        self.backgroundColor = .zoocBackgroundGreen
        
        backButton.do {
            $0.setImage(Image.back, for: .normal)
        }
        
        appInformationLabel.do {
            $0.font = .zoocHeadLine
            $0.text = "앱 정보"
            $0.textColor = .zoocDarkGray2
            $0.textAlignment = .center
        }
        
        appInformationTableView.do {
            $0.backgroundColor = .clear
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.separatorStyle = .none
            $0.isScrollEnabled = false
        }
    }
    
    private func hierarchy() {
        self.addSubviews(backButton,
                    appInformationLabel,
                    appInformationTableView
        )
    }
    
    private func layout() {
        backButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(11)
            $0.leading.equalToSuperview().offset(17)
            $0.size.equalTo(42)
        }
        
        appInformationLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(19)
            $0.centerX.equalToSuperview()
        }
        
        appInformationTableView.snp.makeConstraints {
            $0.top.equalTo(self.appInformationLabel.snp.bottom).offset(33)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview()
        }
    }
}
