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
    var petList: BehaviorRelay<[RecordRegisterModel]> { get set }
    var petId: BehaviorRelay<Int?> { get set }
    var canRegisterPet: BehaviorRelay<Bool> { get set }
    var canPushNextView: BehaviorRelay<Bool> { get set }
    func selectPet(at index: Int)
    func pushNextView()
    func getTotalPet()
}

