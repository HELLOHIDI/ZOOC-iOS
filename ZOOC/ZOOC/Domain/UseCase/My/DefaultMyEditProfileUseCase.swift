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
        self.profileData.accept(profileData)
        self.repository = repository
    }
    
    var profileData = BehaviorRelay<EditProfileRequest?>(value: nil)
    var textFieldState = BehaviorRelay<BaseTextFieldState>(value: .isEmpty)
    var ableToEditProfile = BehaviorRelay<Bool>(value: false)
    var isTextCountExceeded = BehaviorRelay<Bool>(value: false)
    var isEdited = PublishRelay<Bool>()
    
    func editProfile() {
        guard let profileData = profileData.value else { return }
        repository.patchMyProfile(request: profileData, completion: { [weak self] result in
            switch result {
            case .success(_):
                self?.isEdited.accept(true)
            default:
                self?.isEdited.accept(false)
            }
        })
    }
    
    func isTextCountExceeded(for type: MyEditTextField.TextFieldType) {
        guard let profileData = profileData.value else { return }
        let limit = type.limit
        self.isTextCountExceeded.accept(profileData.nickName.count >= limit)
    }
    
    func nameTextFieldDidChangeEvent(_ text: String?) {
        guard let profileData = profileData.value else { return }
        guard let name = text else { return }
        let updateProfileData = EditProfileRequest(
            hasPhoto: profileData.hasPhoto,
            nickName: name,
            profileImage: profileData.profileImage
        )
        self.profileData.accept(updateProfileData)
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
    
    func deleteProfileImage() {
        guard let profile = profileData.value else { return }
        let updateProfileData = EditProfileRequest(
            hasPhoto: false,
            nickName: profile.nickName,
            profileImage: nil
        )
        self.profileData.accept(updateProfileData)
        canEdit(profile.nickName.count)
    }
    
    func selectProfileImage(_ image: UIImage) {
        guard let profile = profileData.value else { return }
        let updateProfileData = EditProfileRequest(
            hasPhoto: true,
            nickName: profile.nickName,
            profileImage: image
        )
        self.profileData.accept(updateProfileData)
        canEdit(profile.nickName.count)
    }
}

extension DefaultMyEditProfileUseCase {
    func canEdit(_ nameCnt: Int) {
        ableToEditProfile.accept(nameCnt > 0)
    }
}
