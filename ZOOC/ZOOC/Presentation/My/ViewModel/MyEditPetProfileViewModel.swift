//
//  MyEditPetProfileViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/08.
//

import UIKit

import RxSwift
import RxCocoa
import Kingfisher

final class MyEditPetProfileViewModel: ViewModelType {
    private let myEditPetProfileUseCase: MyEditPetProfileUseCase
    
    init(myEditPetProfileUseCase: MyEditPetProfileUseCase) {
        self.myEditPetProfileUseCase = myEditPetProfileUseCase
    }
    
    struct Input {
        var nameTextFieldDidChangeEvent: Observable<String?>
        var editButtonTapEvent: Observable<UIImage?>
        var deleteButtonTapEvent: Observable<Void>
        var selectImageEvent: Observable<UIImage>
    }
    
    struct Output {
        var petProfileData = BehaviorRelay<EditPetProfileRequest?>(value: nil)
        var textFieldState = BehaviorRelay<BaseTextFieldState>(value: .isEmpty)
        var ableToEditProfile = BehaviorRelay<Bool>(value: false)
        var isTextCountExceeded = BehaviorRelay<Bool>(value: false)
        var isEdited = BehaviorRelay<Bool?>(value: nil)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.nameTextFieldDidChangeEvent.subscribe(with: self, onNext: { owner, text in
            owner.myEditPetProfileUseCase.nameTextFieldDidChangeEvent(text)
        }).disposed(by: disposeBag)
        
        input.editButtonTapEvent.subscribe(with: self, onNext: { owner, _ in
            owner.myEditPetProfileUseCase.editProfile()
        }).disposed(by: disposeBag)
        
        input.deleteButtonTapEvent.subscribe(with: self, onNext: { owner, _ in
            owner.myEditPetProfileUseCase.deleteProfileImage()
        }).disposed(by: disposeBag)
        
        input.selectImageEvent.subscribe(with: self, onNext: { owner, profileImage in
            owner.myEditPetProfileUseCase.selectProfileImage(profileImage)
        }).disposed(by: disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        myEditPetProfileUseCase.petProfileData.subscribe(onNext: { profileData in
            output.petProfileData.accept(profileData)
        }).disposed(by: disposeBag)
        
        myEditPetProfileUseCase.textFieldState.subscribe(onNext: { state in
            output.textFieldState.accept(state)
        }).disposed(by: disposeBag)
        
        myEditPetProfileUseCase.ableToEditProfile.subscribe(onNext: { canEdit in
            output.ableToEditProfile.accept(canEdit)
        }).disposed(by: disposeBag)
        
        myEditPetProfileUseCase.isTextCountExceeded.subscribe(onNext: { isTextCountExceeded in
            output.isTextCountExceeded.accept(isTextCountExceeded)
        }).disposed(by: disposeBag)
        
        myEditPetProfileUseCase.isEdited.subscribe(onNext: { isEdited in
            output.isEdited.accept(isEdited)
        }).disposed(by: disposeBag)
    }
}
