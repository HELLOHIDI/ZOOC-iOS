//
//  RecordSelectPetUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/03.
//

import UIKit

import RxSwift
import RxCocoa

protocol RecordSelectPetUseCase {
    var petList: BehaviorRelay<[RecordRegisterModel]> { get }
    var ableToRecord: BehaviorRelay<Bool> { get }
    var isRegistered: BehaviorRelay<Bool?> { get }
    var photo: BehaviorRelay<UIImage?> { get }
    var content: BehaviorRelay<String?> { get }
    
    func selectPet(at index: Int)
    func getTotalPet()
    func postRecord()
}

