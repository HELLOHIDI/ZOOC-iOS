//
//  GentAIRegisterViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/17.
//

import UIKit

import Kingfisher
import RxSwift
import RxCocoa


final class GenAIRegisterPetViewModel: ViewModelType {
    internal var disposeBag = DisposeBag()
    private let genAIRegisterPetUseCase: GenAIRegisterPetUseCase
    
    init(genAIRegisterPetUseCase: GenAIRegisterPetUseCase) {
        self.genAIRegisterPetUseCase = genAIRegisterPetUseCase
    }
    
    struct Input {
        var nameTextFieldDidChangeEvent: Observable<String?>
        var registerPetButtonTapEvent: Observable<UIImage>
    }
    
    struct Output {
        var petId = BehaviorRelay<Int?>(value: nil)
        var name = BehaviorRelay<String>(value: "")
        var canRegisterPet = BehaviorRelay<Bool>(value: false)
        var isRegistedPet = BehaviorRelay<Bool>(value: false)
        var textFieldState = BehaviorRelay<BaseTextFieldState>(value: .isEmpty)
        var isTextCountExceeded = BehaviorRelay<Bool>(value: false)
    }
    
    func transform(from input: Input, disposeBag: RxSwift.DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.nameTextFieldDidChangeEvent
            .subscribe(with: self, onNext: { owner, name in
            owner.genAIRegisterPetUseCase.nameTextFieldDidChangeEvent(name)
        }).disposed(by: disposeBag)
        
        input.registerPetButtonTapEvent
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, image in
            owner.genAIRegisterPetUseCase.registerProfileImage(image)
            owner.genAIRegisterPetUseCase.registerPet()
        }).disposed(by: disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        genAIRegisterPetUseCase.petId.subscribe(onNext: { petId in
            output.petId.accept(petId)
        }).disposed(by: disposeBag)
        
        genAIRegisterPetUseCase.name.subscribe(onNext: { name in
            output.name.accept(name)
        }).disposed(by: disposeBag)
        
        genAIRegisterPetUseCase.canRegisterPet.subscribe(onNext: { canRegisterPet in
            output.canRegisterPet.accept(canRegisterPet)
        }).disposed(by: disposeBag)
        
        genAIRegisterPetUseCase.isRegistedPet.subscribe(onNext: { isRegistedPet in
            output.isRegistedPet.accept(isRegistedPet)
        }).disposed(by: disposeBag)
        
        genAIRegisterPetUseCase.textFieldState.subscribe(onNext: { textFieldState in
            output.textFieldState.accept(textFieldState)
        }).disposed(by: disposeBag)
        
        genAIRegisterPetUseCase.isTextCountExceeded.subscribe(onNext: { isTextCountExceeded in
            output.isTextCountExceeded.accept(isTextCountExceeded)
        }).disposed(by: disposeBag)
    }
}

extension GenAIRegisterPetViewModel {
    func getPetId() -> Int? {
        return genAIRegisterPetUseCase.petId.value
    }
}
