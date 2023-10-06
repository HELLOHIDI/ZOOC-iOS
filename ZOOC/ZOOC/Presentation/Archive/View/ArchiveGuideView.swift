//
//  ArchiveGuideViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2023/05/16.
//

import UIKit

import SnapKit
import Then


final class ArchiveGuideView: UIView{
    
    //MARK: - Properties
    
    //MARK: - UI Components
    
    private let backgroundView = UIView()
    private let graphicsImageView = UIImageView()
    private let dismissButton = UIButton()
    private let okButton = ZoocGradientButton()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isHidden = true
        style()
        hierarchy()
        layout()
        UserDefaultsManager.isFirstAttemptArchive = false
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    
    private func style() {
        
        backgroundColor = .clear
        
        
        backgroundView.do {
            $0.backgroundColor = .black
            $0.alpha = 0.80
        }
        
        graphicsImageView.do {
            $0.image = Image.graphics11
            $0.contentMode = .scaleAspectFill
        }
        
        okButton.do {
            $0.setTitle("알겠어요", for: .normal)
            $0.addAction(UIAction(handler: { _ in
                self.isHidden = true
            }), for: .touchUpInside)
        }
        
        dismissButton.do {
            $0.setImage(Image.xmarkWhite, for: .normal)
            $0.contentMode = .scaleAspectFit
            $0.addAction(UIAction(handler: { _ in
                self.isHidden = true
            }), for: .touchUpInside)
        }
    }
   
    
    private func hierarchy() {
        addSubview(backgroundView)
        
        addSubviews(graphicsImageView,
                    dismissButton,
                    okButton)
    }
    
    private func layout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dismissButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(18)
            $0.trailing.equalToSuperview().offset(-25)
            $0.size.equalTo(42)
        }
        
        graphicsImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-40)
            $0.leading.trailing.equalToSuperview().inset(55)
            $0.height.equalTo(173)
        }
        
        okButton.snp.makeConstraints {
            $0.top.equalTo(graphicsImageView.snp.bottom).offset(70)
            $0.leading.trailing.equalToSuperview().inset(113)
            $0.height.equalTo(54)
        }
    }
}
