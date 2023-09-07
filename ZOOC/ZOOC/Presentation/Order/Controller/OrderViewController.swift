//
//  OrderViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/24.
//

import UIKit

import RealmSwift
import SnapKit
import Then

final class OrderViewController: BaseViewController {
    
    //MARK: - Properties
    
    private var ordererData = OrderOrderer()
    private var addressData = OrderAddress()
    private let productData: OrderProduct
    private let priceData: OrderPrice
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
        addressView.updateUI(newAddressData: addressData, basicAddressDatas: basicAddressResult)
        productView.updateUI(productData)
        priceView.updateUI(priceData)
    }
    
    private func registerBasicAddress(_ data: OrderAddress) {
        if addressView.newAddressView.registerBasicAddressCheckButton.isSelected == true && addressView.newAddressButton.isSelected == true {
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
            
//            requestOrderAPI(ordererData,
//                            addressData,
//                            productData,
//                            priceData)
            
            registerBasicAddress(addressData)
            print("짜잔~ \(addressData.request)")
            
        } catch OrderInvalidError.ordererInvalid {
            presentBottomAlert("구매자 정보를 입력해주세요.")
            let y = ordererView.frame.minY
            scrollView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
            
        } catch OrderInvalidError.addressInvlid {
            presentBottomAlert("배송지 정보를 입력해주세요.")
            let y = addressView.frame.minY
            scrollView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
            
        } catch OrderInvalidError.paymentMethodInvalid {
            presentBottomAlert("결제수단 정보를 확인해주세요.")
            let y = paymentMethodView.frame.minY
            scrollView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
            
        } catch OrderInvalidError.agreementInvalid {
            presentBottomAlert("결제 진행 필수사항을 동의해주세요.")
            scrollView.setContentOffset(CGPoint(x: 0,
                                                y: self.scrollView.contentSize.height - self.scrollView.bounds.height),
                                             animated: true)
        } catch {
            presentBottomAlert("알수없는 오류가 발생했습니다. \n 다시 시도해주세요.")
        }
    }
    
    private func requestOrderAPI(_ orderer: OrderOrderer,
                                 _ address: OrderAddress,
                                 _ product: OrderProduct,
                                 _ price: OrderPrice) {
        
        let request = OrderRequest(orderer: orderer,
                                   address: address,
                                   product: product,
                                   price: price)
        
        ShopAPI.shared.postOrder(request: request) { result in
            
            self.validateResult(result)
            let payVC = OrderAssistantViewController(totalPrice: self.priceData.totalPrice)
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
        addressData.receiverName = ordererData.name
        addressData.receiverPhoneNumber = ordererData.phoneNumber
        
        addressView.updateUI(newAddressData: addressData)
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
        
        addressData.addressName = addressName
        addressData.receiverName = receiverName
        addressData.receiverPhoneNumber = receiverPhoneNumber
        addressData.detailAddress = detailAddress
        addressData.request = request
    }
    
    func basicAddressCheckButtonDidTap(tag: Int) {
        try! basicAddressRealm.write {
            for i in 0..<basicAddressResult.count {
                basicAddressResult[i].isSelected = (i == tag)
                print(basicAddressResult[tag].isSelected)
            }
            addressData.addressName = basicAddressResult[tag].address
            addressData.receiverName = basicAddressResult[tag].name
            addressData.receiverPhoneNumber = basicAddressResult[tag].phoneNumber
            addressData.detailAddress = basicAddressResult[tag].detailAddress
            addressView.updateUI(newAddressData: addressData, basicAddressDatas: basicAddressResult)
        }
    }
    
    func basicAddressTextFieldDidChange(tag: Int, request: String?) {
        try! basicAddressRealm.write {
            basicAddressResult[tag].request = request
        }
        addressData.request = basicAddressResult[tag].request
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
        addressData.address = roadAddress
        addressData.postCode = zoneCode
        
        addressView.updateUI(newAddressData: addressData, isPostData: true)
    }
}
