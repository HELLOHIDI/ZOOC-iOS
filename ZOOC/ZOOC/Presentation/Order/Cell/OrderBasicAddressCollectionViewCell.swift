//
//  OrderBasicAddressCollectionViewCell.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/04.
//

import UIKit

import SnapKit

final class OrderBasicAddressCollectionViewCell: UICollectionViewCell {
    
    private lazy var basicAddressCheckButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let basicAddress: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let phoneNumLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let requestLabel: UILabel = {
        let label = UILabel()
        label.text = "요청사항"
        label.font = .zoocBody2
        label.textColor = .zoocGray2
        return label
    }()
    
    private let requestTextField: ZoocTextField = {
        let textField = ZoocTextField(.numberPad)
        textField.placeholder = "부재 시 경비실에 맡겨주세요"
        textField.font = .zoocBody1
        textField.setPlaceholderColor(color: .zoocGray1)
        return textField
    }()
}
