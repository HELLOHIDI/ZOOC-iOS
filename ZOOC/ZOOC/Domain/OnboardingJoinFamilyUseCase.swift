//
//  OnboardingJoinFamilyUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/06.
//

import UIKit

import RxSwift
import RxCocoa

protocol OnboardingJoinFamilyUseCase {
    var enteredFamilyCode: BehaviorRelay<String?> { get }
    var ableToCheckFamilyCode: PublishRelay<Bool> { get }
    var errMessage: BehaviorRelay<String?> { get }
    var isJoinedFamily: PublishRelay<Bool> { get }

    func updateEnteredFamilyCode(_ text: String)
    func joinFamily()
}

