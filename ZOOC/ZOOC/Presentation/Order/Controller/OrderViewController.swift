//
//  OrderViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/24.
//

import UIKit

import SnapKit
import Then

final class OrderViewController: BaseViewController {
    
    //MARK: - Properties
    
    private var ordererData = OrderOrderer()
    private var addressData = OrderAddress()
    private let productData: OrderProduct
    private let priceData: OrderPrice
    
    //MARK: - UI Components
    
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let ordererView = OrdererView()
    private let addressView = OrderAddressView()
    private let productView = OrderProductView()
    private let paymentMethodView = OrderPaymentMethodView()
    private let priceView = OrderPriceView()
    private let agreementView = OrderAgreementView()
    
    private let orderButton = ZoocGradientButton()
    
    //MARK: - Life Cycle
    
    init(productData: OrderProduct, priceData: OrderPrice) {
        self.productData = productData
        self.priceData = priceData
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        hierarchy()
        layout()
        setDelegate()
        updateUI()
        dismissKeyboardWhenTappedAround()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    
    private func style() {
        view.backgroundColor = .zoocBackgroundGreen
        
        backButton.do {
            $0.setImage(Image.back, for: .normal)
            $0.addTarget(self,
                         action: #selector(backButtonDidTap),
                         for: .touchUpInside)
        }
        
        scrollView.do {
            $0.backgroundColor = .zoocBackgroundGreen
            $0.alwaysBounceVertical = true
            $0.showsVerticalScrollIndicator = false
        }
        
        contentView.do {
            $0.backgroundColor = .zoocLightGray
        }
        
        orderButton.do {
            $0.setTitle("주문하기", for: .normal)
        }
        
        
    }
    
    private func hierarchy() {
        view.addSubviews(backButton, titleLabel, scrollView, orderButton)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(ordererView,
                                addressView,
                                productView,
                                paymentMethodView,
                                priceView,
                                agreementView)
    }
    
    private func layout() {
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(53)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(42)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.centerX.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(orderButton.snp.top).offset(-5)
        }
        
        orderButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(54)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(scrollView.frameLayoutGuide).priority(.low)
        }
        
        ordererView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.horizontalEdges.equalToSuperview()
        }
        
        addressView.snp.makeConstraints {
            $0.top.equalTo(ordererView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
        }
        
        productView.snp.makeConstraints {
            $0.top.equalTo(addressView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
        }
        
        paymentMethodView.snp.makeConstraints {
            $0.top.equalTo(productView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
        }
        
        priceView.snp.makeConstraints {
            $0.top.equalTo(paymentMethodView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            
        }
        
        agreementView.snp.makeConstraints {
            $0.top.equalTo(priceView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    
    private func setDelegate(){
        ordererView.delegate = self
        addressView.delegate = self
    }
    
    private func updateUI() {
        ordererView.updateUI(ordererData)
        addressView.updateUI(addressData)
        productView.updateUI(productData)
        priceView.updateUI(priceData)
    }
    
    //MARK: - Action Method
    
    @objc
    private func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
}



extension OrderViewController: OrdererViewDelegate {
    func textFieldDidEndEditing(name: String?, phoneNumber: String?) {
        ordererData.name = name ?? ""
        ordererData.phoneNumber = phoneNumber ?? ""
    }
    
}

extension OrderViewController: OrderAddressViewDelegate {
    
    func copyButtonDidTap() {
        ordererView.endEditing(true)
        addressData.receiverName = ordererData.name
        addressData.receiverPhoneNumber = ordererData.phoneNumber
        
        addressView.updateUI(addressData)
    }
    
    func findAddressButtonDidTap() {
        let kakaoPostCodeVC = KakaoPostCodeViewController()
        kakaoPostCodeVC.delegate = self
        present(kakaoPostCodeVC, animated: true)
    }
    
    func textFieldDidEndEditing(addressName: String?,
                                receiverName: String?,
                                receiverPhoneNumber: String?,
                                detailAddress: String?,
                                request: String?) {
        
        addressData.addressName = addressName ?? ""
        addressData.receiverName = receiverName ?? ""
        addressData.receiverPhoneNumber = receiverPhoneNumber ?? ""
        addressData.detailAddress = detailAddress
        addressData.request = request
        
    }
    
    
}



extension OrderViewController: KakaoPostCodeViewControllerDelegate {
    
    func fetchPostCode(roadAddress: String, zoneCode: String) {
        addressData.address = roadAddress
        addressData.postCode = zoneCode
        
        addressView.updateUI(addressData)
    }
    
    
}
