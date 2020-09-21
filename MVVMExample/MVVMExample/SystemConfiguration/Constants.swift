//
//  Constants.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/24/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import Foundation
import UIKit

enum SystemConfiguration {
    static let name     = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as! String
    static let version  = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString" as String) ?? "1.0") as! String
    static let buildIndex   = (Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) ?? "1") as! String
    static let bundleID     = Bundle.main.bundleIdentifier
    static let requestTimeOut = 60
    static let NavigationBarHeight:CGFloat = DeviceManager.DeviceType.IS_IPHONE_X ? 80 : 60
    static let TabbarHeight:CGFloat = DeviceManager.DeviceType.IS_IPHONE_X ? 85 : 50
}
