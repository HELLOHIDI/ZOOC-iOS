//
//  ShopView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/30.
//

import UIKit

import SnapKit

final class ShopView: UIView {
    
    //MARK: - UI Components
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.back, for: .normal)
        //        button.isHidden = true //MARK: Shopping몰 <-> 마이페이지 위치 바뀌며 삭제된 버튼 (23.10.05)
        return button
    }()
    
    //    let shopPetView: UIView = {
    //        let view = UIView()
    //        view.backgroundColor = .zoocWhite1
    //        return view
    //    }()
    
    let petImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let petNameLabel: UILabel = {
        let label = UILabel()
        label.font = .zoocBody1
        label.textColor = .zoocGray3
        return label
    }()
    
    let marketLabel: UILabel = {
        let label = UILabel()
        label.text = "Market"
        label.font = .zoocHeadLine
        label.textColor = .zoocMainGreen
        return label
    }()
    
    let downArrowImageView = UIImageView(image: Image.arrowDropDown)
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView(image: Image.logoCombination)
        imageView.contentMode = .scaleAspectFit
//        imageView.isHidden = true // 펫 섹션 추가되면서 잠시 숨길게
        return imageView
    }()
    
    let orderHistoryButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "doc.fill"), for: .normal)
        button.tintColor = .zoocGray2
        return button
    }()
    
    let cartButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.cart, for: .normal)
        return button
    }()
    
    let shopCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 9
        var width = (Device.width - 60 - 9) / 2
        let height = (width * 200 / 153) + 50
        layout.itemSize = CGSize(width: width, height: height)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = .init(top: 10, left: 30, bottom: 0, right: 30)
        collectionView.register(ShopProductCollectionViewCell.self,
                                forCellWithReuseIdentifier: ShopProductCollectionViewCell.reuseCellIdentifier)
        return collectionView
    }()
    
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        hierarchy()
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //shopPetView.makeCornerRound(ratio: 2)
        //petImageView.makeCornerRound(ratio: 2)
    }
    
    //MARK: - UI & Layout
    
    private func hierarchy() {
        
        addSubviews(backButton,
                    orderHistoryButton,
                    cartButton,
                    logoImageView,
                    shopCollectionView,
                    logoImageView)
        
        //        shopPetView.addSubviews(petImageView,
        //                                petNameLabel,
        //                                marketLabel,
        //                                downArrowImageView)
    }
    
    private func layout() {
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(11)
            $0.leading.equalToSuperview().inset(17)
            $0.size.equalTo(42)
        }
        
//        shopPetView.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.centerY.equalTo(cartButton)
//            $0.height.equalTo(40)
//            $0.width.equalTo(190)
//        }
        
        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton)
            $0.height.equalTo(30)
        }
        
        orderHistoryButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(11)
            $0.trailing.equalTo(cartButton.snp.leading)
            $0.size.equalTo(36)
        }
        
        cartButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(11)
            $0.trailing.equalToSuperview().inset(21)
            $0.size.equalTo(36)
        }
        
        shopCollectionView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        // ShopPetView
        
        //        petNameLabel.snp.makeConstraints {
        //            $0.centerY.equalToSuperview()
        //            $0.leading.equalTo(petImageView.snp.trailing).offset(8)
        //            $0.trailing.equalToSuperview()
        //        }
        //
        //        marketLabel.snp.makeConstraints {
        //            $0.centerY.equalToSuperview()
        //            $0.trailing.equalTo(downArrowImageView.snp.leading)
        //        }
        //
        //        downArrowImageView.snp.makeConstraints {
        //            $0.centerY.equalToSuperview()
        //            $0.trailing.equalToSuperview()
        //            $0.size.equalTo(30)
        //        }
        
    }
    
    func updateSelectedPetViewUI(_ data: PetAiModel) {
        self.petImageView.kfSetImage(url: data.photo, defaultImage: Image.defaultProfile)
        self.petNameLabel.text = data.name
        self.marketLabel.text = "Market"
        
    }
    
    func updateNotSelectedPetUI(){
        self.petImageView.image = Image.defaultProfile
        self.petNameLabel.text = nil
        self.marketLabel.text = "ZOOC Market"
    }
    
}
