//
//  UserDefaultsKey.swift
//  MyMusic
//
//  Created by JUNHYEOK LEE on 1/13/24.
//

import Foundation

struct UserDefaultsKey<T> {
    typealias Key<T> = UserDefaultsKey<T>
    let key: String
}

extension UserDefaultsKey: ExpressibleByStringLiteral {
    public init(unicodeScalarLiteral value: StringLiteralType) {
        self.init(key: value)
    }
    
    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self.init(key: value)
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self.init(key: value)
    }
}

protocol UserDefaultServiceType {
    func value<T>(for key: UserDefaultsKey<T>) -> T?
    func set<T>(value: T?, for key: UserDefaultsKey<T>)
//    func getObject<T: Codable>(for key: UserDefaultsKey<T>) -> T?
//    func setObject<T: Codable>(value: T?, for key: UserDefaultsKey<T>)
    func remove<T>(for key: UserDefaultsKey<T>)
}
