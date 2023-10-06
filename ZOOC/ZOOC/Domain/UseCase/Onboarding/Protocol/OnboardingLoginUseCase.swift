//
//  OnboardingLoginUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/05.
//

import UIKit

import RxSwift
import RxCocoa
import KakaoSDKAuth
import KakaoSDKUser

protocol OnboardingLoginUseCase {
    var loginSucceeded: PublishRelay<Bool> { get }
    var isExistedUser: PublishRelay<Bool> { get }
    var autoLoginSucceded: PublishRelay<Bool> { get }
    
    func requestKakaoLogin(_ oauthToken: OAuthToken)
    func requestAppleLogin(_ identityTokenString: String)
}

