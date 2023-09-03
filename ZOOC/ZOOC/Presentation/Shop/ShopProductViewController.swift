//
//  ShopProductViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/02.
//

import UIKit

import SnapKit
import Then
import FloatingPanel

final class ShopProductViewController: BaseViewController {
    
    //MARK: - Properties
    
    //private var productModel: ProductModel
    
    private var productData: ProductDetailResult? {
        didSet{
            updateUI()
        }
    }
    
    
    //MARK: - UI Components
    
    private let productBottomSheet = ProductBottomSheet()
    private lazy var productBottomSheetVC = BottomSheetViewController(isTouchPassable: false,
                                                               contentViewController: productBottomSheet)
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let backButton = UIButton()
    
    private let productImageView = UIImageView()
    
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let lineView = UIView()
    
    private let buyView = UIView()
    private let buyButton = ZoocGradientButton(.medium)
    
    //MARK: - Life Cycle
    
    init(productID: Int){
        super.init(nibName: nil, bundle: nil)
        
        requestDetailProductAPI(id: productID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        gesture()
        
        style()
        hierarchy()
        layout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buyView.layoutIfNeeded()
    }

    //MARK: - Custom Method

    
    private func setDelegate() {
        productBottomSheet.delegate = self
    }
    
    private func gesture() {
        backButton.addTarget(self,
                             action: #selector(backButtonDidTap),
                             for: .touchUpInside)
        
    }
    
    private func style() {
        
        scrollView.do {
            $0.bounces = false
            $0.showsVerticalScrollIndicator = false
        }
        
        backButton.do {
            $0.setImage(Image.back, for: .normal)
            $0.tintColor = .zoocDarkGray1
        }
        
        productImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.isUserInteractionEnabled = true
        }
        
        nameLabel.do {
            $0.font = .zoocBody1
            $0.textColor = .zoocGray2
        }
        
        priceLabel.do {
            $0.font = .zoocBody1
            $0.textColor = .zoocGray2
        }
        
        descriptionLabel.do {
            $0.font = .zoocBody3
            $0.textColor = .zoocDarkGray2
        }
        
        lineView.do {
            $0.backgroundColor = .zoocLightGray
        }
        
        buyButton.do {
            $0.setTitle("구매하기", for: .normal)
            $0.addTarget(self,
                         action: #selector(buyButtonDidTap),
                         for: .touchUpInside)
        }
        
    }
    
    private func hierarchy() {
        
        view.addSubviews(backButton,
                         scrollView,
                         buyView)
        
        scrollView.addSubview(contentView)
        
        
        contentView.addSubviews(productImageView,
                                nameLabel,
                                priceLabel,
                                descriptionLabel,
                                lineView)
        
        buyView.addSubviews(buyButton)
    }
    
    private func layout() {
  
        //MARK: view Layout
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(11)
            $0.leading.equalToSuperview().offset(17)
            $0.size.equalTo(42)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        buyView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(19)
            $0.height.equalTo(77)
        }
        
        //MARK: scrollView Layout
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(scrollView.frameLayoutGuide).priority(.low)
        }
        
        //MARK: contentView Layout
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(53)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(42)
        }
        
        productImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            //$0.height.equalTo(productImageView.snp.width).multipliedBy(212).dividedBy(375)
            $0.height.equalTo(212)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(22)
            $0.leading.equalToSuperview().offset(30)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().offset(-30)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview().inset(500)
        }
        
        buyButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(47)
        }
    }
    
    private func updateUI() {
        productImageView.kfSetImage(url: productData?.images.first)
        priceLabel.text = productData?.price.priceText
        nameLabel.text = productData?.name
        descriptionLabel.text = productData?.type
    }
    
    private func requestDetailProductAPI(id: Int) {
        ShopAPI.shared.getProduct(productID: id) { result in
            guard let result = self.validateResult(result) as? ProductDetailResult else { return }
            self.productData = result
        }
    }
    
    //MARK: - API Method
    
    
    //MARK: - Action Method
    
    @objc
    private func buyButtonDidTap() {
        present(productBottomSheetVC, animated: true)
    }
    
    @objc
    private func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
}

extension ShopProductViewController: ProductBottomSheetDelegate {
    func cartButtonDidTap(selectedOptions: [ProductSelectedOption]) {
        presentBottomAlert("장바구니 기능 구현해야함!!!")
    }
    
    func orderButtonDidTap(selectedOptions: [ProductSelectedOption]) {
        
        //TODO: - Data 부분 뜯어고쳐야함!!!!!
        let productData = OrderProduct(id: selectedOptions[0].id,
                                       imageURL: "https://zooc-bucket.s3.ap-northeast-2.amazonaws.com/images%2F1691081953053_image.jpeg",
                                       name: selectedOptions[0].option,
                                       price: selectedOptions[0].totalPrice)
        
        let priceData = OrderPrice(productPrice: selectedOptions[0].totalPrice,
                                   deleiveryFee: 4000)
        
        let orderVC = OrderViewController(productData: productData,
                                          priceData: priceData)
        navigationController?.pushViewController(orderVC, animated: true)
    }
    
    
}
