//
//  OnboardingService.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/31.
//

import Foundation

import Moya
import UIKit

enum OnboardingService {
    case patchFCMToken(fcmToken: String)
    case postKakaoSocialLogin(accessToken: String)
    case postAppleSocialLogin(_ request: OnboardingAppleSocialLoginRequest)
    case postRefreshToken
    case getFamily
    case getInviteCode(familyId: String)
    case postJoinFamily(_ request: OnboardingJoinFamilyRequest)
    case makeFamily
}

extension OnboardingService: BaseTargetType {
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
            
        case .getInviteCode(let familyId):
            return URLs.getInviteCode.replacingOccurrences(of: "{familyId}", with: familyId)
            
        case .postJoinFamily:
            return URLs.joinFamily
            
        case .makeFamily:
            return URLs.makeFamily
            
        case .getFamily:
            return URLs.getFamily
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
        case .getInviteCode:
            return .get
        case .postJoinFamily:
            return .post
        case .makeFamily:
            return .post
        case .getFamily:
            return .get
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
            
        case .getInviteCode:
            return .requestPlain
            
        case .postJoinFamily(let param):
            return .requestJSONEncodable(param)
            
            
        case .makeFamily:
            return .requestPlain
            
        case .getFamily:
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
            
        case .getInviteCode(familyId: _):
            return APIConstants.hasTokenHeader
            
        case .postJoinFamily(param: _):
            return APIConstants.hasTokenHeader
            
        case .makeFamily:
            return APIConstants.multipartHeader
            
        case .getFamily:
            print("겟 패밀리의 헤더를 가져옵니다요")
            return APIConstants.hasTokenHeader
        }
    }
    
}
