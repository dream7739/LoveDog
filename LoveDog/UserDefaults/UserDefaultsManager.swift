//
//  UserDefaultsManager.swift
//  LoveDog
//
//  Created by 홍정민 on 8/15/24.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let storage = UserDefaults.standard
    var key: String
    var defaultValue: T
    var wrappedValue: T {
        get {
            storage.object(forKey: key) as? T ?? defaultValue
        }
        set {
            storage.set(newValue, forKey: key)
        }
    }
}

final class UserDefaultsManager {
    private init() { }
    
    private enum UserDefaultsKey: String {
        case access
        case refresh
    }
    
    @UserDefault(key: UserDefaultsKey.access.rawValue, defaultValue: "")
    static var token
    
    @UserDefault(key: UserDefaultsKey.refresh.rawValue, defaultValue: "")
    static var refresh
    
    static func removeTokens(){
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
}

