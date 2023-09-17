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
    func basicAddressButtonDidTap(_ height: CGFloat)
    func newAddressButtonDidTap(_ height: CGFloat)
}

final class OrderAddressView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: OrderAddressViewDelegate?
    private var basicAddressDatas: Results<OrderBasicAddress>?
    
    var addressType: AddressType = .new {
        didSet {
            updateViewHidden()
            updateTintBar()
            
        }
    }
    
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
    
    private lazy var basicAddressButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.zoocGray1, for: .normal)
        button.setTitleColor(.zoocMainGreen, for: .selected)
        button.setTitle("기존 배송지", for: .normal)
        button.titleLabel?.font = .zoocFont(font: .semiBold, size: 16)
        button.addTarget(self,
                         action: #selector(basicAddressButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var newAddressButton: UIButton = {
        let button = UIButton()
        button.setTitle("신규 입력", for: .normal)
        button.setTitleColor(.zoocGray1, for: .normal)
        button.setTitleColor(.zoocMainGreen, for: .selected)
        button.titleLabel?.font = .zoocFont(font: .semiBold, size: 16)
        button.addTarget(self,
                         action: #selector(newAddressButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private let tintBar: UIView = {
        let view = UIView()
        view.backgroundColor = .zoocMainGreen
        return view
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tintBar.makeCornerRound(ratio: 2)
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
        
        buttonView.addSubviews(basicAddressButton, newAddressButton, tintBar)
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
            $0.top.equalTo(headerView.snp.bottom)
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
        }
        
        newAddressButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(basicAddressButton.snp.trailing).offset(16)
        }
        
        basicAddressView.snp.makeConstraints {
            $0.top.equalTo(buttonView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        newAddressView.snp.makeConstraints {
            $0.top.equalTo(buttonView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        tintBar.snp.makeConstraints {
            $0.top.equalTo(newAddressButton.snp.bottom)
            $0.centerX.equalTo(newAddressButton)
            $0.width.equalTo(50)
            $0.height.equalTo(2)
        }
    }
    
    //MARK: - Public Methods
    
    func dataBind(_ basicAddressData: Results<OrderBasicAddress>) {
        self.basicAddressDatas = basicAddressData
        basicAddressView.dataBind(basicAddressDatas)
        
        addressType = basicAddressData.isEmpty ? .new : .registed
        
        if addressType == .registed {
            basicAddressView.layoutIfNeeded()
            basicAddressButtonDidTap()
        } else {
            newAddressView.layoutIfNeeded()
            newAddressButtonDidTap()
        }
    }
    
    func updateUI(newAddressData: OrderAddress) {
        newAddressView.updateUI(newAddressData)
    }
    
    
    func checkValidity() throws {
        if !newAddressView.isHidden {
            try newAddressView.checkValidity()
        }
    }
    
    private func updateViewHidden() {
        basicAddressButton.isSelected = addressType == .registed
        basicAddressView.isHidden = addressType != .registed
        
        newAddressButton.isSelected = addressType == .new
        copyButton.isHidden = addressType != .new
        newAddressView.isHidden = addressType != .new
        
    }
    
    private func updateTintBar() {
        switch addressType {
        case .registed:
            tintBar.snp.remakeConstraints {
                $0.top.equalTo(basicAddressButton.snp.bottom)
                $0.centerX.equalTo(basicAddressButton)
                $0.width.equalTo(70)
                $0.height.equalTo(2)
            }
            
        case .new:
            tintBar.snp.remakeConstraints {
                $0.top.equalTo(newAddressButton.snp.bottom)
                $0.centerX.equalTo(newAddressButton)
                $0.width.equalTo(50)
                $0.height.equalTo(2)
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    //MARK: - Action Method
    
    @objc
    private func copyButtonDidTap() {
        delegate?.copyButtonDidTap()
    }
    
    @objc
    private func basicAddressButtonDidTap() {
        
        delegate?.basicAddressButtonDidTap(headerView.frame.height +
                                           buttonView.frame.height + basicAddressView.basicAddressCollectionView.contentSize.height)
        
        guard !(basicAddressDatas?.isEmpty ?? false) else {
            return
        }
        addressType = .registed
    }
    
    @objc
    private func newAddressButtonDidTap() {
        addressType = .new
        delegate?.newAddressButtonDidTap(498)
    }
}
