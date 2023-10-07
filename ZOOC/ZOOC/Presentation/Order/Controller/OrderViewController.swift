//
//  OrderViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/24.
//

import UIKit

import FirebaseRemoteConfig
import RxCocoa
import RxSwift
import RealmSwift



final class OrderViewController: BaseViewController {
    
    private let realmService: RealmService
    
    
    private let rootView = OrderView()
    private let viewModel: OrderViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Properties
    
    private let productsData: [OrderProduct]
    
    private var ordererData = OrderOrderer()
    private var currentAddressData = OrderAddress() {
        didSet {
            print(currentAddressData)
        }
    }
    
    var basicAddressResult: Results<OrderBasicAddress>!
    private var newAddressData = OrderAddress()
    
    private var paymentType : PaymentType = .withoutBankBook
    private var agreementData = OrderAgreement()
    
    
    //MARK: - Life Cycle
    
    init(_ products: [OrderProduct], realmService: RealmService, viewModel: OrderViewModel) {
        self.productsData = products
        self.realmService = realmService
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        bindUI()
        bindViewModel()
        
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setDelegate()
        
        setAddressData()
        
        dismissKeyboardWhenTappedAround()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    private func setDelegate(){
        rootView.ordererView.delegate = self
        rootView.addressView.delegate = self
        rootView.addressView.newAddressView.delegate = self
        rootView.paymentMethodView.delegate = self
        rootView.agreementView.delegate = self
    }
    
    private func bindUI() {
        
        rootView.backButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.orderButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.view.endEditing(true)
                owner.orderButtonDidTap()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = OrderViewModel.Input(
            viewDidLoadEvent: rx.viewDidLoad.asObservable()
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.productsData
            .asDriver(onErrorJustReturn: [])
            .drive(with: self, onNext: { owner, productsData in
                owner.rootView.updateUI(productsData)
            })
            .disposed(by: disposeBag)
        
        
        Observable.combineLatest(output.productsTotalPrice,
                                 output.deliveryFee)
            .asDriver(onErrorJustReturn: (Int(),Int()))
            .drive(onNext: { [weak self] productsTotalPrice, deliveryFee in
                let totalPrice = productsTotalPrice + deliveryFee
                self?.rootView.updateUI(deliveryFee,
                                        productsTotalPrice,
                                        totalPrice)
            })
            .disposed(by: disposeBag)
        
        
    }
    
    private func setAddressData() {
        Task {
            basicAddressResult = await realmService.getBasicAddress()
            rootView.addressView.dataBind(basicAddressResult)
            
            if let selectedAddressData = await realmService.getSelectedAddress() {
                currentAddressData = selectedAddressData.transform()
            }
        }
      
    }
    
    private func registerNewAddress(_ data: OrderAddress) {
        if rootView.addressView.newAddressView.registerBasicAddressCheckButton.isSelected == true && rootView.addressView.newAddressView.isHidden == false {
            Task {
                await realmService.updateBasicAddress(data)
            }
        } else {
            print("로컬DB에 등록이 불가능합니다!")
        }
    }
    
    //MARK: - Action Method
    
    private func orderButtonDidTap() {
        do {
            try rootView.ordererView.checkValidity()
            try rootView.addressView.checkValidity()
            try rootView.paymentMethodView.checkValidity()
            try rootView.agreementView.checkValidity()
            
            try updateAddressData()
            
            requestOrderAPI(ordererData,
                            currentAddressData,
                            productsData,
                            3000)
            
        } catch let error as OrderInvalidError {
            showToast(error.message,
                      type: .bad,
                      bottomInset: 86)
            
            var y: CGFloat = 0
            switch error {
            case .ordererInvalid:
                y = rootView.ordererView.frame.minY
            case .addressInvlid:
                y = rootView.addressView.frame.minY
            case .paymentMethodInvalid:
                y = rootView.paymentMethodView.frame.minY
            case .agreementInvalid:
                y = rootView.scrollView.contentSize.height - rootView.scrollView.bounds.height
            case .noAddressSelected:
                y = rootView.addressView.frame.minY
            }
            rootView.scrollView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
        } catch {
            showToast("알 수 없는 오류가 발생했습니다.",
                      type: .bad)
        }
    }
    
    private func updateAddressData() throws {
        switch rootView.addressView.addressType {
        case .new:
            registerNewAddress(newAddressData)
            self.currentAddressData = newAddressData
        case .registed:
            Task {
                let addressData = await realmService.getSelectedAddress()
                guard let addressData else {
                    throw OrderInvalidError.noAddressSelected
                }
                self.currentAddressData = addressData.transform()
            }
            
            
        }
    }
    
    private func requestOrderAPI(_ orderer: OrderOrderer,
                                 _ address: OrderAddress,
                                 _ products: [OrderProduct],
                                 _ deliveryFee: Int) {
        
        let request = OrderRequest(orderer: orderer,
                                   address: address,
                                   products: products,
                                   deliveryFee: deliveryFee)
        
        ShopAPI.shared.postOrder(request: request) { result in
            guard self.validateResult(result) != nil else {
                self.showToast("주문하기에 실패하였습니다. 다시 시도해주세요", type: .bad)
                return
            }
            
            Task {
                await self.realmService.deleteAllCartedProducts()
            }
            
            
            switch self.paymentType {
            case .withoutBankBook:
                let totalPrice = products.reduce(0) { $0 + $1.productsPrice} + deliveryFee
                let payVC = OrderAssistantViewController(totalPrice: totalPrice)
                payVC.modalPresentationStyle = .fullScreen
                self.present(payVC, animated: true) {
                    self.navigationController?.popToRootViewController(animated: false)
                }
            default:
                self.showToast("주문하기 완료", type: .good)
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

extension OrderViewController: OrderAddressViewDelegate & OrderNewAddressViewDelegate {
  
    func newAddressButtonDidTap(_ height: CGFloat) {
        currentAddressData = newAddressData
        
        rootView.addressView.snp.remakeConstraints {
            $0.top.equalTo(rootView.ordererView.snp.bottom).offset(1)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(height)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func basicAddressButtonDidTap(_ height: CGFloat) {
        guard !basicAddressResult.isEmpty else {
            showToast("먼저 신규입력으로 배송지를 등록해주세요", type: .bad)
            return
        }
        
        rootView.addressView.snp.remakeConstraints {
            $0.top.equalTo(rootView.ordererView.snp.bottom).offset(1)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(height)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    

    func copyButtonDidTap() {
        view.endEditing(true)
        
        guard !ordererData.name.isEmpty ||
                !ordererData.phoneNumber.isEmpty else {
            showToast("먼저 구매자 정보를 입력해주세요", type: .bad)
            rootView.scrollView.setContentOffset(CGPoint(x: 0, y: rootView.ordererView.frame.minY), animated: true)
            return
        }
        
        newAddressData.receiverName = ordererData.name
        newAddressData.receiverPhoneNumber = ordererData.phoneNumber
        rootView.addressView.updateUI(newAddressData: newAddressData)
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
        currentAddressData = newAddressData
    }
}

//MARK: - OrderPaymentMethodViewDelegate

extension OrderViewController: OrderPaymentMethodViewDelegate {
    func paymentMethodDidChange(_ paymentType: PaymentType) {
        self.paymentType = paymentType
    }
}

//MARK: - OrderAgreementViewDelegate

extension OrderViewController: OrderAgreementViewDelegate {
    func allPoliciesAgreemCheckButtonDidChange(allPoliciesAgree: Bool) {
        agreementData.agreeWithOnwardTransfer = allPoliciesAgree
        agreementData.agreeWithTermOfUse = allPoliciesAgree
        rootView.agreementView.updateUI(agreementData)
    }
    
    func checkButtonDidChange(onwardTransfer: Bool, termOfUse: Bool) {
        agreementData.agreeWithOnwardTransfer = onwardTransfer
        agreementData.agreeWithTermOfUse = termOfUse
        rootView.agreementView.updateUI(agreementData)
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
        rootView.addressView.updateUI(newAddressData: newAddressData)
    }
}

