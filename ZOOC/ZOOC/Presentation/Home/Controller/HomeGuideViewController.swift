//
//  HomeGuideView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/03/08.
//

import UIKit

import SnapKit
import Then


final class HomeGuideViewController : UIViewController{
    
    //MARK: - Properties
    
    //MARK: - UI Components
    
    private let backgroundView = UIView()
    private let graphicsImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let arrowImageView = UIImageView()
    private let dismissButton = UIButton()
    
    //MARK: - Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        hierarchy()
        layout()
        UserDefaultsManager.isFirstAttemptHome = false
    }
    
    //MARK: - Custom Method
    
    
    private func style() {
        
        view.do {
            $0.backgroundColor = .clear
        }
        
        backgroundView.do {
            $0.backgroundColor = .zoocDarkGray1
            $0.alpha = 0.95
        }
        
        graphicsImageView.do {
            $0.image = Image.graphics8
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.text = "가족의 첫 추억을 남겨볼까요?"
            $0.textColor = .zoocWhite1
            $0.font = .zoocHeadLine
        }
        
        subTitleLabel.do {
            $0.text = "아래 버튼을 눌러 시작해보세요"
            $0.textColor = .zoocGray1
            $0.font = .zoocBody3
        }
        
        arrowImageView.do {
            $0.image = Image.arrowDown
            $0.contentMode = .scaleAspectFit
        }
        
        dismissButton.do {
            $0.setImage(Image.xmarkWhite, for: .normal)
            $0.contentMode = .scaleAspectFit
            $0.addAction(UIAction(handler: { _ in
                self.dismiss(animated: false)
            }), for: .touchUpInside)
        }
    }
   
    
    private func hierarchy() {
        view.addSubview(backgroundView)
        
        view.addSubviews(graphicsImageView,
                         titleLabel,
                         subTitleLabel,
                         arrowImageView,
                         dismissButton)
    }
    
    private func layout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dismissButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(18)
            $0.trailing.equalToSuperview().offset(-25)
            $0.size.equalTo(42)
        }
        
        graphicsImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top).offset(-18)
            $0.size.equalTo(90)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-130)
        }
    }
}
