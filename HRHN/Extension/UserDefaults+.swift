//
//  UserDefaults.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/28.
//

import Foundation

extension UserDefaults {

    private enum Keys {
        static let isNotiAllowed = "isNotiAllowed"
        static let notiTime = "notiTime"
    }

    class var isNotiAllowed: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.isNotiAllowed)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.isNotiAllowed)
        }
    }
    
    class var notiTime: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.notiTime)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.notiTime)
        }
    }
    
}
