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
//            return UserDefaultsManager.zoocAccessToken ?? ""
            return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTY3MzQ2MzMxMiwiZXhwIjoyMDAwMDAwMDAwfQ.z5cpzI9uwDwbThC9XqoGX0Z1YKSdpMc7AWL393dc8wc"
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


