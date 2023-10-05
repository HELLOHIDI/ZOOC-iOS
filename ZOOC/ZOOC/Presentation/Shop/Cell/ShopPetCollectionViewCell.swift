//
//  ShopPetCollectionViewCell.swift
//  ZOOC
//
//  Created by 장석우 on 2023/10/06.
//

import UIKit

import SnapKit
import Then

final class ShopPetCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            checkContainerView.isHidden = !isSelected
        }
    }
    
    //MARK: - UI Components
    
    private let petImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let petNameLabel: UILabel = {
        let label = UILabel()
        label.font = .zoocBody1
        label.textColor = .zoocGray3
        return label
    }()
    
    private let checkContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .zoocWhite1
        view.isHidden = true
        return view
    }()
    
    private let checkImageView: UIImageView = {
        let imageView = UIImageView(image: Image.checkTint)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nextImageView: UIImageView = {
        let imageView = UIImageView(image: Image.next)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let makeModelLabel: UILabel = {
        let label = UILabel()
        label.text = "모델 만들기"
        label.font = .zoocCaption
        label.textColor = .zoocGray3
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
        petImageView.makeCornerRound(ratio: 2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        checkContainerView.isHidden = true
    }
    
    
    //MARK: - Custom Method
    
    
    private func style() {
        contentView.backgroundColor = .zoocWhite1
    }
    
    private func hierarchy() {
        contentView.addSubviews(petImageView,
                                petNameLabel,
                                makeModelLabel,
                                nextImageView,
                                checkContainerView)
        
        checkContainerView.addSubview(checkImageView)
    }
    
    private func layout() {
        petImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(3)
            $0.size.equalTo(34)
        }
        
        petNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(petImageView.snp.trailing).offset(8)
        }
        
        makeModelLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(nextImageView.snp.leading).offset(-5)
        }
        
        nextImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(15)
            $0.size.equalTo(14)
        }
        
        checkContainerView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(petNameLabel.snp.trailing)
        }
        
        checkImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
            $0.size.equalTo(25)
        }
        
    }
    
    public func dataBind(_ data: PetAiResult) {
        self.petImageView.kfSetImage(url: data.photo, defaultImage: Image.defaultProfile)
        self.petNameLabel.text = data.name
        self.makeModelLabel.isHidden = data.state != .notStarted
        self.nextImageView.isHidden = data.state != .notStarted
    }
    
    //MARK: - Action Method
    
}
