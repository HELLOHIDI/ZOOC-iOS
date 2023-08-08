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
        
}

final class MyEditProfileViewModel: MyEditProfileModelInput, MyEditProfileModelOutput {
    var name: String
    var photo: UIImage?
    var hasPhoto: Bool
    
    var ableToEditProfile: Observable<Bool> = Observable(true)
    var textFieldState: Observable<BaseTextFieldState> = Observable(.isEmpty)
    var textFieldCharacterCount: Observable<Int> = Observable(0)
    
    init(name: String,
         photo: UIImage?,
         hasPhoto: Bool) {
        self.name = name
        self.photo = photo
        self.hasPhoto = hasPhoto
    }
    
    func nameTextFieldDidChangeEvent(_ text: String) {
        print(#function)
        self.name = text
        var textFieldState: BaseTextFieldState
        switch text.count {
        case 1...9:
            textFieldState = .isWritten
        case 10...:
            textFieldState = .isFull
            
        default:
            textFieldState = .isEmpty
        }
        
        // 상태 변경 후 옵저버 호출
        self.textFieldState.value = textFieldState
    }
    
    func isTextCountExceeded(for type: MyEditTextField.TextFieldType) -> Bool {
        print(#function)
        let limit = type.limit
        print("🦖 \(limit)")
        return name.count >= limit
    }

   
    func editCompleteButtonDidTap() {
        if ableToEditProfile.value {
            let editProfileData = EditProfileRequest(
                hasPhoto: hasPhoto,
                nickName: name,
                profileImage: photo
            )
        }
    }
    
    func deleteButtonDidTap() {
        self.photo = nil
        self.hasPhoto = false
    }
    
    func editProfileImageEvent(_ image: UIImage) {
        self.photo = image
        self.hasPhoto = true
    }
}
