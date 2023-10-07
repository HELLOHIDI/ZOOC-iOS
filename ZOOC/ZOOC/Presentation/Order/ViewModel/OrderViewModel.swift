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
    
    //MARK: - Input & Output
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        let productsData = PublishRelay<[OrderProduct]>()
        let productsTotalPrice = PublishRelay<Int>()
        let deliveryFee = PublishRelay<Int>()
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
                
                output.productsData.accept(owner.productsData)
                
                let productsTotalPrice = owner.productsData.reduce(0) { $0 + $1.productsPrice }
                output.productsTotalPrice.accept(productsTotalPrice)
                
            })
            .disposed(by: disposeBag)
        
        
        
        
        return output
    }
    
    
}

extension OrderViewModel {
    
}

extension OrderViewModel {
    private func requestDeliveryFee(output: Output) {
        
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings =  RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        remoteConfig.fetch() { status, error in
            if status == .success {
                remoteConfig.activate() { [weak self] changed, error in
                    guard let self else { return }
                    
                    DispatchQueue.main.async {
                        let deliveryFee = Int(truncating: remoteConfig["deliveryFee"].numberValue)
                        output.deliveryFee.accept(deliveryFee)
                    }
                }
            } else {
                return
            }
        }
    }

}
