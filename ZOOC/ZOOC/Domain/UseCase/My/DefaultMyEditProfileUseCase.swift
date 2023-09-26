//
//  DefaultMyEditProfileUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/25.
//

import UIKit

import RxSwift
import RxCocoa

final class DefaultMyEditProfileUseCase: MyEditProfileUseCase {
    private let repository: MyRepository
    private let disposeBag = DisposeBag()
    
    init(profileData: EditProfileRequest?, repository: MyRepository) {
        self.name.accept(profileData?.nickName ?? "")
        self.profileData.accept(profileData)
        self.repository = repository
    }
    
    var name = BehaviorRelay<String>(value: "")
    var profileData = BehaviorRelay<EditProfileRequest?>(value: nil)
    var textFieldState = BehaviorRelay<BaseTextFieldState>(value: .isEmpty)
    var ableToEditProfile = BehaviorRelay<Bool>(value: false)
    var isTextCountExceeded = BehaviorRelay<Bool>(value: false)
    var isEdited = BehaviorRelay<Bool?>(value: false)
    

    
    func editProfile(_ image: UIImage? = nil) {
        guard let profile = profileData.value else { return }
            repository.patchMyProfile(request: profile, completion: { [weak self] result in
            switch result {
            case .success(_):
                self?.isEdited.accept(true)
            default:
                self?.isEdited.accept(false)
            }
        })
    }
    
    func isTextCountExceeded(for type: MyEditTextField.TextFieldType) {
        let limit = type.limit
        self.isTextCountExceeded.accept(self.name.value.count >= limit)
    }
    
    func nameTextFieldDidChangeEvent(_ text: String?) {
        guard let name = text else { return }
        self.name.accept(name)
        switch name.count {
        case 1...9:
            textFieldState.accept(.isWritten)
            ableToEditProfile.accept(true)
            isTextCountExceeded.accept(false)
        case 10...:
            textFieldState.accept(.isFull)
            ableToEditProfile.accept(true)
            isTextCountExceeded.accept(true)
        default:
            textFieldState.accept(.isEmpty)
            ableToEditProfile.accept(false)
            isTextCountExceeded.accept(false)
        }
    }
}
