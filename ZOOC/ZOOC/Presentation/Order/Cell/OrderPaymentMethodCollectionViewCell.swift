//
//  PaymenyMethodCollectionViewCell.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/25.
//

import UIKit

import UIKit

final class OrderPaymentMethodCollectionViewCell: UICollectionViewCell {

    //MARK: - Properties
    



    private var type: PaymentType = .withoutBankBook  {
        didSet {
            updateUI(type)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateUI(isSelected)
        }
    }

    //MARK: - UI Components
    
    private let checkButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.setBorder(borderWidth: 1, borderColor: .zoocDarkGray1)
        return view
    }()
    
    private let miniCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .zoocDarkGray1
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zoocBody3
        label.textColor = .zoocGray2
        return label
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

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        checkButtonView.makeCornerRound(ratio: 2)
        miniCircleView.makeCornerRound(ratio: 2)
    }

    //MARK: - Custom Method
    
    private func style() {

    }

    private func hierarchy() {
        contentView.addSubviews(checkButtonView, imageView, titleLabel)
        checkButtonView.addSubview(miniCircleView)
    }

    private func layout() {

        checkButtonView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        miniCircleView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(checkButtonView.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }

    }

    func dataBind(_ type: PaymentType) {
        self.type = type
    }

    private func updateUI(_ type: PaymentType) {
        imageView.image = type.image
        titleLabel.text = type.text
    }
    
    private func updateUI(_ isSelected: Bool) {
        let borderColor: UIColor = isSelected ? .clear : .zoocDarkGreen
        
        checkButtonView.setBorder(borderWidth: 1, borderColor: borderColor)
        checkButtonView.backgroundColor = isSelected ? .zoocMainGreen : .clear
        miniCircleView.backgroundColor = isSelected ? .zoocWhite3 : .clear
        
        
    }


}
