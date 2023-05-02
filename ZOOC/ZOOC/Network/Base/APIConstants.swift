//
//  APIConstants.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/31.
//

import Foundation
import Moya

struct APIConstants{
    
    static let contentType = "Content-Type"
    static let applicationJSON = "application/json"
    static let multipartFormData = "multipart/form"
    static let auth = "Authorization"
    static let refresh = "RefreshToken"
    static let fcm = "FcmToken"
    
}

extension APIConstants{
    static let noTokenHeader = [contentType: applicationJSON]
    static let hasTokenHeader = [contentType: applicationJSON,
                                       auth : User.shared.zoocAccessToken]
    static let multipartHeader = [contentType: multipartFormData,
                                        auth : User.shared.zoocAccessToken]
    static let refreshHeader = [contentType: multipartFormData,
                                      auth : User.shared.zoocAccessToken,
                                    refresh: User.shared.zoocRefreshToken,
                                        fcm: User.shared.fcmToken]
}
