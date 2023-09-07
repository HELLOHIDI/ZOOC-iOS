//
//  OrderViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/24.
//

import UIKit

import FirebaseRemoteConfig
import RealmSwift
import SnapKit
import Then

final class OrderViewController: BaseViewController {
    
    //MARK: - Properties
    
    private var ordererData = OrderOrderer()
    private var addressData = OrderAddress()
    private var newAddressData = OrderAddress()
    private var basicAddressData = OrderAddress()
    
    private var deliveryFee = 4000 {
        didSet {
            priceView.updateUI(selectedProductData, deliveryFee: deliveryFee)
        }
    }
    private let selectedProductData: [SelectedProductOption]
    
    private var agreementData = OrderAgreement()
    
    let basicAddressRealm = try! Realm()
    var basicAddressResult: Results<OrderBasicAddress>!

    //MARK: - UI Components
    
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let productView = OrderProductView()
    private let ordererView = OrderOrdererView()
    private let addressView = OrderAddressView()
    private let paymentMethodView = OrderPaymentMethodView()
    private let priceView = OrderPriceView()
    private let agreementView = OrderAgreementView()
    
    private let orderButton = ZoocGradientButton()
    
    //MARK: - Life Cycle
    
    init(selectedProduct: [SelectedProductOption]) {
        self.selectedProductData = selectedProduct
        super.init(nibName: nil, bundle: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        hierarchy()
        layout()
        setDelegate()
        requestDeliveryFee()
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
        
        titleLabel.do {
            $0.text = "주문하기"
            $0.font = .zoocHeadLine
            $0.textColor = .zoocDarkGray2
            $0.textAlignment = .left
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
            $0.setTitle("결제하기", for: .normal)
            $0.addTarget(self,
                         action: #selector(orderButtonDidTap),
                         for: .touchUpInside)
        }
    }
    
    private func hierarchy() {
        view.addSubviews(backButton, titleLabel, scrollView, orderButton)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(addressView,
                                productView,
                                ordererView,
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
        
        productView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(1)
            $0.horizontalEdges.equalToSuperview()
        }
        
        ordererView.snp.makeConstraints {
            $0.top.equalTo(productView.snp.bottom).offset(1)
            $0.horizontalEdges.equalToSuperview()
        }
        
        addressView.snp.makeConstraints {
            $0.top.equalTo(ordererView.snp.bottom).offset(1)
            $0.horizontalEdges.equalToSuperview()
        }
        
        paymentMethodView.snp.makeConstraints {
            $0.top.equalTo(addressView.snp.bottom).offset(1)
            $0.horizontalEdges.equalToSuperview()
        }
        
        priceView.snp.makeConstraints {
            $0.top.equalTo(paymentMethodView.snp.bottom).offset(1)
            $0.horizontalEdges.equalToSuperview()
        }
        
        agreementView.snp.makeConstraints {
            $0.top.equalTo(priceView.snp.bottom).offset(1)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    
    private func setDelegate(){
        ordererView.delegate = self
        addressView.delegate = self
        addressView.newAddressView.delegate = self
        addressView.basicAddressView.delegate = self
        paymentMethodView.delegate = self
        agreementView.delegate = self
    }
    
    private func updateUI() {
        basicAddressResult = basicAddressRealm.objects(OrderBasicAddress.self)
        
        ordererView.updateUI(ordererData)
        addressView.updateUI(newAddressData: newAddressData, basicAddressDatas: basicAddressResult)
        productView.updateUI(selectedProductData)
        priceView.updateUI(selectedProductData, deliveryFee: deliveryFee)
    }
    
    private func registerBasicAddress(_ data: OrderAddress) {
        if addressView.newAddressView.registerBasicAddressCheckButton.isSelected == true && addressView.newAddressView.isHidden == false {
            let fullAddress = "(\(data.postCode)) \(data.address)"
            let newAddress = OrderBasicAddress.init(
                postCode: data.postCode,
                name: data.receiverName,
                address: fullAddress,
                detailAddress: data.detailAddress,
                phoneNumber: data.receiverPhoneNumber,
                request: nil,
                isSelected: false
            )
            
            let filter = basicAddressResult.filter("fullAddress=='\(newAddress.fullAddress)'")
            print("filter: \(filter)")
            
            if filter.isEmpty {
                try! basicAddressRealm.write {
                    basicAddressRealm.add(newAddress)
                    print(newAddress)
                }
            } else {
                presentBottomAlert("이미 등록된 주소입니다!")
            }
        } else {
            print("로컬DB에 등록이 불가능합니다!")
        }
    }
    
    //MARK: - Action Method
    
    @objc
    private func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func orderButtonDidTap() {
        view.endEditing(true)
        do {
            try ordererView.checkValidity()
            try addressView.checkValidity()
            try agreementView.checkValidity()
            
            requestOrderAPI(ordererData,
                            addressData,
                            selectedProductData,
                            deliveryFee)
            
            registerBasicAddress(newAddressData)
            
        } catch OrderInvalidError.ordererInvalid {
            showToast("구매자 정보를 모두 입력해주세요.",
                      type: .bad,
                      bottomInset: 86)
            let y = ordererView.frame.minY
            scrollView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
            
        } catch OrderInvalidError.addressInvlid {
            showToast("필수 배송 정보를 모두 입력해주세요",
                      type: .bad,
                      bottomInset: 86)
            
            let y = addressView.frame.minY
            scrollView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
            
        } catch OrderInvalidError.paymentMethodInvalid {
            showToast("결제수단 정보를 확인해주세요.",
                      type: .bad,
                      bottomInset: 86)
            
            let y = paymentMethodView.frame.minY
            scrollView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
            
        } catch OrderInvalidError.agreementInvalid {
            showToast("필수 동의 항목을 확인해주세요",
                      type: .bad,
                      bottomInset: 86)
            
            scrollView.setContentOffset(CGPoint(x: 0,
                                                y: self.scrollView.contentSize.height - self.scrollView.bounds.height),
                                             animated: true)
        } catch {
            showToast("알수없는 오류가 발생했습니다.\n다시 시도해주세요.", type: .bad)
        }
    }
    
    private func requestOrderAPI(_ orderer: OrderOrderer,
                                 _ address: OrderAddress,
                                 _ products: [SelectedProductOption],
                                 _ deliveryFee: Int) {
        
        let request = OrderRequest(orderer: orderer,
                                   address: address,
                                   products: products,
                                   deliveryFee: deliveryFee)
        
        ShopAPI.shared.postOrder(request: request) { result in
            
            self.validateResult(result)
            
            let totalPrice = products.reduce(0) { $0 + $1.productsPrice} + deliveryFee
            let payVC = OrderAssistantViewController(totalPrice: totalPrice)
            payVC.modalPresentationStyle = .fullScreen
            self.present(payVC, animated: true) {
                self.navigationController?.popToRootViewController(animated: false)
            }
            
        }
    }
    
}

//MARK: - OrdererViewDelegate

extension OrderViewController: OrderOrdererViewDelegate {
    func textFieldDidEndEditing(name: String?, phoneNumber: String?) {
        ordererData.name = name ?? ""
        ordererData.phoneNumber = phoneNumber ?? ""
    }
    
}

//MARK: - OrderAddressViewDelegate

extension OrderViewController: OrderAddressViewDelegate & OrderNewAddressViewDelegate & OrderBasicAddressViewDelegate {

    func copyButtonDidTap() {
        print(#function)
        view.endEditing(true)
        newAddressData.receiverName = ordererData.name
        newAddressData.receiverPhoneNumber = ordererData.phoneNumber
        
        addressView.updateUI(newAddressData: newAddressData)
    }
    
    func findAddressButtonDidTap() {
        let kakaoPostCodeVC = KakaoPostCodeViewController()
        kakaoPostCodeVC.delegate = self
        present(kakaoPostCodeVC, animated: true)
    }
    
    func textFieldDidEndEditing(addressName: String,
                                receiverName: String,
                                receiverPhoneNumber: String,
                                detailAddress: String?,
                                request: String?) {
        
        newAddressData.addressName = addressName
        newAddressData.receiverName = receiverName
        newAddressData.receiverPhoneNumber = receiverPhoneNumber
        newAddressData.detailAddress = detailAddress
        newAddressData.request = request
        addressData = newAddressData
    }
    
    func basicAddressCheckButtonDidTap(tag: Int) {
        try! basicAddressRealm.write {
            for i in 0..<basicAddressResult.count {
                basicAddressResult[i].isSelected = (i == tag)
                print(basicAddressResult[tag].isSelected)
            }
            basicAddressData.addressName = basicAddressResult[tag].address
            basicAddressData.receiverName = basicAddressResult[tag].name
            basicAddressData.receiverPhoneNumber = basicAddressResult[tag].phoneNumber
            basicAddressData.detailAddress = basicAddressResult[tag].detailAddress
            addressData = basicAddressData
            addressView.updateUI(newAddressData: newAddressData, basicAddressDatas: basicAddressResult)
        }
    }
    
    func basicAddressTextFieldDidChange(tag: Int, request: String?) {
        try! basicAddressRealm.write {
            basicAddressResult[tag].request = request
        }
        basicAddressData.request = basicAddressResult[tag].request
    }
}

//MARK: - OrderPaymentMethodViewDelegate

extension OrderViewController: OrderPaymentMethodViewDelegate {
    
}

//MARK: - OrderAgreementViewDelegate

extension OrderViewController: OrderAgreementViewDelegate {
    func allPoliciesAgreemCheckButtonDidChange(allPoliciesAgree: Bool) {
        agreementData.agreeWithOnwardTransfer = allPoliciesAgree
        agreementData.agreeWithTermOfUse = allPoliciesAgree
        agreementView.updateUI(agreementData)
    }
    
    func checkButtonDidChange(onwardTransfer: Bool, termOfUse: Bool) {
        agreementData.agreeWithOnwardTransfer = onwardTransfer
        agreementData.agreeWithTermOfUse = termOfUse
        agreementView.updateUI(agreementData)
    }
    
    func watchButtonDidTap(_ type: OrderAgreementView.Policy) {
        var url = ExternalURL.zoocDefaultURL
        
        switch type {
        case .onwardTransfer:
            url = ExternalURL.onwardTransfer
        case .privacyPolicy:
            url = ExternalURL.privacyPolicy
        }
        
        presentSafariViewController(url)
    }
    
}


//MARK: - KakaoPostCodeViewControllerDelegate

extension OrderViewController: KakaoPostCodeViewControllerDelegate {
    
    func fetchPostCode(roadAddress: String, zoneCode: String) {
        newAddressData.address = roadAddress
        newAddressData.postCode = zoneCode
        
        addressView.updateUI(newAddressData: newAddressData, isPostData: true)
    }
}

extension OrderViewController {
    private func requestDeliveryFee() {
        
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings =  RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        remoteConfig.fetch() { [weak self] status, error in
            
            if status == .success {
                remoteConfig.activate() { [weak self] changed, error in
                    DispatchQueue.main.async {
                        self?.deliveryFee = Int(truncating: remoteConfig["deliveryFee"].numberValue)
                    }
                }
            } else {
                return
            }
        }
    }

}
