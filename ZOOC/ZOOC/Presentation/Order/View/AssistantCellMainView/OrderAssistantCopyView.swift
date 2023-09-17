//
//  OrderCopyStepView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/31.
//

import UIKit

import SnapKit
import FirebaseRemoteConfig

protocol OrderAssistantCopyViewDelegate: AnyObject {
    func copyButtonDidTap(_ fullAccount: String)
}

final class OrderAssistantCopyView: UIView {
    
    //MARK: - Properties
    
    private var accountData: BankAccount = .meltsplitAccount {
        didSet {
            updateUI()
        }
    }
    
    weak var delegate: OrderAssistantCopyViewDelegate?
    
    //MARK: - UI Components
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: Image.bankKaKaoBank)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let accountLabel: UILabel = {
        let label = UILabel()
        label.font = .zoocBody1
        label.textColor = .zoocDarkGray1
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var copyButton: ZoocGradientButton = {
        let button = ZoocGradientButton(.medium)
        button.setTitle("복사하기", for: .normal)
        button.addTarget(self,
                         action: #selector(copyButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - Life Cycle
    
    init() {
        super.init(frame: .zero)
        
        style()
        hierarchy()
        layout()
        updateUI()
        getBankAccount()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.makeCornerRound(ratio: 4)
        copyButton.makeCornerRound(radius: 10)
    }
    
    //MARK: - UI & Layout
    
    private func style() {
        backgroundColor = .zoocWhite1
    }
    
    private func hierarchy() {
        addSubviews(imageView,
                    accountLabel,
                    copyButton)
    }
    
    private func layout() {
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(24)
            $0.size.equalTo(40)
        }
        
        accountLabel.snp.makeConstraints {
            $0.centerY.equalTo(imageView)
            $0.leading.equalTo(imageView.snp.trailing).offset(14)
        }
        
        copyButton.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.accountLabel.text = """
                            \(self.accountData.bank) | 예금주: \(self.accountData.holder)
                            계좌번호: \(self.accountData.accountNumberWithHyphen)
                            """
        }
    }
    
    private func getBankAccount() {
        
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings =  RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        remoteConfig.fetch() { [weak self] status, error in
            
            if status == .success {
                remoteConfig.activate() { [weak self] changed, error in
                    guard let holder = remoteConfig["accountHolder"].stringValue,
                          let bank = remoteConfig["accountBank"].stringValue,
                          let accountNumber = remoteConfig["accountNumber"].stringValue,
                          let accountNumberWithHyphen = remoteConfig["accountNumberWithHyphen"].stringValue else {
                        return
                    }
                    
                    self?.accountData = BankAccount(holder: holder,
                                              bank: bank,
                                              accountNumber: accountNumber,
                                              accountNumberWithHyphen: accountNumberWithHyphen)
                }
            } else {
                return
            }
        }
    }

    
    //MARK: - Action Method

    @objc
    private func copyButtonDidTap() {
        delegate?.copyButtonDidTap(accountData.fullAccount)
    }
    
    
    
}
