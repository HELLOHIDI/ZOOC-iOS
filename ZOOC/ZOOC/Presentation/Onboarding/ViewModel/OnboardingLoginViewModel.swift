//
//  OnboardingLoginViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/05.
//


import UIKit

import RxSwift
import RxCocoa
import KakaoSDKAuth
import KakaoSDKUser

final class OnboardingLoginViewModel: ViewModelType {
    private let onboardingLoginUseCase: OnboardingLoginUseCase
    
    init(onboardingLoginUseCase: OnboardingLoginUseCase) {
        self.onboardingLoginUseCase = onboardingLoginUseCase
    }
    
    struct Input {
        let kakaoLoginButtonDidTapEvent: Observable<Void>
        let receiveAppleIdentityTokenEvent: Observable<String>
    }
    
    struct Output {
        var loginSucceeded = PublishRelay<Bool>()
        var isExistedUser = PublishRelay<Bool>()
        var autoLoginSucceeded = PublishRelay<Bool>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.kakaoLoginButtonDidTapEvent.subscribe(with: self, onNext: { owner, _ in
            
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                    guard let oauthToken = oauthToken else {
                        guard let error = error else { return }
                        print(error)
                        return
                    }
                    owner.onboardingLoginUseCase.requestKakaoLogin(oauthToken)
                }
            } else {
                UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    guard let oauthToken = oauthToken else {
                        guard let error = error else { return }
                        print(error)
                        return
                    }
                    owner.onboardingLoginUseCase.requestKakaoLogin(oauthToken)
                }
            }
        }).disposed(by: disposeBag)
        
        input.receiveAppleIdentityTokenEvent.subscribe(with: self, onNext: { owner, identityToken in
            owner.onboardingLoginUseCase.requestAppleLogin(identityToken)
        }).disposed(by: disposeBag)
        
        
        return output
    }
    
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        onboardingLoginUseCase.loginSucceeded.subscribe(onNext: { loginSucceeded in
            output.loginSucceeded.accept(loginSucceeded)
        }).disposed(by: disposeBag)
        
        onboardingLoginUseCase.isExistedUser.subscribe(onNext: { isExistedUser in
            output.isExistedUser.accept(isExistedUser)
        }).disposed(by: disposeBag)
        
        onboardingLoginUseCase.autoLoginSucceded.subscribe { autoLoginSucceeded in
            output.autoLoginSucceeded.accept(autoLoginSucceeded)
        }.disposed(by: disposeBag)
    }
}

