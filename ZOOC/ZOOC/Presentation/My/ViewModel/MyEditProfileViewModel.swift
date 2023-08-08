//
//  MyEditProfileViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/08.
//

import UIKit

protocol MyEditProfileModelInput {
    func nameTextFieldDidChangeEvent(_ text: String)
}

protocol MyEditProfileModelOutput {
    var ableToEditProfile: Observable<Bool> { get }
}

final class MyEditProfileViewModel: MyEditProfileModelInput, MyEditProfileModelOutput {
    
    private var name: String
    private var image: String?
    var ableToEditProfile: Observable<Bool> = Observable(false)

    init(name: String, image: String?) {
        self.name = name
        self.image = image
    }
    
    func nameTextFieldDidChangeEvent(_ text: String) {
        self.name = text
        self.ableToEditProfile.value = name.hasText
        print("👆\(self.name) 🖕\(name.hasText)")
    }
}
