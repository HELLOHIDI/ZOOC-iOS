//
//  MyEditProfileViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/08.
//

import UIKit

import RxSwift
import RxCocoa
import Kingfisher

final class MyEditProfileViewModel: ViewModelType {
    internal var disposeBag = DisposeBag()
    private let myEditProfileUseCase: MyEditProfileUseCase
    
    init(myEditProfileUseCase: MyEditProfileUseCase) {
        self.myEditProfileUseCase = myEditProfileUseCase
    }
    
    struct Input {
        var nameTextFieldDidChangeEvent: Observable<String?>
        var editButtonTapEvent: Observable<UIImage>
    }
    
    struct Output {
        var textFieldState = BehaviorRelay<BaseTextFieldState>(value: .isEmpty)
        var ableToEditProfile = BehaviorRelay<Bool>(value: false)
        var isTextCountExceeded = BehaviorRelay<Bool>(value: false)
        var isEdited = BehaviorRelay<Bool?>(value: false)
        var profileData = BehaviorRelay<EditProfileRequest?>(value: nil)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.nameTextFieldDidChangeEvent.subscribe(with: self, onNext: { owner, text in
            owner.myEditProfileUseCase.nameTextFieldDidChangeEvent(text)
        }).disposed(by: disposeBag)
        
        input.editButtonTapEvent.subscribe(with: self, onNext: { owner, profileImage in
            owner.myEditProfileUseCase.editProfile(profileImage)
        }).disposed(by: disposeBag)
        
        return output
    }
    
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        myEditProfileUseCase.profileData.subscribe(onNext: { profileData in
            output.profileData.accept(profileData)
        }).disposed(by: disposeBag)
        
        myEditProfileUseCase.textFieldState.subscribe(onNext: { state in
            output.textFieldState.accept(state)
        }).disposed(by: disposeBag)
        
        myEditProfileUseCase.ableToEditProfile.subscribe(onNext: { canEdit in
            output.ableToEditProfile.accept(canEdit)
        }).disposed(by: disposeBag)
        
        myEditProfileUseCase.isTextCountExceeded.subscribe(onNext: { isTextCountExceeded in
            output.isTextCountExceeded.accept(isTextCountExceeded)
        }).disposed(by: disposeBag)
        
        myEditProfileUseCase.isEdited.subscribe(onNext: { isEdited in
            output.isEdited.accept(isEdited)
        }).disposed(by: disposeBag)
    }
}
