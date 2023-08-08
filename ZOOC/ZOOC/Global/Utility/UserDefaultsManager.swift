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
    case isFirstHome
    case isFirstArchive
    case familyID
}

struct UserDefaultsManager {
    
    @UserDefaultWrapper<String>(key: UserDefaultKeys.fcmToken.rawValue, defaultValue: "")
    static var fcmToken: String
    
    @UserDefaultWrapper<String>(key: UserDefaultKeys.zoocAccessToken.rawValue, defaultValue: "")
    static var zoocAccessToken: String
    
    @UserDefaultWrapper<String>(key: UserDefaultKeys.zoocRefreshToken.rawValue, defaultValue: "")
    static var zoocRefreshToken: String
    
    @UserDefaultWrapper<Bool>(key: UserDefaultKeys.isFirstHome.rawValue, defaultValue: true)
    static var isFirstAttemptArchive: Bool
    
    @UserDefaultWrapper<Bool>(key: UserDefaultKeys.isFirstArchive.rawValue, defaultValue: true)
    static var isFirstAttemptHome: Bool
    
    @UserDefaultWrapper<String>(key: UserDefaultKeys.familyID.rawValue, defaultValue: "")
    static var familyID: String
    
    
}

extension UserDefaultsManager {
    
    static func reset() {
        UserDefaultKeys.allCases.forEach { key in
            if key != .fcmToken &&
                key != .isFirstArchive &&
                key != .isFirstHome {
                UserDefaults.standard.removeObject(forKey: key.rawValue)

            }
        }
    }
}


extension UserDefaultsManager {
    
    public static func validateGuideVCInHome() -> Bool {
        guard UserDefaultsManager.isFirstAttemptHome else {
            UserDefaultsManager.isFirstAttemptHome = true
            return true
        }
       
        return UserDefaultsManager.isFirstAttemptHome
    }
    
    public static func validateGuideVCInArchive() -> Bool {
        guard UserDefaultsManager.isFirstAttemptArchive else {
            UserDefaultsManager.isFirstAttemptArchive = true
            return true
        }
       
        return UserDefaultsManager.isFirstAttemptArchive
    }
}
