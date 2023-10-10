//
//  OrderBasicAddressCollectionViewCell.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/04.
//

import UIKit

import SnapKit

protocol OrderBasicAddressCollectionViewCellDelegate: AnyObject {
    func requestTextFieldDidChange(_ object: OrderBasicAddress, request: String)
}

final class OrderBasicAddressCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private var data: OrderBasicAddress? {
        didSet {
            guard let data else { return }
            updateUI(data)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateUI(isSelected)
        }
    }
    
    weak var delegate: OrderBasicAddressCollectionViewCellDelegate?
    
    //MARK: - UI Components
    
    private let checkButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.setBorder(borderWidth: 1, borderColor: .zoocDarkGreen)
        return view
    }()
    
    private let miniCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
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
    
    lazy var requestTextField: ZoocTextField = {
        let textField = ZoocTextField()
        textField.placeholder = "부재 시 경비실에 맡겨주세요"
        textField.font = .zoocBody1
        textField.textColor = .zoocGray3
        textField.setPlaceholderColor(color: .zoocGray1)
        textField.isHidden = true
        textField.addTarget(self,
                            action: #selector(textFieldDidEndEditing(_:)),
                            for: .editingDidEnd)
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
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        checkButtonView.makeCornerRound(ratio: 2)
        miniCircleView.makeCornerRound(ratio: 2)
    }
    
    //MARK: - Custom Method
    
    private func style() {
        contentView.backgroundColor = .zoocBackgroundGreen
        contentView.makeCornerRound(radius: 16)
    }
    
    private func hierarchy() {
        contentView.addSubviews(checkButtonView,
                                nameLabel,
                                basicAddressLabel,
                                phoneNumLabel,
                                requestLabel,
                                requestTextField)
        
        checkButtonView.addSubview(miniCircleView)
        
    }
    
    private func layout() {
        checkButtonView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.size.equalTo(20)
        }
        
        miniCircleView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalTo(checkButtonView.snp.trailing).offset(12)
        }
        
        basicAddressLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(12)
            $0.leading.equalTo(nameLabel)
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
    private func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        guard let data else { return }
        
        delegate?.requestTextFieldDidChange(data, request: text)
        
    }
    
    
    private func updateUI(_ isSelected: Bool) {
        requestLabel.isHidden = !isSelected
        requestTextField.isHidden = !isSelected
        
        let checkButtonBorderColor: UIColor = isSelected ? .clear : .zoocDarkGreen
        let contentViewBorderColor: UIColor = isSelected ? .zoocMainGreen : .zoocBackgroundGreen
        
        checkButtonView.setBorder(borderWidth: 1, borderColor: checkButtonBorderColor)
        contentView.setBorder(borderWidth: 1, borderColor: contentViewBorderColor)
        
        checkButtonView.backgroundColor = isSelected ? .zoocMainGreen : .clear
        miniCircleView.backgroundColor = isSelected ? .zoocWhite3 : .clear
        contentView.backgroundColor = isSelected ? UIColor(r: 222, g: 239, b: 227) : .zoocBackgroundGreen
    }
    
    private func updateUI(_ data: OrderBasicAddress) {
        self.isSelected = data.isSelected
        nameLabel.text = data.name
        basicAddressLabel.text = "\(data.address) \n\(data.detailAddress ?? "")"
        phoneNumLabel.text = data.phoneNumber
        requestTextField.text = data.request
    }
    
    //MARK: - Public Methods
    
    
    func dataBind(_ data: OrderBasicAddress) {
        self.data = data
    }
}
