//
//  Intercepter.swift
//  ZOOC
//
//  Created by 장석우 on 2023/05/05.
//

import Foundation

import Alamofire
import Moya
import UIKit

///// 토큰 만료 시 자동으로 refresh를 위한 서버 통신
final class MoyaInterceptor: RequestInterceptor {
    
    static let shared = MoyaInterceptor()
    
    private init() {}
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("🤡 \(#function)")
        print("adapt에서 갱신된 access: \(User.shared.zoocAccessToken)")
        print("adapt에서 갱신된 refresh: \(User.shared.zoocRefreshToken)")
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("🤡 \(#function)")
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401, let pathComponents = request.request?.url?.pathComponents,
              !pathComponents.contains("getNewToken")
        else {
            print("\(#function)에서 가드문을 통과 못함")
            completion(.doNotRetryWithError(error))
            return
        }
        print("\(#function)에서 가드문을 통과함!! 401 받았다는 뜻이겠져?")
        
        AuthAPI.shared.postRefreshToken { result in
            switch result {
            case .success(let data):
                print("👽 success")
                guard let data = data as? OnboardingJWTTokenResult else { return }
                User.shared.zoocAccessToken = data.accessToken
                User.shared.zoocRefreshToken = data.refreshToken
                print("갱신된 access: \(data.accessToken)")
                print("갱신된 refresh: \(data.refreshToken)")
                //UIApplication.shared.changeRootViewController(OnboardingLoginViewController())
                print("재시도 할게~")
                completion(.retry)
            case .authorizationFail(let data):
                guard let data = data as? (String, Int) else { return }
                print(data)
                print("👽 authorizationFail")
                completion(.doNotRetryWithError(error))
            default:
                print("👽 default")
                completion(.doNotRetryWithError(error))
            }
            
        }
    }
}
        
