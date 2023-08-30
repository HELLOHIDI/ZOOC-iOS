//
//  OrderAssistantHeaderView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/31.
//

import UIKit

final class OrderAssistantHeaderView: UICollectionReusableView {
    
    //MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "무통장 입금을 도와드릴게요"
        label.textColor = .zoocDarkGray1
        label.textAlignment = .center
        label.font = .zoocHeadLine
        return label
    }()
      
    //MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    private func setUI() {
        self.backgroundColor = .clear
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    
}

