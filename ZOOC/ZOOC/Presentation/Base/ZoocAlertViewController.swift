//
//  AlertView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/05.
//

import UIKit

import SnapKit
import Then

enum AlertType {
    case record
    case editProfile
    case editPetProfile
}

protocol ZoocAlertViewControllerDelegate: AnyObject {
    func exitButtonDidTap()
}

final class ZoocAlertViewController: UIViewController {
    
    //MARK: - Properties
    
    public var alertType: AlertType?
    weak var delegate: ZoocAlertViewControllerDelegate?
    
    //MARK: - UI Components
    
    private var alertView = UIView()
    private var contentView = UIView()
    private var alertTitleLabel = UILabel()
    private var alertSubTitleLabel = UILabel()
    private lazy var keepButton = UIButton()
    private lazy var exitButton = UIButton()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        target()
        
        style()
        hierarchy()
        layout()
        
    }
    
    //MARK: - Custom Method
    
    private func target() {
        exitButton.addTarget(self, action: #selector(popToMyViewButtonDidTap), for: .touchUpInside)
        keepButton.addTarget(self, action: #selector(keepButtonDidTap), for: .touchUpInside)
    }
    
    private func style() {
        view.backgroundColor = .clear
        
        alertView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 14
            $0.clipsToBounds = true
            $0.alpha = 1
        }
        
        contentView.do {
            $0.backgroundColor = .black
            $0.alpha = 0.45
        }
        
        alertTitleLabel.do {
            $0.backgroundColor = .white
            $0.font = .zoocSubhead2
            $0.text = "페이지를 나가시겠어요?"
            $0.textColor = .zoocDarkGray1
        }
        
        alertSubTitleLabel.do {
            $0.font = .zoocBody1
            $0.text = "지금 떠나면 내용이 저장되지 않아요"
            $0.textColor = .zoocGray1
            $0.textAlignment = .center
        }
        
        keepButton.do {
            $0.backgroundColor = .zoocMainGreen
            $0.setTitle("이어 쓰기", for: .normal)
            $0.setTitleColor(.zoocWhite1, for: .normal)
            $0.titleLabel?.textAlignment = .center
            $0.titleLabel?.font = .zoocSubhead1
        }
        
        exitButton.do {
            $0.backgroundColor = .zoocWhite3
            $0.setTitle("나가기", for: .normal)
            $0.setTitleColor(.zoocDarkGray2, for: .normal)
            $0.titleLabel?.textAlignment = .center
            $0.titleLabel?.font = .zoocSubhead1
        }
    }
    
    private func hierarchy() {
        view.addSubviews(contentView,alertView)
        alertView.addSubviews(alertTitleLabel, alertSubTitleLabel, keepButton, exitButton)
    }
    
    private func layout() {
        alertView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(299)
            $0.height.equalTo(180)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        alertTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(44)
            $0.centerX.equalToSuperview()
        }
        
        alertSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.alertTitleLabel.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
        
        keepButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(126)
            $0.leading.equalToSuperview()
            $0.width.equalTo(179)
            $0.height.equalTo(54)
        }
        
        exitButton.snp.makeConstraints {
            $0.top.equalTo(self.keepButton)
            $0.leading.equalTo(self.keepButton.snp.trailing)
            $0.width.equalTo(120)
            $0.height.equalTo(54)
        }
    }
    
    //MARK: - Action Method
    
    @objc func popToMyViewButtonDidTap() {
        dismiss(animated: false)
        delegate?.exitButtonDidTap()
    }
    
    @objc func keepButtonDidTap() {
        self.dismiss(animated: false)
    }
}
