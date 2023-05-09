//
//  AuthServide.swift
//  ZOOC
//
//  Created by 장석우 on 2023/05/05.
//

import Foundation

import Moya


enum AuthService {
    case patchFCMToken(fcmToken: String)
    case postKakaoSocialLogin(accessToken: String)
    case postAppleSocialLogin(_ request: OnboardingAppleSocialLoginRequest)
    case postRefreshToken
}

extension AuthService: BaseTargetType {
    var path: String {
        switch self {
        case .patchFCMToken:
            return URLs.fcmToken
            
        case .postKakaoSocialLogin:
            return URLs.kakaoLogin
            
        case .postAppleSocialLogin:
            return URLs.appleLogin
            
        case .postRefreshToken:
            return URLs.refreshToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postKakaoSocialLogin:
            return .post
        case .postAppleSocialLogin:
            return .post
        case .postRefreshToken:
            return .post
        case .patchFCMToken:
            return .put
        }
    }
    
    
    var task: Task {
        switch self {
            
        case .patchFCMToken(fcmToken: let fcmToken):
            return .requestParameters(parameters: ["fcmToken": fcmToken],
                                      encoding: JSONEncoding.default)
            
        case .postKakaoSocialLogin:
            return .requestPlain
            
        case .postAppleSocialLogin(let param):
            return .requestJSONEncodable(param)
            
        case .postRefreshToken:
            return .requestPlain
        }
        
    }
    
    var headers: [String : String]?{
        switch self {
            
        case .patchFCMToken:
            return APIConstants.hasTokenHeader
            
        case .postKakaoSocialLogin(accessToken: let accessToken):
            return [APIConstants.contentType: APIConstants.applicationJSON,
                    APIConstants.auth : accessToken]
            
        case .postAppleSocialLogin(param: _):
            return APIConstants.noTokenHeader
            
        case .postRefreshToken:
            return APIConstants.refreshHeader
            
        }
    }
}

