//
//  OrderBasicAddressCollectionViewCell.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/04.
//

import UIKit

import SnapKit

protocol OrderBasicAddressCollectionViewCellDelegate: AnyObject {
    func basicAddressCheckButtonDidTap(tag: Int)
}

final class OrderBasicAddressCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    weak var delegate: OrderBasicAddressCollectionViewCellDelegate?
    
    //MARK: - UI Components
    
    private lazy var basicAddressCheckButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.checkBox, for: .normal)
        button.setImage(Image.checkBoxFill, for: .selected)
        button.setImage(Image.checkBoxRed, for: .highlighted)
        button.addTarget(self, action: #selector(checkButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Medium", size: 18)!
        label.textColor = .zoocGray3
        return label
    }()
    
    private let basicAddressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .zoocGray3
        label.setLineSpacing(spacing: 6)
        label.font = UIFont(name: "Pretendard-Regular", size: 16)!
        label.numberOfLines = 2
        return label
    }()
    
    private let phoneNumLabel: UILabel = {
        let label = UILabel()
        label.textColor = .zoocGray3
        label.font = UIFont(name: "Pretendard-Regular", size: 16)!
        return label
    }()
    
    private let requestLabel: UILabel = {
        let label = UILabel()
        label.text = "요청사항"
        label.font = .zoocBody1
        label.textAlignment = .left
        label.textColor = .zoocGray2
        label.isHidden = true
        return label
    }()
    
    private let requestTextField: ZoocTextField = {
        let textField = ZoocTextField(.numberPad)
        textField.placeholder = "부재 시 경비실에 맡겨주세요"
        textField.font = .zoocBody1
        textField.textColor = .zoocGray3
        textField.setPlaceholderColor(color: .zoocGray1)
        textField.isHidden = true
        return textField
    }()
    
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
        contentView.backgroundColor = .zoocBackgroundGreen
    }
    
    private func hierarchy() {
        contentView.addSubviews(basicAddressCheckButton,
                                nameLabel,
                                basicAddressLabel,
                                phoneNumLabel,
                                requestLabel,
                                requestTextField)
        
    }
    
    private func layout() {
        basicAddressCheckButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.size.equalTo(20)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(basicAddressCheckButton.snp.trailing).offset(12)
        }
        
        basicAddressLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(62)
        }
        
        phoneNumLabel.snp.makeConstraints {
            $0.top.equalTo(basicAddressLabel.snp.bottom).offset(8)
            $0.leading.equalTo(basicAddressLabel)
        }
        
        requestLabel.snp.makeConstraints {
            $0.top.equalTo(phoneNumLabel.snp.bottom).offset(12)
            $0.leading.equalTo(phoneNumLabel)
        }
        
        requestTextField.snp.makeConstraints {
            $0.top.equalTo(requestLabel.snp.bottom).offset(6)
            $0.leading.equalTo(requestLabel)
            $0.width.equalTo(248)
            $0.height.equalTo(41)
        }
    }
    
    @objc
    private func checkButtonDidTap(_ sender: UIButton) {
        delegate?.basicAddressCheckButtonDidTap(tag: sender.tag)
    }
    
    //MARK: - Public Methods
    
    func dataBind(tag: Int, _ data: OrderBasicAddress) {
        nameLabel.text = data.name
        basicAddressLabel.text = "\(data.address) \n\(data.detailAddress ?? "")"
        phoneNumLabel.text = data.phoneNumber
        basicAddressCheckButton.tag = tag
        basicAddressCheckButton.isSelected = data.isSelected
        requestLabel.isHidden = !data.isSelected
        requestTextField.isHidden = !data.isSelected
    }
}
