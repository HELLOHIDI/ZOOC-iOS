//
//  UserDefaultWrapper.swift
//  ZOOC
//
//  Created by 장석우 on 2023/04/26.
//

import Foundation

@propertyWrapper
struct UserDefaultWrapper<T> {
    
    
    private let key: String
    
    var wrappedValue: T? {
        get {
            return UserDefaults.standard.object(forKey: self.key) as? T
        }
        
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: key)
            } else {
                UserDefaults.standard.setValue(newValue, forKey: key)
            }
        }
    }
    
    init(key: String) {
        self.key = key
    }
}
