//
//  UserDefaultKeyList.swift
//  ZOOC
//
//  Created by 장석우 on 2023/04/26.
//

import Foundation

enum UserDefaultKeys: String, CaseIterable {
    case userID
    case fcmToken
    case zoocAccessToken
    case zoocRefreshToken
    case isFirstHome
    case isFirstArchive
    case familyID
}

struct UserDefaultsManager {
    
    @UserDefaultWrapper<Int>(key: UserDefaultKeys.userID.rawValue)
    static var userID: Int?
    
    @UserDefaultWrapper<String>(key: UserDefaultKeys.fcmToken.rawValue)
    static var fcmToken: String?
    
    @UserDefaultWrapper<String>(key: UserDefaultKeys.zoocAccessToken.rawValue)
    static var zoocAccessToken: String?
    
    @UserDefaultWrapper<String>(key: UserDefaultKeys.zoocRefreshToken.rawValue)
    static var zoocRefreshToken: String?
    
    @UserDefaultWrapper<Bool>(key: UserDefaultKeys.isFirstHome.rawValue)
    static var isFirstAttemptArchive: Bool?
    
    @UserDefaultWrapper<Bool>(key: UserDefaultKeys.isFirstArchive.rawValue)
    static var isFirstAttemptHome: Bool?
    
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
    public static func checkAuthor(authorID: Int) -> Bool {
        return UserDefaultsManager.userID == userID
    }
    
    
    public static func validateGuideVCInHome() -> Bool {
        guard let isFirstUser = UserDefaultsManager.isFirstAttemptHome else {
            UserDefaultsManager.isFirstAttemptHome = true
            return true
        }
       
        return isFirstUser
    }
    
    public static func validateGuideVCInArchive() -> Bool {
        guard let isFirstUser = UserDefaultsManager.isFirstAttemptArchive else {
            UserDefaultsManager.isFirstAttemptArchive = true
            return true
        }
       
        return isFirstUser
    }
}
