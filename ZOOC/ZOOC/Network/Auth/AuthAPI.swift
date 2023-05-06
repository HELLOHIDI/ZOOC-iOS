//
//  AuthAPI.swift
//  ZOOC
//
//  Created by 장석우 on 2023/05/05.
//

import Foundation

import Moya

final class AuthAPI: BaseAPI {
    static let shared = AuthAPI()
//    var authProvider = MoyaProvider<AuthService>(session: Session(interceptor: MoyaInterceptor.shared),
//                                                             plugins: [MoyaLoggingPlugin()])
//    
    var authProvider = MoyaProvider<AuthService>(plugins: [MoyaLoggingPlugin()])
}

extension AuthAPI {
    
    public func patchFCMToken(fcmToken: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        authProvider.request(.patchFCMToken(fcmToken: fcmToken)) {(result) in
            self.disposeNetwork(result,
                                dataModel: VoidResult.self,
                                completion: completion)
        }
    }
    
    public func postKakaoSocialLogin(accessToken: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        authProvider.request(.postKakaoSocialLogin(accessToken: accessToken)) { (result) in
            self.disposeNetwork(result,
                                dataModel: OnboardingJWTTokenResult.self,
                                completion: completion)
        }
    }
    
    public func postAppleSocialLogin(request: OnboardingAppleSocialLoginRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        authProvider.request(.postAppleSocialLogin(request)) { (result) in
            self.disposeNetwork(result,
                                dataModel: OnboardingJWTTokenResult.self,
                                completion: completion)
        }
    }
    
    public func postRefreshToken(completion: @escaping (NetworkResult<Any>) -> Void) {
        authProvider.request(.postRefreshToken) { result in
            self.disposeNetwork(result,
                                dataModel: OnboardingJWTTokenResult.self,
                                completion: completion)
        }
    }
}
