//
//  ZoocUploadingImageAlertView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/19.
//

import UIKit

import SnapKit

enum CheckAlertType {
    case noApplied
    case inProgress
    
    var titleLabel: String {
        switch self {
        case .noApplied:
            return "아직 이벤트에 참여하지 않았어요"
        case .inProgress:
            return "AI 이미지 생성 중이에요"
        }
    }
    
    var description: String {
        switch self {
        case .noApplied:
            return "쇼핑몰에서 이벤트 참여가 가능해요"
        case .inProgress:
            return "최대 3일이 소요될 수 있어요\n알림으로 빠르게 알려드릴게요"
        }
    }
    
    var keep: String {
        switch self {
        case .noApplied:
            return "확인"
        case .inProgress:
            return "확인"
        }
    }
}

final class ZoocCheckAlertView: UIViewController {
    
    var checkAlertType: CheckAlertType?
    
    private let alertView = UIView()
    private let dimmedView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private lazy var updateButton = UIButton()
    
    //MARK: - Life Cycle
    
    init(_ checkAlertType: CheckAlertType) {
        self.checkAlertType = checkAlertType
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        target()
        
        style()
        hierarchy()
        layout()
    }
    
    //MARK: - Custom Method
    
    private func target() {
        updateButton.addTarget(self, action: #selector(updateButtonDidTap), for: .touchUpInside)
    }
    
    private func style() {
        view.backgroundColor = .clear
        
        alertView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 14
            $0.clipsToBounds = true
            $0.alpha = 1
        }
        
        dimmedView.do {
            $0.backgroundColor = .black
            $0.alpha = 0.55
        }
        
        titleLabel.do {
            $0.text = checkAlertType?.titleLabel
            $0.backgroundColor = .white
            $0.font = .zoocSubhead2
            $0.textColor = .zoocDarkGray1
        }
        
        descriptionLabel.do {
            $0.text = checkAlertType?.description
            $0.font = .zoocBody1
            $0.textColor = .zoocGray1
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        updateButton.do {
            $0.setTitle(checkAlertType?.keep, for: .normal)
            $0.setBackgroundColor(.zoocMainGreen, for: .normal)
            $0.setBackgroundColor(.zoocGradientGreen, for: .highlighted)
            $0.titleLabel?.textAlignment = .center
            $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        }
    }
    
    private func hierarchy() {
        self.view.addSubviews(dimmedView,alertView)
        alertView.addSubviews(titleLabel, descriptionLabel, updateButton)
    }
    
    private func layout() {
        alertView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(299)
            $0.height.equalTo(180)
        }
        
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(41)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        updateButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(54)
        }
        
    }
    
    //MARK: - Action Method
    
    @objc func updateButtonDidTap() {
        self.dismiss(animated: false)
    }
}




