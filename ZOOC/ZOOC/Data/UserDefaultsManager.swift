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
    case isActiveUser
    case familyID
}

struct UserDefaultsManager {
    @UserDefaultWrapper<String>(key: UserDefaultKeys.fcmToken.rawValue)
    static var fcmToken: String?
    
    @UserDefaultWrapper<String>(key: UserDefaultKeys.zoocAccessToken.rawValue)
    static var zoocAccessToken: String?
    
    @UserDefaultWrapper<String>(key: UserDefaultKeys.zoocRefreshToken.rawValue)
    static var zoocRefreshToken: String?
    
    @UserDefaultWrapper<Bool>(key: UserDefaultKeys.isActiveUser.rawValue)
    static var isActiveUser: Bool?
    
    @UserDefaultWrapper<String>(key: UserDefaultKeys.familyID.rawValue)
    static var familyID: String?
}

extension UserDefaultsManager {
    
    static func reset() {
        UserDefaultKeys.allCases.forEach { key in
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
    }
}


extension UserDefaultsManager {
    static func getUserType() -> UserType {
        guard zoocAccessToken != nil else {
            return UserType.visitor
        }
        
        return getUserActivation() ? UserType.active: UserType.inactive
    }
    
    public static func getUserActivation() -> Bool {
        UserDefaultsManager.isActiveUser ?? false
    }
}
