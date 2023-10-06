//
//  DefaultOnboardingLoginUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/05.
//

import UIKit

import RxSwift
import RxCocoa
import KakaoSDKAuth
import KakaoSDKUser

final class DefaultOnboardingLoginUseCase: OnboardingLoginUseCase {
    
    private let disposeBag = DisposeBag()
    private let repository: OnboardingRepository
    
    init(repository: OnboardingRepository) {
        self.repository = repository
    }
    
    var loginSucceeded = PublishRelay<Bool>()
    var isExistedUser = PublishRelay<Bool>()
    var autoLoginSucceded = PublishRelay<Bool>()
    
    func requestKakaoLogin(_ oauthToken: OAuthToken) {
        repository.postKakaoSocialLogin(accessToken: oauthToken.accessToken) {
            [weak self] result in
            switch result {
            case .success(let data):
                guard let result = data as? OnboardingJWTTokenResult else { return }
                UserDefaultsManager.zoocAccessToken = result.accessToken
                UserDefaultsManager.zoocRefreshToken = result.refreshToken
                self?.loginSucceeded.accept(true)
                self?.checkUserExisted(result.isExistedUser)
            default:
                self?.loginSucceeded.accept(false)
            }
        }
    }
    
    func requestAppleLogin(_ identityTokenString: String) {
        repository.postAppleSocialLogin(
            request: OnboardingAppleSocialLoginRequest(identityTokenString: identityTokenString))  {
            [weak self] result in
            switch result {
            case .success(let data):
                guard let result = data as? OnboardingJWTTokenResult else { return }
                UserDefaultsManager.zoocAccessToken = result.accessToken
                UserDefaultsManager.zoocRefreshToken = result.refreshToken
                self?.loginSucceeded.accept(true)
                self?.checkUserExisted(result.isExistedUser)
            default:
                self?.loginSucceeded.accept(false)
            }
        }
    }
    
    func requestFamilyID() {
        repository.getFamily { [weak self] result in
            switch result {
            case .success(let data):
                guard let result = data as? [OnboardingFamilyResult] else { return }
                if result.count != 0 {
                    let familyID = String(result[0].id)
                    UserDefaultsManager.familyID = familyID
                        self?.requestFCMTokenAPI()
                } else {
                    self?.isExistedUser.accept(false)
                }
            default:
                self?.loginSucceeded.accept(false)
            }
        }
    }
    
    
    func requestFCMTokenAPI() {
        repository.patchFCMToken() { [weak self] result in
            switch result {
            case .success(_):
                self?.autoLoginSucceded.accept(true)
            default:
                self?.autoLoginSucceded.accept(false)
            }
        }
    }
}

extension DefaultOnboardingLoginUseCase {
    func checkUserExisted(_ isExistedUser: Bool) {
        self.isExistedUser.accept(isExistedUser)
        if isExistedUser { requestFamilyID() }
    }
}
