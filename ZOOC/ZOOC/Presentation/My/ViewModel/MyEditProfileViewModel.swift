//
//  MyEditProfileViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/08.
//

import UIKit

protocol MyEditProfileModelInput {
    //func viewWillAppearEvent()
    func nameTextFieldDidChangeEvent(_ text: String)
}

protocol MyEditProfileModelOutput {
    var ableToEditProfile: Observable<Bool> { get }
}

final class MyEditProfileViewModel: MyEditProfileModelInput, MyEditProfileModelOutput {
//    func viewWillAppearEvent() {
//        <#code#>
//    }
    
    private var editProfileData = EditProfileRequest()
    var name: String
    var photo: String?
    var ableToEditProfile: Observable<Bool> = Observable(false)

    init(name: String, photo: String?) {
        self.name = name
        self.photo = photo
    }
    
    func viewWillAppear() {
        
    }
    
    func nameTextFieldDidChangeEvent(_ text: String) {
        self.name = text
        self.ableToEditProfile.value = name.hasText
        print("👆\(self.name) 🖕\(name.hasText)")
    }
}
