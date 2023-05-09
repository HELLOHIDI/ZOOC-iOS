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
final class ZoocInterceptor: RequestInterceptor {
    
    static let shared = ZoocInterceptor()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        let headersKey = urlRequest.allHTTPHeaderFields?.keys
        var url = urlRequest.url
        var kakaoURL = URL(string: (Bundle.main.infoDictionary?["BASE_URL"] as! String) + URLs.kakaoLogin)
        
        guard headersKey != APIConstants.noTokenHeader.keys,
                url != kakaoURL
        else {
            print("🦫 ZoocAccessToken을 사용하지 않는 API입니다. Adapt를 수행하지 않습니다.")
            completion(.success(urlRequest))
            return
        }
        
        print("🦫 Header값을 'User.shared.zoocAccessToken'으로 Adapt를 수행합니다!")
        var request = urlRequest
        request.setValue(User.shared.zoocAccessToken, forHTTPHeaderField: APIConstants.auth)
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("👽 BaseTargetType의 ValidationType에 막혔습니다.")
        print("👽 API: \(request)")
        guard let response = request.task?.response as? HTTPURLResponse,
                response.statusCode == 401
        else {
            print("retry를 하지 않습니다.")
            completion(.doNotRetryWithError(error))
            return
        }
        
        print("👽 Retry함수에서 가드문을 통과했습니다. 이는 서버로부터 401을 반환된 것을 의미합니다.")
        print("👽 AccessToken이 만료되었으니 refreshAPI를 호출합니다.")
        
        AuthAPI.shared.postRefreshToken { result in
            print("👽 postRefreshTokenAPI 서버 응답이 도착했습니다.")
            switch result {
            case .success(let data):
                
                guard let data = data as? OnboardingJWTTokenResult else { return }
                User.shared.zoocAccessToken = data.accessToken
                User.shared.zoocRefreshToken = data.refreshToken
                print("👽 401을 받은 API를 재호출합니다❗️")
                completion(.retry) // 401을 받은 API를 재호출합니다.
                
            case .authorizationFail(let data):
                guard let data = data as? (String, Int) else { return }
                print(data)
                print("👽 StatusCode: 406을 반환받았습니다. 이는 모든 토큰이 만료됐음을 뜻합니다.")
                completion(.doNotRetryWithError(error))
            default:
                print("👽 default에 들어왔습니다. default에 들어오지 않게 추후 분기처리 할게요.")
                completion(.doNotRetryWithError(error))
            }
            
        }
    }
}
        
