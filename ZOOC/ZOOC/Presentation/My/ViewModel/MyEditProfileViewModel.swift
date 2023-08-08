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
    var ableToEditProfile: Observable<Bool> { get }
    var textFieldState: Observable<BaseTextFieldState> { get }
    var textFieldCharacterCount: Observable<Int> { get }
    var editCompletedOutput: Observable<Bool?> { get }
    var editProfileDataOutput: Observable<EditProfileRequest> { get }
}

protocol MyEditNetworkHandlerProtocol {
    func patchMyPetProfile()
}

final class MyEditProfileViewModel: MyEditProfileModelInput, MyEditProfileModelOutput {
    
    var ableToEditProfile: Observable<Bool> = Observable(false)
    var textFieldState: Observable<BaseTextFieldState> = Observable(.isEmpty)
    var textFieldCharacterCount: Observable<Int> = Observable(0)
    var editCompletedOutput: Observable<Bool?> = Observable(nil)
    var editProfileDataOutput: Observable<EditProfileRequest> = Observable(EditProfileRequest())
    
    
    init(editProfileData: EditProfileRequest) {
        self.editProfileDataOutput.value = editProfileData
    }
    
    func nameTextFieldDidChangeEvent(_ text: String) {
        print(#function)
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

extension MyEditProfileViewModel: MyEditNetworkHandlerProtocol {
    func patchMyPetProfile() {
        MyAPI.shared.patchMyProfile(requset: editProfileDataOutput.value) { result in
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
