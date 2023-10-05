//
//  ShopViewModel.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/29.
//

import Foundation

import RxSwift
import RxCocoa

final class ShopViewModel {
    
    //MARK: - Input & Output
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let refreshValueChangedEvent: Observable<Void>
        let productCellDidSelectEvent: Observable<ProductResult>
    }
    
    struct Output {
        let petAiData = PublishRelay<[PetAiResult]>()
        let productData = PublishRelay<[ProductResult]>()
        let pushShopProductVC = PublishRelay<ShopProductModel>()
        let showToast = PublishRelay<ShopToastCase>()
    }
    
    //MARK: - Properties
    
    private var petData: [PetResult] = []
    private var petID: Int
    
    //MARK: - Life Cycle
    
    init(petID: Int, petData: [PetResult] = []) {
        self.petID = petID
        self.petData = petData
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        Observable<Void>.merge(input.viewDidLoadEvent,
                               input.refreshValueChangedEvent)
            .subscribe(with: self) { owner, _ in
                owner.requestProductsAPI(output: output)
                owner.requestTotalPetAPI(output: output)
                //output.petAiData.accept(owner.petData.map { $0.transform(state: .done)})
            }
            .disposed(by: disposeBag)
        
        input.productCellDidSelectEvent
            .subscribe(with: self, onNext: { owner, data in
                guard data != ProductResult() else {
                    output.showToast.accept(.commingSoon)
                    return
                }
                
                let model = ShopProductModel(petID: owner.petID,
                                             productID: data.id)
                output.pushShopProductVC.accept(model)
            })
            .disposed(by: disposeBag)
        
        
        return output
    }
    
}

extension ShopViewModel {
    
    private func requestTotalPetAPI(output: Output) {
        HomeAPI.shared.getTotalPet(familyID: UserDefaultsManager.familyID) { result in
            switch result {
            case .success(let data):
                guard let data = data as? [PetResult] else { return }
                //TODO: 빈 배열일 때 처리
                let petAiData = data.map { $0.transform(state: .done)}
                output.petAiData.accept(petAiData)
            default:
                break
            }
        }
    }
    
    private func requestProductsAPI(output: Output) {
        ShopAPI.shared.getTotalProducts { result in
            switch result {
            case .success(let data):
                guard var data = data as? [ProductResult] else {
                    output.showToast.accept(.productNotFound)
                    return
                }
                data.append(.init()) // 커밍쑨 담당 데이터 추가
                output.productData.accept(data)
            default:
                return
            }
        }
        
    }
}
