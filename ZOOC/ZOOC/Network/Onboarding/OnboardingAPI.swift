//
//  OnboardingAPI.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/31.
//

import UIKit
import Moya

final class OnboardingAPI: BaseAPI {
    static let shared = OnboardingAPI()
    var onboardingProvider = MoyaProvider<OnboardingService>(session: Session(interceptor: ZoocInterceptor()),
                                                             plugins: [MoyaLoggingPlugin()])
    override init() {}
}

extension OnboardingAPI {
    
    public func patchFCMToken(fcmToken: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        onboardingProvider.request(.patchFCMToken(fcmToken: fcmToken)) {(result) in
            self.disposeNetwork(result,
                                dataModel: VoidResult.self,
                                completion: completion)
        }
    }
    
    public func postKakaoSocialLogin(accessToken: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        onboardingProvider.request(.postKakaoSocialLogin(accessToken: accessToken)) { (result) in
            self.disposeNetwork(result,
                                dataModel: OnboardingJWTTokenResult.self,
                                completion: completion)
        }
    }
    
    public func postAppleSocialLogin(request: OnboardingAppleSocialLoginRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        onboardingProvider.request(.postAppleSocialLogin(request)) { (result) in
            self.disposeNetwork(result,
                                dataModel: OnboardingJWTTokenResult.self,
                                completion: completion)
        }
    }
    
    public func postRefreshToken(completion: @escaping (NetworkResult<Any>) -> Void) {
        onboardingProvider.request(.postRefreshToken) { result in
            self.disposeNetwork(result,
                                dataModel: OnboardingJWTTokenResult.self,
                                completion: completion)
        }
    }
    
    public func getInviteCode(familyID: String ,completion: @escaping (NetworkResult<Any>) -> Void) {
        onboardingProvider.request(.getInviteCode(familyId: familyID)) { (result) in
            self.disposeNetwork(result,
                                dataModel: OnboardingInviteResult.self,
                                completion: completion)
        }
    }
    
    public func postJoinFamily(requset: OnboardingJoinFamilyRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        onboardingProvider.request(.postJoinFamily(requset)) { (result) in
            self.disposeNetwork(result,
                                dataModel: OnboardingJoinFamilyResult.self,
                                completion: completion)
        }
    }
    
    public func postMakeFamily(request: OnboardingRegisterPetRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        onboardingProvider.request(.makeFamily(request)) { (result) in
            self.disposeNetwork(result,
                                dataModel: OnboardingMakeFamilyResult.self,
                                completion: completion)
        }
    }
    
    public func getFamily(completion: @escaping (NetworkResult<Any>) -> Void) {
        onboardingProvider.request(.getFamily) {(result) in
            self.disposeNetwork(result,
                                dataModel: [OnboardingFamilyResult].self,
                                completion: completion)
        }
    }
    
}
