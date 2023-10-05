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
        let petCellShouldSelectIndexPathEvent: Observable<Int>
        let petCellShouldSelectEvent: Observable<PetAiResult>
        let refreshValueChangedEvent: Observable<Void>
        let productCellDidSelectEvent: Observable<ProductResult>
    }
    
    struct Output {
        let petAiData = PublishRelay<[PetAiResult]>()
        let productData = PublishRelay<[ProductResult]>()
        let petDidSelected = PublishRelay<(Int, PetAiResult)>()
        let petDeselect = PublishRelay<Int>()
        let pushGenAIGuideVC = PublishRelay<Int>()
        let pushShopProductVC = PublishRelay<ShopProductModel>()
        let showToast = PublishRelay<ShopToastCase>()
    }
    
    //MARK: - Properties
    
    private var petID: Int
    
    //MARK: - Life Cycle
    
    init(petID: Int) {
        self.petID = petID
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        Observable<Void>.merge(input.viewDidLoadEvent,
                               input.refreshValueChangedEvent)
            .subscribe(with: self) { owner, _ in
                owner.requestProductsAPI(output: output)
                owner.requestTotalPetAPI(output: output)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.petCellShouldSelectIndexPathEvent,
                                 input.petCellShouldSelectEvent)
        .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
        .subscribe(onNext: { (row, petAiData) in
                switch petAiData.state {
                case .notStarted:
                    output.pushGenAIGuideVC.accept(petAiData.id)
                    output.petDeselect.accept(row)
                case .inProgress:
                    output.pushGenAIGuideVC.accept(petAiData.id)
                    output.petDeselect.accept(row)
                case .done:
                    output.petDidSelected.accept((row, petAiData))
                }
            })
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
                
                guard !data.isEmpty else {
                    //TODO: 빈 배열일 때 처리
                    output.showToast.accept(.custom(message: "먼저 반려동물을 등록해주세요"))
                    return
                }
                let petAiData = data.map { $0.transform(state: .notStarted)} // TODO: 서버 dataset값에 따라 바뀌게
                
                output.petAiData.accept(petAiData)
                
                let ableToSelectData = petAiData.filter { $0.state != .notStarted }
                
                if !ableToSelectData.isEmpty {
                    output.petDidSelected.accept((0,ableToSelectData.first!))
                } else {
                    output.petDeselect.accept(0)
                }
                
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
                data.append(.init()) // 커밍쑨 셀 추가를 위해 기본 데이터 추가
                output.productData.accept(data)
            default:
                return
            }
        }
        
    }
}
