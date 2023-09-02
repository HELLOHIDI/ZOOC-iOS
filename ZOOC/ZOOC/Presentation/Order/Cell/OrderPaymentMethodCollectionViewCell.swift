//
//  PaymenyMethodCollectionViewCell.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/25.
//

import UIKit

final class OrderPaymentMethodCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    
    enum PaymentType {
        case withoutBankBook
        case kakaoPay
        case toss
        case mobile
        
        var image: UIImage? {
            
            switch self {
            case .withoutBankBook:
                return UIImage(systemName: "dollarsign.circle")
            default:
                return UIImage(systemName: "dollarsign.circle")
            }
        }
        
        var text: String {
            switch self {
            case .withoutBankBook:
                return "무통장 입금"
            default:
                return "아직 개발 전"
            }
        }
    }
    
    private var type: PaymentType = .withoutBankBook  {
        didSet {
            updateUI()
        }
    }
    
    //MARK: - UI Components
    
    private let paymentTypeButton: ZoocGradientButton = {
        let button = ZoocGradientButton.init(.order)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)!
        return button
    }()
    
//    private let checkButton: UIButton = {
//        let button = UIButton()
//        button.setBackgroundColor(.white, for: .normal)
//        button.setBackgroundColor(.zoocMainGreen, for: .selected)
//        button.setBorder(borderWidth: 1, borderColor: .zoocLightGray)
//        button.isSelected = true
//        return button
//    }()
//
//    private let smallCircleView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        return view
//    }()
//
//    private let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.tintColor = .zoocDarkGray1
//        return imageView
//    }()
//
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = .zoocBody3
//        label.textColor = .zoocDarkGray1
//        return label
//    }()
    
    
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        paymentTypeButton.makeCornerRound(ratio: 8)
//        checkButton.makeCornerRound(ratio: 2)
//        smallCircleView.makeCornerRound(ratio: 2)
    }
    
    //MARK: - Custom Method
    
    private func style() {
 
    }
    
    private func hierarchy() {
        contentView.addSubview(paymentTypeButton)
//        contentView.addSubviews(checkButton, imageView, titleLabel)
//        checkButton.addSubview(smallCircleView)
    }
    
    private func layout() {
        paymentTypeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.top.equalToSuperview()
            $0.width.equalTo(122)
            $0.height.equalTo(41)
        }
//        checkButton.snp.makeConstraints {
//            $0.leading.equalToSuperview().inset(20)
//            $0.size.equalTo(25)
//            $0.centerY.equalToSuperview()
//        }
//
//        smallCircleView.snp.makeConstraints {
//            $0.edges.equalToSuperview().inset(7)
//        }
//
//        imageView.snp.makeConstraints {
//            $0.leading.equalTo(checkButton.snp.trailing).offset(5)
//            $0.centerY.equalToSuperview()
//            $0.height.equalTo(25)
//            $0.width.equalTo(40)
//        }
//
//        titleLabel.snp.makeConstraints {
//            $0.leading.equalTo(imageView.snp.trailing)
//            $0.centerY.equalToSuperview()
//        }
        
    }
    
    func dataBind(_ type: PaymentType) {
        self.type = type
    }
    
    private func updateUI() {
//        imageView.image = type.image
//        titleLabel.text = type.text
        paymentTypeButton.setTitle(type.text, for: .normal)
        
    }
    
    
}

