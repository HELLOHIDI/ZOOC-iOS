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
    var registerPetData: BehaviorRelay<[PetResult]> { get }
    
    func requestPetData()
    func registerPet()
}


