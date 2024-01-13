//
//  UserDefaultsService.swift
//  MyMusic
//
//  Created by JUNHYEOK LEE on 1/13/24.
//

import Foundation

extension UserDefaultsKey {
    static var musicAuthorization: Key<Bool> { return "musicAuth" }
}

final class UserDefaultService: UserDefaultServiceType {
    private var defaults = UserDefaults.standard
    
    func value<T>(for key: UserDefaultsKey<T>) -> T? {
        return self.defaults.value(forKey: key.key) as? T
    }
    
    func set<T>(value: T?, for key: UserDefaultsKey<T>) {
        self.defaults.set(value, forKey: key.key)
    }
    
    func remove<T>(for key: UserDefaultsKey<T>) {
        return self.defaults.removeObject(forKey: key.key)
    }
    
    func removeAll() {
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            // remove 하지 않을 것들은 이곳에 추가
            defaults.removeObject(forKey: key)
        }
    }
}
