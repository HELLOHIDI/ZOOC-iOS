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
        var registerPetButtonTapEvent: Observable<Void>
        var deleteButtonTapEvent: Observable<Void>
        var registerPetProfileImageButtonTapEvent: Observable<UIImage>
//        var isTextCountExceeded: Observable<MyEditTextField.TextFieldType>
    }
    
    struct Output {
        var petId = BehaviorRelay<Int?>(value: nil)
        var name = BehaviorRelay<String>(value: "")
        var photo = BehaviorRelay<UIImage?>(value: nil)
        var canRegisterPet = BehaviorRelay<Bool>(value: false)
        var isRegistedPet = BehaviorRelay<Bool>(value: false)
        var textFieldState = BehaviorRelay<BaseTextFieldState>(value: .isEmpty)
    }
    
    func transform(from input: Input, disposeBag: RxSwift.DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.nameTextFieldDidChangeEvent.subscribe(onNext: { [weak self] name in
            self?.genAIRegisterPetUseCase.nameTextFieldDidChangeEvent(name)
        }).disposed(by: disposeBag)
        
        input.registerPetButtonTapEvent.subscribe(onNext: { [weak self] _ in
            self?.genAIRegisterPetUseCase.registerPet()
        }).disposed(by: disposeBag)
        
        input.registerPetProfileImageButtonTapEvent.subscribe(onNext: { [weak self] image in
            self?.genAIRegisterPetUseCase.registerProfileImage(image)
        }).disposed(by: disposeBag)
        
        input.deleteButtonTapEvent.subscribe(onNext: { [weak self] _ in
            self?.genAIRegisterPetUseCase.deleteProfileImage()
        }).disposed(by: disposeBag)
        
//        input.isTextCountExceeded.drive(onNext: { [weak self] textFieldType in
//            self?.genAIRegisterPetUseCase.isTextCountExceeded(for: textFieldType)
//        }).disposed(by: disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        genAIRegisterPetUseCase.petId.subscribe(onNext: { petId in
            output.petId.accept(petId)
        }).disposed(by: disposeBag)
        
        genAIRegisterPetUseCase.name.subscribe(onNext: { name in
            output.name.accept(name)
        }).disposed(by: disposeBag)
        
        genAIRegisterPetUseCase.photo.subscribe(onNext: { photo in
            output.photo.accept(photo)
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
    }
}

extension GenAIRegisterPetViewModel {
    
    func getPetId() -> BehaviorRelay<Int?> {
        return genAIRegisterPetUseCase.petId
    }
}
