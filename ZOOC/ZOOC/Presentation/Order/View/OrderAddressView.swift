//
//  AddressView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/24.
//

import UIKit

import SnapKit
import RealmSwift

protocol OrderAddressViewDelegate: AnyObject {
    func copyButtonDidTap()
}

final class OrderAddressView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: OrderAddressViewDelegate?
    
    //MARK: - UI Components
    
    private let headerView = UIView()
    private let mainView = UIView()
    private let buttonView = UIView()
    let basicAddressView = OrderBasicAddressView()
    let newAddressView = OrderNewAddressView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "배송 정보"
        label.font = .zoocSubhead2
        label.textColor = .zoocDarkGray1
        label.textAlignment = .left
        return label
    }()
    
    private lazy var copyButton: UIButton = {
        let button = UIButton()
        button.setTitle("구매자와 동일해요", for: .normal)
        button.setUnderline()
        button.setTitleColor(.zoocGray1, for: .normal)
        button.titleLabel?.font = .zoocBody2
        button.addTarget(self,
                         action: #selector(copyButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var basicAddressButton: ZoocGradientButton = {
        let button = ZoocGradientButton.init(.order)
        button.setTitle("기존 배송지", for: .normal)
        button.addTarget(self, action: #selector(basicAddressButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    lazy var newAddressButton: ZoocGradientButton = {
        let button = ZoocGradientButton.init(.order)
        button.setTitle("신규 입력", for: .normal)
        button.addTarget(self, action: #selector(newAddressButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Life Cycle
    
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
        backgroundColor = .zoocBackgroundGreen
    }
    
    private func hierarchy() {
        headerView.addSubviews(titleLabel, copyButton)
        
        addSubviews(headerView, mainView)
        
        mainView.addSubviews(buttonView,
                             basicAddressView,
                             newAddressView)
        
        buttonView.addSubviews(basicAddressButton, newAddressButton)
    }
    
    private func layout() {
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(75)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.centerY.equalToSuperview()
        }
        
        copyButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(30)
        }
        
        mainView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        buttonView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(54)
        }
        
        basicAddressButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.width.equalTo(152)
            $0.height.equalTo(54)
        }
        
        newAddressButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(30)
            $0.width.equalTo(152)
            $0.height.equalTo(54)
        }
        
        basicAddressView.snp.makeConstraints {
            $0.top.equalTo(buttonView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        newAddressView.snp.makeConstraints {
            $0.top.equalTo(buttonView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Public Methods
    
    func updateUI(newAddressData: OrderAddress,
                  basicAddressDatas: Results<OrderBasicAddress>? = nil,
                  isPostData: Bool = false) {
        basicAddressView.updateUI(basicAddressDatas)
        newAddressView.updateUI(newAddressData)
        
        guard let basicAddressDatas = basicAddressDatas else { return }
        if !basicAddressDatas.isEmpty {
            updateViewAppear(true)
            basicAddressButton.updateButtonUI(true)
            newAddressButton.updateButtonUI(false)
        } else {
            updateViewAppear(false)
            basicAddressButton.updateButtonUI(false)
            newAddressButton.updateButtonUI(true)
        }
    }
    
    func updateViewAppear(_ hasBasicAddress: Bool) {
        basicAddressView.isHidden = !hasBasicAddress
        newAddressView.isHidden = hasBasicAddress
        copyButton.isHidden = hasBasicAddress
    }
    
    func checkValidity() throws {
        if newAddressButton.isSelected {
            try newAddressView.checkValidity()
        }
    }
    
    //MARK: - Action Method
    
    @objc
    private func copyButtonDidTap() {
        delegate?.copyButtonDidTap()
    }
    
    @objc
    private func basicAddressButtonDidTap() {
        copyButton.isHidden = true
        basicAddressView.isHidden = false
        newAddressView.isHidden = true
        basicAddressButton.updateButtonUI(true)
        newAddressButton.updateButtonUI(false)
    }
    
    @objc
    private func newAddressButtonDidTap() {
        copyButton.isHidden = false
        basicAddressView.isHidden = true
        newAddressView.isHidden = false
        basicAddressButton.updateButtonUI(false)
        newAddressButton.updateButtonUI(true)
    }
}
