//
//  NetworkAlertView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/19.
//

import UIKit

import SnapKit

final class NetworkAlertView: UIView {
    
    private let alertView = UIView()
    private let dimmedView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private lazy var updateButton = UIButton()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        target()
        
        style()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    private func target() {
        updateButton.addTarget(self, action: #selector(updateButtonDidTap), for: .touchUpInside)
    }
    
    private func style() {
        backgroundColor = .clear
        
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
            $0.text = "네트워크가 원활하지 않습니다."
            $0.backgroundColor = .white
            $0.font = .zoocSubhead2
            $0.textColor = .zoocDarkGray1
        }
        
        descriptionLabel.do {
            $0.text = "인터넷 연결 상태를 확인해주세요."
            $0.font = .zoocBody1
            $0.textColor = .zoocGray1
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        updateButton.do {
            $0.setTitle("다시 시도", for: .normal)
            $0.setBackgroundColor(.zoocMainGreen, for: .normal)
            $0.setBackgroundColor(.zoocGradientGreen, for: .highlighted)
            $0.titleLabel?.textAlignment = .center
            $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
        }
    }
    
    private func hierarchy() {
        addSubviews(dimmedView,alertView)
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
            $0.bottom.equalToSuperview().inset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
    }
    
    //MARK: - Action Method
    
    @objc func updateButtonDidTap() {
        //startNetworkMonitoring()
        
    }
    
//    private func startNetworkMonitoring() {
//        let monitor = NWPathMonitor()
//        monitor.start(queue: DispatchQueue.main)
//        monitor.pathUpdateHandler =  { path in
//
//            switch path.status {
//
//            case .satisfied:
//                monitor.cancel()
//                self.dismiss(animated: false)
//            default:
//                break
//            }
//        }
//    }
    
    
    @objc func exitButtonDidTap() {
        
        
    }

}

extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        self.setBackgroundImage(backgroundImage, for: state)
    }
}


