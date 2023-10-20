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
    
    private let rootView = OrderView()
    private let viewModel: OrderViewModel
    private let disposeBag = DisposeBag()
    
    private let registeredAddressCellRequestTextFieldDidChange = PublishRelay<(OrderBasicAddress, String)>()
    private let validateOrderSuccess = PublishRelay<AddressType>()
    private let checkRegisterAddress = PublishRelay<Bool>()
    
    //MARK: - Life Cycle
    
    init(viewModel: OrderViewModel) {
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
            viewDidLoadEvent: rx.viewDidLoad.asObservable(),
            registedAddressCellShoulSelectRowEvent: rootView.addressView.basicAddressView.collectionView.rx.itemSelected.asObservable().map { $0.row },
            registedAddressCellShoulSelectEvent: rootView.addressView.basicAddressView.collectionView.rx.modelSelected(OrderBasicAddress.self).asObservable(),
            registeredAddressCellRequestTextFieldDidChange:
                registeredAddressCellRequestTextFieldDidChange.asObservable(),
            validateOrderSuccess: validateOrderSuccess.asObservable(),
            checkRegisterAddress: checkRegisterAddress.asObservable()
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
        
        output.registeredAddressData
            .asDriver(onErrorJustReturn: [])
            .drive(
                rootView.addressView.basicAddressView.collectionView.rx.items(cellIdentifier:
                                                                                OrderBasicAddressCollectionViewCell.reuseCellIdentifier,
                                                                              cellType: OrderBasicAddressCollectionViewCell.self)
            ) { [weak self] row, data, cell in
                guard let self else { return }
                cell.dataBind(data)
                cell.delegate = self
            }
            .disposed(by: disposeBag)
        
        output.registeredAddressData
            .asDriver(onErrorJustReturn: [])
            .drive(with: self, onNext: { owner, registeredAddressData in
                owner.rootView.addressView.dataBind(registeredAddressData)
            })
            .disposed(by: disposeBag)
        
        
        output.registedAddressCellDidSelected
            .asDriver(onErrorJustReturn: Int())
            .drive(with: self, onNext: { owner, row  in
                owner.rootView.addressView.basicAddressView.collectionView.selectCell(row: row)
                owner.rootView.addressView.basicAddressView.collectionView.layoutIfNeeded()
                owner.rootView.addressView.basicAddressView.collectionView.performBatchUpdates({
                    owner.rootView.addressView.basicAddressButtonDidTap()
                })
            })
            .disposed(by: disposeBag)
        
        output.orderSuccess
            .asDriver(onErrorJustReturn: Int())
            .drive(with: self, onNext: { owner, totalPrice in
                switch owner.viewModel.paymentType {
                case .withoutBankBook:
                    let payVC = OrderAssistantViewController(totalPrice: totalPrice)
                    payVC.modalPresentationStyle = .fullScreen
                    owner.present(payVC, animated: true) {
                        owner.navigationController?.popToRootViewController(animated: false)
                    }
                default:
                    owner.showToast("주문하기 완료", type: .good)
                    owner.navigationController?.popToRootViewController(animated: false)
                }
            })
            .disposed(by: disposeBag)
        
        
    }
    
    //MARK: - Action Method
    
    private func orderButtonDidTap() {
        do {
            try rootView.ordererView.checkValidity()
            try rootView.addressView.checkValidity()
            try rootView.paymentMethodView.checkValidity()
            try rootView.agreementView.checkValidity()
            
            validateOrderSuccess.accept(rootView.addressView.addressType)
            
            if rootView.addressView.addressType == .new {
                let isSelected = rootView.addressView.newAddressView.registerBasicAddressCheckButton.isSelected
                checkRegisterAddress.accept(isSelected)
            }
            
        } catch let error as OrderInvalidError {
            showToast(error.message, type: .bad)
            
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

}

//MARK: - OrdererViewDelegate

extension OrderViewController: OrderOrdererViewDelegate {
    func textFieldDidEndEditing(name: String?, phoneNumber: String?) {
        viewModel.ordererData.name = name ?? ""
        viewModel.ordererData.phoneNumber = phoneNumber ?? ""
    }
}

//MARK: - OrderAddressViewDelegate

extension OrderViewController: OrderAddressViewDelegate & OrderNewAddressViewDelegate {
  
    func newAddressButtonDidTap(_ height: CGFloat) {
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
        guard viewModel.hasRegistedAddress else {
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
        
        guard !viewModel.ordererData.name.isEmpty ||
                !viewModel.ordererData.phoneNumber.isEmpty else {
            showToast("먼저 구매자 정보를 입력해주세요", type: .bad)
            rootView.scrollView.setContentOffset(CGPoint(x: 0, y: rootView.ordererView.frame.minY), animated: true)
            return
        }
        
        viewModel.newAddressData.receiverName = viewModel.ordererData.name
        viewModel.newAddressData.receiverPhoneNumber = viewModel.ordererData.phoneNumber
        rootView.updateUI(viewModel.newAddressData)
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
        
        viewModel.newAddressData.addressName = addressName
        viewModel.newAddressData.receiverName = receiverName
        viewModel.newAddressData.receiverPhoneNumber = receiverPhoneNumber
        viewModel.newAddressData.detailAddress = detailAddress
        viewModel.newAddressData.request = request
    }
}

//MARK: - OrderPaymentMethodViewDelegate

extension OrderViewController: OrderPaymentMethodViewDelegate {
    func paymentMethodDidChange(_ paymentType: PaymentType) {
        viewModel.paymentType = paymentType
    }
}

//MARK: - OrderAgreementViewDelegate

extension OrderViewController: OrderAgreementViewDelegate {
    func allPoliciesAgreemCheckButtonDidChange(allPoliciesAgree: Bool) {
        viewModel.agreementData.agreeWithOnwardTransfer = allPoliciesAgree
        viewModel.agreementData.agreeWithTermOfUse = allPoliciesAgree
        rootView.agreementView.updateUI(viewModel.agreementData)
    }
    
    func checkButtonDidChange(onwardTransfer: Bool, termOfUse: Bool) {
        viewModel.agreementData.agreeWithOnwardTransfer = onwardTransfer
        viewModel.agreementData.agreeWithTermOfUse = termOfUse
        rootView.agreementView.updateUI(viewModel.agreementData)
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
        viewModel.newAddressData.address = roadAddress
        viewModel.newAddressData.postCode = zoneCode
        rootView.updateUI(viewModel.newAddressData)
    }
}


extension OrderViewController: OrderBasicAddressCollectionViewCellDelegate {
    func requestTextFieldDidChange(_ object: OrderBasicAddress, request: String) {
        registeredAddressCellRequestTextFieldDidChange.accept((object,request))
    }
    
}
