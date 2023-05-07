//
//  User.swift
//  ZOOC
//
//  Created by 장석우 on 2023/01/12.
//

import Foundation

enum UserType {
    case active
    case inactive
    case visitor
}

struct User {
    static var shared = User()
    private init() {}
    
    var familyID: String {
        get {
            UserDefaultsManager.familyID ?? ""
        }
        set {
            UserDefaultsManager.familyID = newValue
        }
    }
    var zoocAccessToken: String {
        get {
            print(Thread.current)
            return UserDefaultsManager.zoocAccessToken ?? ""
        }
        set {
            UserDefaultsManager.zoocAccessToken = newValue
        }
    }
    
    var zoocRefreshToken: String {
        get {
            UserDefaultsManager.zoocRefreshToken ?? ""
        }
        set {
            UserDefaultsManager.zoocRefreshToken = newValue
        }
    }
    var fcmToken: String {
        get {
            UserDefaultsManager.fcmToken ?? ""
        }
        set {
            UserDefaultsManager.fcmToken = newValue
        }
    }
    
    public mutating func clearData() {
        UserDefaultsManager.reset()
    }
}


