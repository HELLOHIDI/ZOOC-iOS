//
//  UserDefaultKeyList.swift
//  ZOOC
//
//  Created by 장석우 on 2023/04/26.
//

import Foundation

enum UserDefaultKeys: String, CaseIterable {
    case fcmToken
    case zoocAccessToken
    case zoocRefreshToken
    case isFirstUser
    case familyID
}

struct UserDefaultsManager {
    @UserDefaultWrapper<String>(key: UserDefaultKeys.fcmToken.rawValue)
    static var fcmToken: String?
    
    @UserDefaultWrapper<String>(key: UserDefaultKeys.zoocAccessToken.rawValue)
    static var zoocAccessToken: String?
    
    @UserDefaultWrapper<String>(key: UserDefaultKeys.zoocRefreshToken.rawValue)
    static var zoocRefreshToken: String?
    
    @UserDefaultWrapper<Bool>(key: UserDefaultKeys.isFirstUser.rawValue)
    static var isFirstUser: Bool?
    
    @UserDefaultWrapper<String>(key: UserDefaultKeys.familyID.rawValue)
    static var familyID: String?
    
    
}

extension UserDefaultsManager {
    
    static func reset() {
        UserDefaultKeys.allCases.forEach { key in
            if key != .fcmToken{
                UserDefaults.standard.removeObject(forKey: key.rawValue)
            }
        }
    }
}


extension UserDefaultsManager {

    //    SOPT iOS 코드
//    static func getUserType() -> UserType {
//        guard zoocAccessToken != nil else {
//            return UserType.visitor
//        }
//
//        return getUserActivation() ? UserType.active: UserType.inactive
//    }
    
    public static func checkFirstUser() -> Bool {
        guard let isFirstUser = UserDefaultsManager.isFirstUser else {
            UserDefaultsManager.isFirstUser = true
            return true
        }
       
        return isFirstUser
    }
}
