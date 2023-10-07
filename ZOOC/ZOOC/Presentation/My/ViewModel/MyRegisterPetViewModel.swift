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
        let viewWillAppearEvent: Observable<Void>
        let registerButtonDidTapEvent: Observable<Void>
        let deleteRegisterPetEvent: Observable<Int>
        let addRegisterPetEvent: Observable<Void>
        let deleteRegisterPetImageEvent: Observable<Int>
        let selectRegisterPetImageEvent: Observable<(UIImage, Int)>
        let nameDidChangeEvent: Observable<(String, Int)>
    }
    
    struct Output {
        var petMemberData = BehaviorRelay<[PetResult]>(value: [])
        var ableToRegisterPets = BehaviorRelay<Bool?>(value: nil)
        var isRegistered = PublishRelay<Bool>()
        var registerPetData = BehaviorRelay<[MyPetRegisterModel]>(value: [])
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewWillAppearEvent.subscribe(with: self, onNext: { owner, _ in
            owner.myRegisterPetUseCase.requestPetData()
        }).disposed(by: disposeBag)
        
        input.registerButtonDidTapEvent.subscribe(with: self, onNext: { owner, _ in
            owner.myRegisterPetUseCase.registerPet()
        }).disposed(by: disposeBag)
        
        input.addRegisterPetEvent.subscribe(with: self, onNext: { owner, _ in
            owner.myRegisterPetUseCase.addPet()
        }).disposed(by: disposeBag)
        
        input.deleteRegisterPetEvent.subscribe(with: self, onNext: { owner, tag in
            owner.myRegisterPetUseCase.deletePet(tag)
        }).disposed(by: disposeBag)
        
        input.deleteRegisterPetImageEvent.subscribe(with: self, onNext: { owner, tag in
            owner.myRegisterPetUseCase.deleteProfileImage(tag)
        }).disposed(by: disposeBag)
        
        input.selectRegisterPetImageEvent.subscribe(with: self, onNext: { owner, data in
            owner.myRegisterPetUseCase.selectProfileImage(data)
        }).disposed(by: disposeBag)
        
        input.nameDidChangeEvent.subscribe(with: self, onNext: { owner, data in
            owner.myRegisterPetUseCase.updatePetName(data)
        }).disposed(by: disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        myRegisterPetUseCase.petMemberData.subscribe(onNext: { petMember in
            output.petMemberData.accept(petMember)
        }).disposed(by: disposeBag)
        
        myRegisterPetUseCase.ableToRegisterPets.subscribe(onNext: { canRegister in
            output.ableToRegisterPets.accept(canRegister)
        }).disposed(by: disposeBag)
        
        myRegisterPetUseCase.isRegistered.subscribe(onNext: { isRegistered in
            output.isRegistered.accept(isRegistered)
        }).disposed(by: disposeBag)
        
        myRegisterPetUseCase.registerPetData.subscribe(onNext: { registerPetMember in
            output.registerPetData.accept(registerPetMember)
        }).disposed(by: disposeBag)
    }
}

extension MyRegisterPetViewModel {
    func getPetMember() -> [PetResult] {
        return myRegisterPetUseCase.petMemberData.value
    }
    
    func getRegisterPetData() -> [MyPetRegisterModel] {
        return myRegisterPetUseCase.registerPetData.value
    }
    
    func getAddButtonIsHidden() -> Bool {
        return myRegisterPetUseCase.addButtonIsHidden.value
    }
    
    func getDeleteButtonIsHidden() -> Bool {
        return myRegisterPetUseCase.deleteButtonIsHidden.value
    }
}


