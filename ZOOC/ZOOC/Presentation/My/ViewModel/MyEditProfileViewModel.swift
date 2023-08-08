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
}

final class MyEditProfileViewModel: MyEditProfileModelInput, MyEditProfileModelOutput {
    var name: String
    var photo: UIImage?
    var hasPhoto: Bool
    var ableToEditProfile: Observable<Bool> = Observable(true)
    
    init(name: String,
         photo: UIImage?,
         hasPhoto: Bool) {
        self.name = name
        self.photo = photo
        self.hasPhoto = hasPhoto
    }
    
    func nameTextFieldDidChangeEvent(_ text: String) {
        self.name = text
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
