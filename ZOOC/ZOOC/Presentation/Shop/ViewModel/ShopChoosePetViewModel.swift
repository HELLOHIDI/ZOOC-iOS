//
//  ShopChoosePetViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/16.
//

import UIKit

import RxSwift
import RxCocoa

final class ShopChoosePetViewModel: ViewModelType {
    internal var disposeBag = DisposeBag()
    private let shopChoosePetUseCase: ShopChoosePetUseCase
    
    init(shopChoosePetUseCase: ShopChoosePetUseCase) {
        self.shopChoosePetUseCase = shopChoosePetUseCase
    }
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let petCellTapEvent: Observable<IndexPath>
        let registerButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var petId: BehaviorRelay<Int?> = BehaviorRelay<Int?>(value: nil)
        var petList: BehaviorRelay<[RecordRegisterModel]> = BehaviorRelay<[RecordRegisterModel]>(value: [])
        var canRegisterPet: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
        var datasetStatus: BehaviorRelay<DatasetStatus?> = BehaviorRelay<DatasetStatus?>(value: nil)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewWillAppearEvent
            .subscribe(with: self, onNext: { owner, _ in
            owner.shopChoosePetUseCase.getTotalPet()
        }).disposed(by: disposeBag)
        
        input.petCellTapEvent
            .subscribe(with: self, onNext: { owner, indexPath in
            owner.shopChoosePetUseCase.selectPet(at: indexPath.item)
        }).disposed(by: disposeBag)
        
        input.registerButtonDidTapEvent
            .subscribe(with: self, onNext: { owner, _ in
            owner.shopChoosePetUseCase.checkDatasetValid()
        }).disposed(by: disposeBag)
        
        return output
    }
    
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        shopChoosePetUseCase.petId.subscribe(onNext: { petId in
            output.petId.accept(petId)
        }).disposed(by: disposeBag)
        
        shopChoosePetUseCase.petList.subscribe(onNext: { petList in
            output.petList.accept(petList)
        }).disposed(by: disposeBag)
        
        shopChoosePetUseCase.canRegisterPet.subscribe(onNext: { canRegister in
            output.canRegisterPet.accept(canRegister)
        }).disposed(by: disposeBag)
        
        shopChoosePetUseCase.datasetStatus.subscribe(onNext: { datasetStatus in
            output.datasetStatus.accept(datasetStatus)
        }).disposed(by: disposeBag)
    }
}

extension ShopChoosePetViewModel {
    func getPetListData() -> [RecordRegisterModel] {
        return shopChoosePetUseCase.petList.value
    }
    
    func getPetId() -> Int? {
        return shopChoosePetUseCase.petId.value
    }
    
    func getCanRegisterPet() -> DatasetStatus? {
        return shopChoosePetUseCase.datasetStatus.value
    }
}

