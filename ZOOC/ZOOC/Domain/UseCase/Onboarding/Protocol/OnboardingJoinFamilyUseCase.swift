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
    var enteredCode: BehaviorRelay<String> { get }
    var ableToCheckCode: PublishRelay<Bool> { get }
    var errMessage: BehaviorRelay<String?> { get }
    
    func updateEnteredCode(_ text: String)
    func joinFamily()
}
