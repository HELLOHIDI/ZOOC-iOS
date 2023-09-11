//
//  MyEditProfileViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/08.
//

import UIKit

import Kingfisher

protocol MyEditProfileModelInput {
    func nameTextFieldDidChangeEvent(_ text: String)
    func editCompleteButtonDidTap()
    func deleteButtonDidTap()
    func editProfileImageEvent(_ image: UIImage)
}

protocol MyEditProfileModelOutput {
    var ableToEditProfile: ObservablePattern<Bool> { get }
    var textFieldState: ObservablePattern<BaseTextFieldState> { get }
    var editCompletedOutput: ObservablePattern<Bool?> { get }
    var editProfileDataOutput: ObservablePattern<EditProfileRequest> { get }
}

final class MyEditProfileViewModel: MyEditProfileModelInput, MyEditProfileModelOutput {
    
    private let repository: MyEditProfileRepository
    
    var ableToEditProfile: ObservablePattern<Bool> = ObservablePattern(false)
    var textFieldState: ObservablePattern<BaseTextFieldState> = ObservablePattern(.isEmpty)
    var editCompletedOutput: ObservablePattern<Bool?> = ObservablePattern(nil)
    var editProfileDataOutput: ObservablePattern<EditProfileRequest> = ObservablePattern(EditProfileRequest())
    
    
    init(editProfileData: EditProfileRequest, repository: MyEditProfileRepository) {
        self.repository = repository
        self.editProfileDataOutput.value = editProfileData
    }
    
    func nameTextFieldDidChangeEvent(_ text: String) {
        self.editProfileDataOutput.value.nickName = text
        var textFieldState: BaseTextFieldState
        switch text.count {
        case 1...9:
            textFieldState = .isWritten
            ableToEditProfile.value = true
        case 10...:
            textFieldState = .isFull
            ableToEditProfile.value = true
            
        default:
            textFieldState = .isEmpty
            ableToEditProfile.value = false
        }
        
        self.textFieldState.value = textFieldState
    }
    
    func isTextCountExceeded(for type: MyEditTextField.TextFieldType) -> Bool {
        let limit = type.limit
        return editProfileDataOutput.value.nickName.count >= limit
    }
    
    func editCompleteButtonDidTap() {
        patchMyPetProfile()
    }
    
    func deleteButtonDidTap() {
        self.editProfileDataOutput.value.profileImage = nil
        self.editProfileDataOutput.value.hasPhoto = false
    }
    
    func editProfileImageEvent(_ image: UIImage) {
        self.editProfileDataOutput.value.profileImage = image
        self.editProfileDataOutput.value.hasPhoto = true
    }
}

extension MyEditProfileViewModel {
    func patchMyPetProfile() {
        repository.patchMyProfile(request: editProfileDataOutput.value) { result in
            switch result {
            case .success(_):
                self.editCompletedOutput.value = true
                NotificationCenter.default.post(name: .homeVCUpdate, object: nil)
                NotificationCenter.default.post(name: .myPageUpdate, object: nil)
            default:
                self.editCompletedOutput.value = false
            }
        }
    }
}
