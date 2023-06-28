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
    case needLogin
    case leavePage
    case deleteArchive
    case deleteAccount
    
    var title: String {
        switch self {
        
        case .needLogin:
            return "로그인 후 작성해보세요!"
        case .leavePage:
            return "페이지를 나가시겠어요?"
        case .deleteArchive:
            return "게시글을 삭제하시겠어요?"
        case .deleteAccount:
            return "회원 탈퇴 하시겠습니까?"
        }
    }
    
    var description: String {
        switch self {
            
        case .needLogin:
            return "가족과 강아지 사진을 공유할 수 있어요"
        case .leavePage:
            return "지금 떠나면 내용이 저장되지 않아요"
        case .deleteArchive:
            return "삭제하면 글과 사진이 모두 삭제돼요"
        case .deleteAccount:
            return "회원 탈퇴 시 자동으로 가족에서 탈퇴되고\n작성한 글과 댓글이 모두 삭제됩니다"
        }
    }
    
    var keep: String {
        switch self {
            
        case .needLogin:
            return "로그인 하기"
        case .leavePage:
            return "이어 쓰기"
        case .deleteArchive:
            return "아니오"
        case .deleteAccount:
            return "계속 할래요"
        }
    }
    
    var exit: String {
        switch self {
            
        case .needLogin:
            return "취소"
        case .leavePage:
            return "나가기"
        case .deleteArchive:
            return "삭제"
        case .deleteAccount:
            return "탈퇴"
        }
    }
    
}

protocol ZoocAlertViewControllerDelegate: AnyObject {
    func exitButtonDidTap()
}

final class ZoocAlertViewController: UIViewController {
    
    //MARK: - Properties
    
    public var alertType: AlertType? {
        didSet{
            updateUI()
        }
    }
    weak var delegate: ZoocAlertViewControllerDelegate?
    
    //MARK: - UI Components
    
    private var alertView = UIView()
    private var contentView = UIView()
    private var titleLabel = UILabel()
    private var descriptionLabel = UILabel()
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
        
        titleLabel.do {
            $0.backgroundColor = .white
            $0.font = .zoocSubhead2
            $0.textColor = .zoocDarkGray1
        }
        
        descriptionLabel.do {
            $0.font = .zoocBody1
            $0.textColor = .zoocGray1
            $0.textAlignment = .center
        }
        
        keepButton.do {
            $0.backgroundColor = .zoocMainGreen
            $0.setTitleColor(.zoocWhite1, for: .normal)
            $0.titleLabel?.textAlignment = .center
            $0.titleLabel?.font = .zoocSubhead1
        }
        
        exitButton.do {
            $0.backgroundColor = .zoocWhite3
            $0.setTitleColor(.zoocDarkGray2, for: .normal)
            $0.titleLabel?.textAlignment = .center
            $0.titleLabel?.font = .zoocSubhead1
        }
    }
    
    private func hierarchy() {
        view.addSubviews(contentView,alertView)
        alertView.addSubviews(titleLabel, descriptionLabel, keepButton, exitButton)
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
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(44)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(6)
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
    
    private func updateUI() {
        titleLabel.text = alertType?.title
        descriptionLabel.text = alertType?.description
        keepButton.setTitle(alertType?.keep, for: .normal)
        exitButton.setTitle(alertType?.exit, for: .normal)
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
