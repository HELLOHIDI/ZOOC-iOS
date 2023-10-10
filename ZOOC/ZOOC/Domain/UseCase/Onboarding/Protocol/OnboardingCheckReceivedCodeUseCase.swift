//
//  OnboardingCheckReceivedCodeUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/06.
//

import RxSwift
import RxCocoa

protocol OnboardingCheckReceivedCodeUseCase {
    var makeFamilySucceeded: PublishRelay<Bool> { get }
    
    func makeFamily()
}
