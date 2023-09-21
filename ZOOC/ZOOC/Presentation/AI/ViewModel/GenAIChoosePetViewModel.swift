//
//  GenAIChoosePetModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/17.
//

import UIKit

import RxSwift
import RxCocoa

final class GenAIChoosePetViewModel: ViewModelType {
    internal var disposeBag = DisposeBag()
    private let genAIChoosePetUseCase: GenAIChoosePetUseCase
    
    init(genAIChoosePetUseCase: GenAIChoosePetUseCase) {
        self.genAIChoosePetUseCase = genAIChoosePetUseCase
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
        var canPushNextView: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewWillAppearEvent
            .subscribe(with: self, onNext: { owner, _ in
            owner.genAIChoosePetUseCase.getTotalPet()
        }).disposed(by: disposeBag)
        
        input.petCellTapEvent
            .subscribe(with: self, onNext: { owner, indexPath in
            owner.genAIChoosePetUseCase.selectPet(at: indexPath.item)
        }).disposed(by: disposeBag)
        
        input.registerButtonDidTapEvent
            .subscribe(with: self, onNext: { owner, _ in
            owner.genAIChoosePetUseCase.pushNextView()
        }).disposed(by: disposeBag)
        
        return output
    }
    
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        genAIChoosePetUseCase.petId.subscribe(onNext: { petId in
            output.petId.accept(petId)
        }).disposed(by: disposeBag)
        
        genAIChoosePetUseCase.petList.subscribe(onNext: { petList in
            output.petList.accept(petList)
        }).disposed(by: disposeBag)
        
        genAIChoosePetUseCase.canRegisterPet.subscribe(onNext: { canRegister in
            output.canRegisterPet.accept(canRegister)
        }).disposed(by: disposeBag)
        
        genAIChoosePetUseCase.canPushNextView.subscribe(onNext: { canPush in
            output.canPushNextView.accept(canPush)
        }).disposed(by: disposeBag)
    }
}

extension GenAIChoosePetViewModel {
    func getPetListData() -> BehaviorRelay<[RecordRegisterModel]> {
        return genAIChoosePetUseCase.petList
    }
    
    func getPetId() -> BehaviorRelay<Int?> {
        return genAIChoosePetUseCase.petId
    }
    
    func getCanRegisterPet() ->  BehaviorRelay<Bool> {
        return genAIChoosePetUseCase.canRegisterPet
    }
}
