//
//  MyRegisterPetViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/29.
//

import UIKit

import RxSwift
import RxCocoa
import Kingfisher

final class MyRegisterPetViewModel: ViewModelType {
    private let myRegisterPetUseCase: MyRegisterPetUseCase
    
    init(myRegisterPetUseCase: MyRegisterPetUseCase) {
        self.myRegisterPetUseCase = myRegisterPetUseCase
    }
    
    struct Input {
        let registerButtonDidTapEvent: Observable<Void>
        let nameDidChangeEvent: Observable<String>
        let breedDidChangeEvent: Observable<String>
    }
    
    struct Output {
        var petName = BehaviorRelay<String>(value: "")
        var petBreed = BehaviorRelay<String>(value: "")
        var ableToRegisterPet = BehaviorRelay<Bool>(value: false)
        var isRegistered = PublishRelay<Bool>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.registerButtonDidTapEvent.subscribe(with: self, onNext: { owner, _ in
            owner.myRegisterPetUseCase.registerPet()
        }).disposed(by: disposeBag)
        
        input.nameDidChangeEvent.subscribe(with: self, onNext: { owner, name in
            owner.myRegisterPetUseCase.updatePetName(name)
        }).disposed(by: disposeBag)
        
        input.breedDidChangeEvent.subscribe(with: self, onNext: { owner, breed in
            owner.myRegisterPetUseCase.updatePetBreed(breed)
        }).disposed(by: disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        myRegisterPetUseCase.isRegistered.subscribe(onNext: { isRegistered in
            output.isRegistered.accept(isRegistered)
        }).disposed(by: disposeBag)
        
        myRegisterPetUseCase.petName.subscribe(onNext: { petName in
            output.petName.accept(petName)
        }).disposed(by: disposeBag)
        
        myRegisterPetUseCase.petBreed.subscribe(onNext: { petBreed in
            output.petBreed.accept(petBreed)
        }).disposed(by: disposeBag)
    }
}
