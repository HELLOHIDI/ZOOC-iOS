//
//  DefaultMyEditPetProfileUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/28.
//

import UIKit

import RxSwift
import RxCocoa

final class DefaultMyEditPetProfileUseCase: MyEditPetProfileUseCase {
    private let repository: MyRepository
    private let disposeBag = DisposeBag()
    
    init(petProfileData: EditPetProfileRequest?,
         id: Int,
         repository: MyRepository
    ) {
        self.petProfileData.accept(petProfileData)
        self.id.accept(id)
        self.repository = repository
    }
    
    var id = BehaviorRelay<Int?>(value: nil)
    var petProfileData = BehaviorRelay<EditPetProfileRequest?>(value: nil)
    var textFieldState = BehaviorRelay<BaseTextFieldState>(value: .isEmpty)
    var ableToEditProfile = BehaviorRelay<Bool>(value: false)
    var isTextCountExceeded = BehaviorRelay<Bool>(value: false)
    var isEdited = PublishRelay<Bool>()
    
    func editProfile() {
        guard let profile = petProfileData.value else { return }
        guard let id = id.value else { return }
            repository.patchPetProfile(request: profile, id: id, completion: { [weak self] result in
            switch result {
            case .success(_):
                self?.isEdited.accept(true)
                NotificationCenter.default.post(name: .myPageUpdate, object: nil)
            default:
                self?.isEdited.accept(false)
            }
        })
    }
    
    func isTextCountExceeded(for type: MyEditTextField.TextFieldType) {
        guard let petProfileData = petProfileData.value else { return }
        let limit = type.limit
        self.isTextCountExceeded.accept(petProfileData.nickName.count >= limit)
    }
    
    func nameTextFieldDidChangeEvent(_ text: String?) {
        guard let petProfileData = petProfileData.value else { return }
        guard let name = text else { return }
        let updateProfileData = EditPetProfileRequest(
            photo: petProfileData.photo,
            nickName: name,
            file: petProfileData.file
        )
        self.petProfileData.accept(updateProfileData)
        switch name.count {
        case 1...3:
            textFieldState.accept(.isWritten)
            ableToEditProfile.accept(true)
            isTextCountExceeded.accept(false)
        case 4...:
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
        guard let profile = petProfileData.value else { return }
        let updatePetProfileData = EditPetProfileRequest(
            photo: false,
            nickName: profile.nickName,
            file: nil
        )
        self.petProfileData.accept(updatePetProfileData)
        canEdit(profile.nickName.count)
    }
    
    func selectProfileImage(_ image: UIImage) {
        guard let profile = petProfileData.value else { return }
        let updatePetProfileData = EditPetProfileRequest(
            photo: true,
            nickName: profile.nickName,
            file: image
        )
        self.petProfileData.accept(updatePetProfileData)
        canEdit(profile.nickName.count)
    }
}

extension DefaultMyEditPetProfileUseCase {
    func canEdit(_ nameCnt: Int) {
        ableToEditProfile.accept(nameCnt > 0)
    }
}
