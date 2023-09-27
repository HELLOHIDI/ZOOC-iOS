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
    
    init(petProfileData: EditPetProfileRequest?, repository: MyRepository) {
        self.name.accept(petProfileData?.nickName)
        self.petProfileData.accept(petProfileData)
        self.repository = repository
    }
    
    var id = BehaviorRelay<Int?>(value: nil)
    var name = BehaviorRelay<String?>(value: nil)
    var petProfileData = BehaviorRelay<EditPetProfileRequest?>(value: nil)
    var textFieldState = BehaviorRelay<BaseTextFieldState>(value: .isEmpty)
    var ableToEditProfile = BehaviorRelay<Bool>(value: false)
    var isTextCountExceeded = BehaviorRelay<Bool>(value: false)
    var isEdited = BehaviorRelay<Bool?>(value: nil)
    
    func editProfile(_ image: UIImage? = nil) {
        guard let profile = petProfileData.value else { return }
        guard let id = id.value else { return }
            repository.patchPetProfile(request: profile, id: id, completion: { [weak self] result in
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
        guard let name = self.name.value else { return }
        self.isTextCountExceeded.accept(name.count >= limit)
    }
    
    func nameTextFieldDidChangeEvent(_ text: String?) {
        guard let name = text else { return }
        self.name.accept(name)
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
}

