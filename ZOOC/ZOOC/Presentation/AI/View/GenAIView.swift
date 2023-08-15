//
//  GenAIView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/15.
//

import UIKit

import SnapKit
import Then

final class GenAIView: UIView {
    
    //MARK: - UI Components
    
    public var backButton = UIButton()
    
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
        self.backgroundColor = .zoocBackgroundGreen
        
        backButton.do {
            $0.setImage(Image.back, for: .normal)
        }
    }
    
    private func hierarchy() {
        self.addSubviews(backButton)
    }
        
    
    private func layout() {
        backButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(11)
            $0.leading.equalToSuperview().offset(17)
            $0.size.equalTo(42)
        }
    }
}
    
    
