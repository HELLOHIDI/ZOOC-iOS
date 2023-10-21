//
//  ShopViewModel.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/29.
//

import UIKit // 쓰면 안되는거 아는데 너무 급하니까 쓸게 떠구미안

import FirebaseAnalytics
import RxSwift
import RxCocoa

final class ShopViewModel {
    
    //MARK: - Input & Output
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
//        let petCellShouldSelectIndexPathEvent: Observable<Int>
//        let petCellShouldSelectEvent: Observable<PetAiModel>
        let refreshValueChangedEvent: Observable<Void>
        let productCellDidSelectEvent: Observable<ProductResult>
        let eventButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let petAiData = PublishRelay<[PetAiModel]>()
        let productData = PublishRelay<[ProductResult]>()
        let petDidSelected = PublishRelay<(Int, PetAiModel)>()
        let petDeselect = PublishRelay<Int>()
        let eventImageShouldChanged = PublishRelay<UIImage>()
        let ableToClickBanner = PublishRelay<Bool>()
        let pushGenAIGuideVC = PublishRelay<Int>()
        let pushShopProductVC = PublishRelay<ShopProductModel>()
        let pushEventVC = PublishRelay<Void>()
        let pushAIPetArchiveVC = PublishRelay<Void>()
        let showShopToast = PublishRelay<ShopToastCase>()
        let showEventToast = PublishRelay<EventToastCase>()
    }
    
    //MARK: - Properties
    
    private var selectedPetID: Int?
    private var eventAble = BehaviorRelay<Bool>(value: false)
    private var eventProgress = BehaviorRelay<EventProgress>(value: .notApplied)
    
    init(_ petId: Int?) {
        selectedPetID = petId
    }
    
    //MARK: - Life Cycle
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        Observable.combineLatest(eventAble, eventProgress)
            .subscribe(onNext: { able, progress in
                print("progress는 \(progress) image는 \(progress.imageURL)")
                let endedImage = Image.ended
                let image = able ? progress.imageURL : endedImage
                output.eventImageShouldChanged.accept(image)
                output.ableToClickBanner.accept(progress.ableToClick)
            })
            .disposed(by: disposeBag)
        
        Observable<Void>.merge(input.viewDidLoadEvent,
                               input.refreshValueChangedEvent)
            .subscribe(with: self) { owner, _ in
                owner.requestProductsAPI(output: output)
                owner.requestTotalPetAPI(output: output)
                owner.requestEventAPI()
                owner.requestEventProgressAPI()
            }
            .disposed(by: disposeBag)
        
//        Observable.zip(input.petCellShouldSelectIndexPathEvent,
//                                 input.petCellShouldSelectEvent)
//        .subscribe(onNext: { [weak self] (row, petAiData) in
//                switch petAiData.state {
//                case .notStarted:
//                    output.pushGenAIGuideVC.accept(petAiData.id)
//                    output.petDeselect.accept(row)
//                case .inProgress:
//                    output.pushGenAIGuideVC.accept(petAiData.id)
//                    output.petDeselect.accept(row)
//                case .done:
//                    self?.selectedPetID = petAiData.id
//                    output.petDidSelected.accept((row, petAiData))
//                }
//            })
//            .disposed(by: disposeBag)
        
        input.productCellDidSelectEvent
            .subscribe(with: self, onNext: { owner, data in
                guard data != ProductResult() else {
                    output.showShopToast.accept(.commingSoon) // 커밍순 눌렀을 때
                    return
                }
                
                guard let selectedPetID = owner.selectedPetID else {
                    output.showShopToast.accept(.custom(message: "반려동물을 선택해주세요"))
                    return
                }
                
                let model = ShopProductModel(petID: selectedPetID,
                                             productID: data.id)
                output.pushShopProductVC.accept(model)
            })
            .disposed(by: disposeBag)
        
        input.eventButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                guard owner.eventAble.value else {
                    output.showEventToast.accept(.ended)
                    return
                }
                
                switch owner.eventProgress.value {
                case .notApplied:
                    owner.requestPostEventAPI(output: output)
                case .inProgress:
                    output.showEventToast.accept(.inProgress)
                case .done:
                    output.pushEventVC.accept(Void())
                }
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
}

extension ShopViewModel {
    
    private func requestTotalPetAPI(output: Output) {
        HomeAPI.shared.getTotalPet(familyID: UserDefaultsManager.familyID) { [weak self] result in
            switch result {
            case .success(let data):
                guard let data = data as? [PetResult] else { return }
                
                guard !data.isEmpty else {
                    //TODO: 빈 배열일 때 처리
                    output.showShopToast.accept(.custom(message: "먼저 반려동물을 등록해주세요"))
                    return
                }
                let petAiData = data.map { $0.toPetAiModel() } 
                
                output.petAiData.accept(petAiData)
                
                let ableToSelectData = petAiData.filter { $0.state != .notStarted }
                
                if !ableToSelectData.isEmpty {
                    self?.selectedPetID = ableToSelectData.first!.id
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
                    output.showShopToast.accept(.productNotFound)
                    return
                }
                data.append(.init()) // 커밍쑨 셀 추가를 위해 기본 데이터 추가
                output.productData.accept(data)
            default:
                return
            }
        }
        
    }
    
    private func requestEventAPI() {
        ShopAPI.shared.getEvent { result in
            switch result {
            case .success(let data):
                guard let data = data as? ShopEventResult else {
                    return
                }
                
                self.eventAble.accept(data.able)
            default:
                return
            }
        }
    }
    
    private func requestEventProgressAPI() {
        ShopAPI.shared.getEventProgress { result in
            switch result {
            case .success(let data):
                guard let data = data as? String else {
                    return
                }
                
                guard let progress = EventProgress(rawValue: data) else { return }
                self.eventProgress.accept(progress)
                
            default:
                return
            }
        }
    }
    
    private func requestPostEventAPI(output: Output) {
        guard let selectedPetID else { return }
        ShopAPI.shared.postEvent(petID: selectedPetID) { result in
            switch result {
            case .success(_):
                output.showEventToast.accept(.appliedEventSuccess)
            default:
                output.showEventToast.accept(.appliedEventFail)
            }
        }
    }
}
