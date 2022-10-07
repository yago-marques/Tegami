//
//  UserDefaultsHelper.swift
//  Tegami
//
//  Created by user on 07/10/22.
//

import Foundation

protocol UserDefaultsProtocol {
    func setBool(_ value: Bool, forKey: String)
    func bool(forKey: String) -> Bool
}

extension UserDefaultsProtocol {
    func setBool(_ value: Bool, forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
    }

    func bool(forKey: String) -> Bool {
        UserDefaults.standard.bool(forKey: forKey)
    }
}

final class UserDefaultsHelper: UserDefaultsProtocol { }
