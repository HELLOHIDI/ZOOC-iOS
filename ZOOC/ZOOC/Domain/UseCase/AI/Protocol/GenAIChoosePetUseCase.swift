//
//  GenAIRegisterPetUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/09.
//

import Foundation

import RxSwift
import RxCocoa

protocol GenAIChoosePetUseCase {
    var petList: BehaviorRelay<[RecordRegisterModel]> { get }
    var petId: BehaviorRelay<Int?> { get }
    var canRegisterPet: BehaviorRelay<Bool> { get }
    var canPushNextView: BehaviorRelay<Bool> { get }
    func selectPet(at index: Int)
    func pushNextView()
    func getTotalPet()
}

