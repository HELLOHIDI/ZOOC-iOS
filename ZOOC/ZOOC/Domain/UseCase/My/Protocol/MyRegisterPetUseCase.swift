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
    var ableToRegisterPet: BehaviorRelay<Bool?> { get }
    var isRegistered: PublishRelay<Bool> { get }
    var petName: BehaviorRelay<String> { get }
    var petBreed: BehaviorRelay<String> { get }
    
    func registerPet()
    func updatePetName(_ name: String)
    func updatePetBreed(_ breed: String)
}
