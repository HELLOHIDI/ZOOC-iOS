//
//  MoyaLoggerPlugin.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/31.
//

import UIKit

import Moya

final class MoyaLoggingPlugin: PluginType {
    // Request를 보낼 때 호출
    func willSend(_ request: RequestType, target: TargetType) {
        guard let httpRequest = request.request else {
            print("--> 유효하지 않은 요청")
            return
        }
        let url = httpRequest.description
        let method = httpRequest.httpMethod ?? "unknown method"
        var log = "----------------------------------------------------\n\n[\(method)] \(url)\n\n----------------------------------------------------\n"
        log.append("API: \(target)\n")
        if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
            log.append("header: \(headers)\n")
        }
        if let body = httpRequest.httpBody, let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
            log.append("\(bodyString)\n")
        }
        log.append("------------------- END \(method) --------------------------")
        print(log)
    }
    // Response가 왔을 때
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(response):
            onSucceed(response, target: target, isFromError: false)
        case let .failure(error):
            onFail(error, target: target)
        }
    }
    
    func onSucceed(_ response: Response, target: TargetType, isFromError: Bool) {
        let request = response.request
        let url = request?.url?.absoluteString ?? "nil"
        let statusCode = response.statusCode
        var log = "------------------- 네트워크 통신 성공 -------------------"
        log.append("\n[\(statusCode)] \(url)\n----------------------------------------------------\n")
        log.append("API: \(target)\n")
//        response.response?.allHeaderFields.forEach {
//            log.append("\($0): \($1)\n")
//        }
        if let reString = String(bytes: response.data, encoding: String.Encoding.utf8) {
            log.append("\(reString)\n")
        }
        log.append("------------------- END HTTP (\(response.data.count)-byte body) -------------------")
        print(log)
        
        switch statusCode {
        case 401:
            let acessToken = User.shared.zoocAccessToken
            let refreshToken = User.shared.zoocRefreshToken
            // 🔥 토큰 갱신 서버통신 메서드.
            userTokenReissueWithAPI(accessToken: acessToken, refreshToken: refreshToken)
        default:
            return
        }
    }
    
    func onFail(_ error: MoyaError, target: TargetType) {
        if let response = error.response {
            onSucceed(response, target: target, isFromError: true)
            return
        }
        var log = "네트워크 오류"
        log.append("<-- \(error.errorCode) \(target)\n")
        log.append("\(error.failureReason ?? error.errorDescription ?? "unknown error")\n")
        log.append("<-- END HTTP")
        print(log)
    }
}

extension MoyaLoggingPlugin {
    func userTokenReissueWithAPI(accessToken: String,refreshToken: String) {
        OnboardingAPI.shared.postRefreshToken(accessToken: accessToken, refreshToken: refreshToken) { response in
                switch response {
                case .success(let data):
                    // 🔥 성공적으로 액세스 토큰, 리프레쉬 토큰 갱신.
                    if let data = data as? OnboardingJWTTokenResult {
                        User.shared.zoocAccessToken = data.accessToken
                        User.shared.zoocRefreshToken = data.refreshToken
                        print("userTokenReissueWithAPI - success")
                    }
                case .requestErr(let statusCode):
                    // 🔥 406 일 경우, 리프레쉬 토큰도 만료되었다고 판단.
                    if let statusCode = statusCode as? Int, statusCode == 406 {
                        // 🔥 로그인뷰로 화면전환. 액세스 토큰, 리프레쉬 토큰, userID 삭제.
                        let loginVC = OnboardingLoginViewController()
                        UIApplication.shared.changeRootViewController(loginVC)
                        
                        UserDefaultsManager.zoocAccessToken = nil
                        UserDefaultsManager.zoocRefreshToken = nil
                    }
                    print("userTokenReissueWithAPI - requestErr: \(statusCode)")
                case .pathErr:
                    print("userTokenReissueWithAPI - pathErr")
                case .serverErr:
                    print("userTokenReissueWithAPI - serverErr")
                case .networkFail:
                    print("userTokenReissueWithAPI - networkFail")
                case .decodedErr:
                    print("디코딩 오류")
                    
                }
            }
        }
}

