//
//  RecordSelectPetViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/03.
//

import UIKit

import RxSwift
import RxCocoa

final class RecordSelectPetViewModel: ViewModelType {
    private let recordSelectPetUseCase: RecordSelectPetUseCase
    
    init(recordSelectPetUseCase: RecordSelectPetUseCase) {
        self.recordSelectPetUseCase = recordSelectPetUseCase
    }
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let petCellTapEvent: Observable<IndexPath>
        let recordButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var petList = BehaviorRelay<[RecordRegisterModel]>(value: [])
        var ableToRecord = BehaviorRelay<Bool>(value: false)
        var isRegistered = PublishRelay<Bool>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewWillAppearEvent.subscribe(with: self, onNext: { owner, _ in
            owner.recordSelectPetUseCase.getTotalPet()
        }).disposed(by: disposeBag)
        
        input.petCellTapEvent.subscribe(with: self, onNext: { owner, index in
            owner.recordSelectPetUseCase.selectPet(at: index.item)
        }).disposed(by: disposeBag)
        
        input.recordButtonDidTapEvent.subscribe(with: self, onNext: { owner, _ in
            owner.recordSelectPetUseCase.postRecord()
        }).disposed(by: disposeBag)
        
        return output
    }
    
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        recordSelectPetUseCase.petList.subscribe(onNext: { petList in
            output.petList.accept(petList)
        }).disposed(by: disposeBag)
        
        recordSelectPetUseCase.ableToRecord.subscribe(onNext: { canRecord in
            output.ableToRecord.accept(canRecord)
        }).disposed(by: disposeBag)
        
        recordSelectPetUseCase.isRegistered.subscribe(onNext: { isRegistered in
            output.isRegistered.accept(isRegistered)
        }).disposed(by: disposeBag)
    }
}

