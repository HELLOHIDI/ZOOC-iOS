//
//  ZoocUploadingImageAlertView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/19.
//

import UIKit

import SnapKit

final class ZoocUploadingImageAlertView: UIViewController {
    
    private let alertView = UIView()
    private let dimmedView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private lazy var updateButton = UIButton()
    
    //MARK: - Life Cycle
    
    init() {
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
            $0.text = "AI 이미지를 생성하고 있어요"
            $0.backgroundColor = .white
            $0.font = .zoocSubhead2
            $0.textColor = .zoocDarkGray1
        }
        
        descriptionLabel.do {
            $0.text = "30초 정도만 더 기다려주세요"
            $0.font = .zoocBody1
            $0.textColor = .zoocGray1
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        updateButton.do {
            $0.setTitle("확인", for: .normal)
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




