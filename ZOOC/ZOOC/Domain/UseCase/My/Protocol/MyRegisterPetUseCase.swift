//
//  MyRegisterPetUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/28.
//

import UIKit

import RxSwift
import RxCocoa

protocol MyRegisterPetUseCase {
    var petMemberData: BehaviorRelay<[PetResult]> { get }
    var ableToRegisterPets: BehaviorRelay<Bool?> { get }
    var isRegistered: BehaviorRelay<Bool?> { get }
    var registerPetData: BehaviorRelay<[MyPetRegisterModel]> { get }
    var addButtonIsHidden: BehaviorRelay<Bool> { get }
    var deleteButtonIsHidden: BehaviorRelay<Bool> { get }
    
    func requestPetData()
    func registerPet()
    func addPet()
    func deletePet(_ index: Int)
    func deleteProfileImage(_ index: Int)
    func selectProfileImage(_ data: (UIImage, Int))
    func updatePetName(_ data: (String, Int))
}


