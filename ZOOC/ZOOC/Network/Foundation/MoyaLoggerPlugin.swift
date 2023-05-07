//
//  MoyaLoggerPlugin.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/31.
//

import UIKit

import Moya

final class MoyaLoggingPlugin: PluginType {
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        print("🦫 \(#function)")
        return request
    }
    // Request를 보낼 때 호출
    func willSend(_ request: RequestType, target: TargetType) {
        print("🦫 \(#function)")
        guard let httpRequest = request.request else {
            print("--> 유효하지 않은 요청")
            return
        }
        
        let url = httpRequest.description
        let method = httpRequest.httpMethod ?? "메소드값이 nil입니다."
        var log = """
                  ⎡---------------------서버통신을 시작합니다.----------------------⎤
                  [\(method)] \(url)
                  API: \(target) \n
                  """
        if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
            log.append("header:\n \(headers) \n")
        }
        if let body = httpRequest.httpBody, let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
            log.append("\(bodyString)\n")
        }
        
        log.append("⎣------------------ Request END  -------------------------⎦")
        print(log)
    }
    // Response가 왔을 때
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        print("🦫 \(#function)")
        switch result {
        case let .success(response):
            onSucceed(response, target: target, isFromError: false)
        case let .failure(error):
            onFail(error, target: target)
        }
    }
    
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        print("🦫 \(#function)")
        return result
    }
    
    func onSucceed(_ response: Response, target: TargetType, isFromError: Bool) {
        print("🦫🦫 \(#function)")
        let request = response.request
        let url = request?.url?.absoluteString ?? "nil"
        let statusCode = response.statusCode
        var log = "⎡------------------서버에게 Response가 도착했습니다. ------------------⎤\n"
        log.append("API: \(target)\n")
        log.append("Status Code: [\(statusCode)]\n")
        log.append("URL: \(url)\n")
        if let responseData = String(bytes: response.data, encoding: String.Encoding.utf8) {
            log.append("Data: \n  \(responseData)\n")
        }
        log.append("⎣------------------ END HTTP (\(response.data.count)-byte body) ------------------⎦")
        print(log)
        
//        switch statusCode {
//        case 401:
//            let acessToken = User.shared.zoocAccessToken
//            let refreshToken = User.shared.zoocRefreshToken
//            // 🔥 토큰 갱신 서버통신 메서드.
//            requestAccessExpiredRefreshAPI(accessToken: acessToken, refreshToken: refreshToken)
//        default:
//            return
//        }
    }
    
    func onFail(_ error: MoyaError, target: TargetType) {
        print("🦫🦫 \(#function)")
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
//
//extension MoyaLoggingPlugin {
//    func requestAccessExpiredRefreshAPI(accessToken: String,refreshToken: String) {
//        print("🦫 \(#function)")
//        OnboardingAPI.shared.postRefreshToken() { response in
//            print("🙏")
//                switch response {
//                case .success(let data):
//                    print("🙏🙏")
//                    // 🔥 성공적으로 액세스 토큰, 리프레쉬 토큰 갱신.
//                    if let data = data as? OnboardingJWTTokenResult {
//                        User.shared.zoocAccessToken = data.accessToken
//                        User.shared.zoocRefreshToken = data.refreshToken
//                        print("userTokenReissueWithAPI - success")
//                    }
//                case .requestErr(let statusCode):
//                    // 🔥 406 일 경우, 리프레쉬 토큰도 만료되었다고 판단.
//                    print("🙏🙏🙏")
//                    if let statusCode = statusCode as? Int, statusCode == 406 {
//                        print("🙏🙏🙏🙏")
//                        // 🔥 로그인뷰로 화면전환. 액세스 토큰, 리프레쉬 토큰, userID 삭제.
//                        let loginVC = OnboardingLoginViewController()
//                        UserDefaultsManager.zoocAccessToken = nil
//                        UserDefaultsManager.zoocRefreshToken = nil
//                        UIApplication.shared.changeRootViewController(loginVC)
//                        
//                    }
//                    print("userTokenReissueWithAPI - requestErr: \(statusCode)")
//                case .pathErr:
//                    print("userTokenReissueWithAPI - pathErr")
//                case .serverErr:
//                    print("userTokenReissueWithAPI - serverErr")
//                case .networkFail:
//                    print("userTokenReissueWithAPI - networkFail")
//                case .decodedErr:
//                    print("디코딩 오류")
//                    
//                case .authorizationFail(_):
//                    print("인증오류")
//                }
//            
//            print("🙏🙏🙏🙏🙏🙏")
//            }
//        }
//}
//
