//
//  AuthError.swift
//  ZOOC
//
//  Created by 장석우 on 2023/05/20.
//

import Foundation

enum AuthError: Error {
    case tokenExpired
}

extension AuthError: CustomNSError {
    var errorUserInfo: [String : Any] {
        func getDebugDescription() -> String {
            switch self {
            case .tokenExpired:
                return  "tokenExpired"
            }
        }

        return [NSDebugDescriptionErrorKey: getDebugDescription()]
    }
}
