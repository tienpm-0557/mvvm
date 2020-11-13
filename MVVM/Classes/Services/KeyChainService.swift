//
//  KeyChainService.swift
//  MVVM
//
//  Created by tienpm on 11/13/20.
//

import Foundation
import KeychainAccess
import RNCryptor

enum KeyChainConfig {
    static let privateKey: String = "KeychainPrivate-Key"
    static let passwordKey: String = "Password-Key"
}

public class KeyChainService {
    private static let keychain = Keychain(service: Bundle.main.bundleIdentifier!)
    
    static func generatePrivateKey() {
        if keychain[KeyChainConfig.privateKey].isNilOrEmpty {
            let uuid = UUID().uuidString
            keychain[KeyChainConfig.passwordKey] = uuid
        }
    }
    
    static func encryption(password: String) {
        guard let data = password.data(using: .utf8), let key = keychain[KeyChainConfig.privateKey] else {
            return
        }
        let passwordEncrypted = RNCryptor.encrypt(data: data, withPassword: key)
        UserDefaults.standard.set(passwordEncrypted, forKey: KeyChainConfig.passwordKey)
    }
    
    static func getPassword() -> String? {
        return decryption()
    }
    
    private static func decryption() -> String? {
        do {
            guard let passwordEncrypted = UserDefaults.standard.data(forKey: KeyChainConfig.passwordKey), let key = keychain[KeyChainConfig.privateKey] else {
                return nil
            }
            let passwordData = try RNCryptor.decrypt(data: passwordEncrypted, withPassword: key)
            return String(data: passwordData, encoding: .utf8)
        } catch {
            debugPrint(error)
            return nil
        }
    }
}
