//
//  OrderViewModel.swift
//  ZOOC
//
//  Created by 장석우 on 2023/10/07.
//

import Foundation

import RxCocoa
import RxSwift

import FirebaseRemoteConfig

final class OrderViewModel {
    
    let realmService: RealmService
    let zoocService: ShopAPI
    
    //MARK: - Properties
    
    let productsData: [OrderProduct]
    var hasRegistedAddress: Bool = false
    var selectedRegistedAddress: OrderBasicAddress?
    
    private var productsTotalPrice = Int()
    private var deliveryFee = Int()
    
    private var totalPrice: Int { productsTotalPrice + deliveryFee }
    
    var ordererData = OrderOrderer()
    var newAddressData = OrderAddress()
    
    var paymentType: PaymentType = .withoutBankBook
    var agreementData = OrderAgreement()
    
    //MARK: - Input & Output
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let registedAddressCellShoulSelectRowEvent: Observable<Int>
        let registedAddressCellShoulSelectEvent: Observable<OrderBasicAddress>
        let registeredAddressCellRequestTextFieldDidChange: Observable<(OrderBasicAddress, String)>
        let validateOrderSuccess: Observable<AddressType>
        let checkRegisterAddress: Observable<Bool>
    }
    
    struct Output {
        let productsData = PublishRelay<[OrderProduct]>()
        let productsTotalPrice = PublishRelay<Int>()
        let deliveryFee = PublishRelay<Int>()
        let registeredAddressData = PublishRelay<[OrderBasicAddress]>()
        let registedAddressCellDidSelected = PublishRelay<Int>()
        let orderSuccess = PublishRelay<Int>()
        let showToast = PublishRelay<OrderToastCase>()
    }
    
    
    //MARK: - Life Cycle
    
    init(realmService: RealmService,
         zoocService: ShopAPI,
         productsData: [OrderProduct]
    ) {
        self.realmService = realmService
        self.zoocService = zoocService
        self.productsData = productsData
    }
    
    
    //MARK: - Custom Method
    
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        
        input.viewDidLoadEvent
            .subscribe(with: self, onNext: { owner, _ in
                owner.requestDeliveryFee(output: output)
                owner.getRegisteredAddress(output: output)
                
                output.productsData.accept(owner.productsData)
                
                let productsTotalPrice = owner.productsData.reduce(0) { $0 + $1.productsPrice }
                output.productsTotalPrice.accept(productsTotalPrice)
                owner.productsTotalPrice = productsTotalPrice
                
                
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.registedAddressCellShoulSelectRowEvent,
                                 input.registedAddressCellShoulSelectEvent)
        .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
        .subscribe(onNext: { [weak self] (row, addressData) in
            
            self?.selectRegisteredAddress(addressData)
                
            output.registedAddressCellDidSelected.accept(row)
            self?.selectedRegistedAddress = addressData
        })
        .disposed(by: disposeBag)
        
        input.registeredAddressCellRequestTextFieldDidChange
            .subscribe(onNext: { [weak self] object, text in
                self?.updateRegisteredAddressRequest(object, request: text)
            })
            .disposed(by: disposeBag)
        
        input.validateOrderSuccess
            .subscribe(with: self, onNext: { owner, addressType in
                let currentAddress = (addressType == .new) ? owner.newAddressData : owner.selectedRegistedAddress!.transform()
                
                owner.requestOrderAPI(owner.ordererData,
                                      currentAddress,
                                      owner.productsData,
                                      owner.deliveryFee,
                                      output: output)
            })
            .disposed(by: disposeBag)
        
        input.checkRegisterAddress
            .subscribe(with: self, onNext: { owner, isSelected in
                if isSelected {
                    owner.registerNewAddress(owner.newAddressData)
                }
            })
            .disposed(by: disposeBag)
        
        
        
        
        return output
    }
    
    
}

//MARK: - Zooc Service

extension OrderViewModel {
    private func requestOrderAPI(_ orderer: OrderOrderer,
                                 _ address: OrderAddress,
                                 _ products: [OrderProduct],
                                 _ deliveryFee: Int,
                                 output: Output) {
        
        let request = OrderRequest(orderer: orderer,
                                   address: address,
                                   products: products,
                                   deliveryFee: deliveryFee)
        
        ShopAPI.shared.postOrder(request: request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                output.orderSuccess.accept(self.totalPrice)
                self.deleteAllCartedProducts()
            case .requestErr(let msg):
                output.showToast.accept(.custom(message: msg))
            default:
                output.showToast.accept(.serverFail)
            }
        }
        
    }
}

//MARK: - Realm Service

extension OrderViewModel {
    
    private func getRegisteredAddress(output: Output) {
        Task {
            let registedAddress = await realmService.getRegisteredAddress()
            output.registeredAddressData.accept(registedAddress)
            
            guard !registedAddress.isEmpty else {
                hasRegistedAddress = false
                return
            }
            hasRegistedAddress = true
            output.registedAddressCellDidSelected.accept(0)
        }
    }
    
    private func selectRegisteredAddress(_ object: OrderBasicAddress) {
        Task {
            await realmService.selectBasicAddress(object)
        }
    }
    
    private func updateRegisteredAddressRequest(_ object: OrderBasicAddress, request: String) {
        
        Task {
            await realmService.updateBasicAddressRequest(object, request: request)
        }
    }
    
    private func deleteAllCartedProducts() {
        Task {
            await realmService.deleteAllCartedProducts()
        }
    }
    
    
    private func registerNewAddress(_ data: OrderAddress) {
        Task {
            await realmService.updateBasicAddress(data)
        }
    }
    
}

//MARK: - Firebase Service

extension OrderViewModel {
    private func requestDeliveryFee(output: Output) {
        
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings =  RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        remoteConfig.fetch() { [weak self] status, error in
            if status == .success {
                remoteConfig.activate() { changed, error in
                    DispatchQueue.main.async {
                        let deliveryFee = Int(truncating: remoteConfig["deliveryFee"].numberValue)
                        output.deliveryFee.accept(deliveryFee)
                        self?.deliveryFee = deliveryFee
                    }
                }
            } else {
                return
            }
        }
    }
}


