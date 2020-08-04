//
//  LocaleManager.swift
//  Action
//
//  Created by pham.minh.tien on 8/4/20.
//

import Foundation
import RxSwift
import RxCocoa

public class LocalizeService {
    private static let kCurrentLocale       = "CurrentLocale"
    private static let kDefaultLocale               = "en"

    static let shared = LocalizeService()
    
    public var rxLocaleState = BehaviorRelay<String>(value: "")
    
    public init() {
        if UserDefaults.standard.value(forKey: LocalizeService.kCurrentLocale) == nil {
            UserDefaults.standard.set(LocalizeService.kDefaultLocale, forKey: LocalizeService.kCurrentLocale)
            UserDefaults.standard.synchronize()
        }
    }
    
    public func getCurrentLocale() -> String {
        if let locale = UserDefaults.standard.value(forKey: LocalizeService.kCurrentLocale) as? String {
            return locale
        }
        return LocalizeService.kDefaultLocale
    }
    
    public func setCurrentLocale(_ locale: String) {
        UserDefaults.standard.set(locale, forKey: LocalizeService.kCurrentLocale)
        UserDefaults.standard.synchronize()
        self.rxLocaleState.accept(locale)
    }
    
    func localized(_ key: String) -> String {
        let locale = LocalizeService.shared.getCurrentLocale()
        let enBundlePath = Bundle.main.path(forResource: locale, ofType: "lproj")
        guard let bundle = Bundle(path: enBundlePath!) else { return "" }
        return NSLocalizedString(key, tableName: nil, bundle: bundle, value: key, comment: key)
    }
}
