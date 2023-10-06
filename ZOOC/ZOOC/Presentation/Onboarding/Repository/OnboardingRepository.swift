//
//  OnboardingRepository.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/05.
//

import Foundation

protocol OnboardingRepository {
    func postKakaoSocialLogin(accessToken: String, completion: @escaping (NetworkResult<Any>) -> Void)
    func postAppleSocialLogin(request: OnboardingAppleSocialLoginRequest, completion: @escaping (NetworkResult<Any>) -> Void)
    func getFamily(completion: @escaping (NetworkResult<Any>) -> Void)
    func patchFCMToken(completion: @escaping (NetworkResult<Any>) -> Void)
    func postMakeFamily(completion: @escaping (NetworkResult<Any>) -> Void)
    func postJoinFamily(request: OnboardingJoinFamilyRequest, completion: @escaping (NetworkResult<Any>) -> Void)
}

class DefaultOnboardingRepository: OnboardingRepository {
    func postKakaoSocialLogin(accessToken: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        OnboardingAPI.shared.postKakaoSocialLogin(accessToken: "Bearer \(accessToken)", completion: completion)
    }
    
    func postAppleSocialLogin(request: OnboardingAppleSocialLoginRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        OnboardingAPI.shared.postAppleSocialLogin(request: request, completion: completion)
    }
    
    func getFamily(completion: @escaping (NetworkResult<Any>) -> Void) {
        OnboardingAPI.shared.getFamily(completion: completion)
    }
    
    func patchFCMToken(completion: @escaping (NetworkResult<Any>) -> Void) {
        OnboardingAPI.shared.patchFCMToken(fcmToken: UserDefaultsManager.fcmToken, completion: completion)
    }
    
    func postMakeFamily(completion: @escaping (NetworkResult<Any>) -> Void) {
        OnboardingAPI.shared.postMakeFamily(completion: completion)
    }
    
    func postJoinFamily(request: OnboardingJoinFamilyRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        OnboardingAPI.shared.postJoinFamily(request: request, completion: completion)
    }
}

