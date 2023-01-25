//
//  DeviceManager.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 9/4/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import Foundation
import UIKit
import Reachability
import CoreTelephony
import SystemConfiguration
import LocalAuthentication
import SwiftyJSON

class DeviceManager {
    static let shared = DeviceManager()
    var modeOffline = false
    private var deviceToken: String?
    class func getDeviceName() -> NSString {
        return UIDevice.current.name as NSString
    }

    class func getDeviceSystemName() -> NSString {
        return UIDevice.current.systemName as NSString
    }

    func getDeviceID() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }

    class func getWinSize() -> CGSize {
        let screenRect = UIScreen.main.bounds
        let screenSize = screenRect.size

        return screenSize
    }

    class func getScreenWidth() -> CGFloat {
        let screenRect = UIScreen.main.bounds
        let screenSize = screenRect.size
        return min(screenSize.width, screenSize.height)
    }

    class func getScreenHeight() -> CGFloat {
        let screenRect = UIScreen.main.bounds
        let screenSize = screenRect.size
        return max(screenSize.width, screenSize.height)
    }

    class func getWinFrame() -> CGRect {
        let screenRect = UIScreen.main.bounds
        let screenFrame = screenRect
        return screenFrame
    }

    class func isIphone() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return true
        }
        return false
    }

    class func isIpad() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        }
        return false
    }

    struct ScreenSize {
        static let screenWidth         = UIScreen.main.bounds.size.width
        static let screenHeight        = UIScreen.main.bounds.size.height
        static let screenMaxLength     = max(ScreenSize.screenWidth, ScreenSize.screenHeight)
        static let screenMinLength     = min(ScreenSize.screenWidth, ScreenSize.screenHeight)
    }

    struct DeviceType {
        static let isIphone4OrLess    = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength < 568.0
        static let isIphone5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 568.0
        static let isIphone6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 667.0
        static let isIPhone6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 736.0
        static let isIphoneX          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength >= 812
        static let isIpad             = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.screenMaxLength >= 1024.0
        static let isIpadPro          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.screenMaxLength >= 1366.0
    }

    class func detectInternet() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

    class func getDirectPath() -> String {
        let directoryURLs = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory,
                                                     in: FileManager.SearchPathDomainMask.userDomainMask)
        if !directoryURLs.isEmpty {
            return directoryURLs[0].absoluteString
        }
        return ""
    }

    class func getPathDataFolder() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let documentOfFile = documentsURL
        let dataFolder = documentOfFile.appendingPathComponent("data")

        let fileManager = FileManager.default
        var isDir: ObjCBool = false
        var checkExistFolder = false
        if fileManager.fileExists(atPath: documentOfFile.path, isDirectory: &isDir) {
            if isDir.boolValue {
                // Folder exists and is a directory
                checkExistFolder = true
            }
        }
        if !checkExistFolder {
            do {
                try FileManager.default.createDirectory(atPath: documentOfFile.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
        }
        return dataFolder
    }

    class func touchIDAviable() -> Bool {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return true
        } else {
            return false
        }
    }

    class func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }

    class func sizeOfFolderInFormatStr(_ folderPath: String) -> String {
        if let folderSize = DeviceManager.sizeOfFolder(folderPath) {
            /// This line will give you formatted size from bytes ....
            let fileSizeStr = ByteCountFormatter.string(fromByteCount: Int64(folderSize), countStyle: ByteCountFormatter.CountStyle.binary)
            return fileSizeStr
        }
        return ""
    }

    class func sizeOfFolder(_ folderPath: String) -> Int64? {
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: folderPath)
            var folderSize: Int64 = 0
            for content in contents {
                do {
                    let fullContentPath = folderPath + "/" + content
                    let fileAttributes = try FileManager.default.attributesOfItem(atPath: fullContentPath)
                    folderSize += fileAttributes[FileAttributeKey.size] as? Int64 ?? 0
                } catch _ {
                    continue
                }
            }
            return folderSize
        } catch let error {
            print(error.localizedDescription)
            return 0
        }
    }

    class func getListFileOfFolder() -> [String]? {
        let directory = DeviceManager.getPathDataFolder()
        if let urlArray = try? FileManager.default.contentsOfDirectory(at: directory,
                                                                       includingPropertiesForKeys: [.contentModificationDateKey],
                                                                       options: .skipsHiddenFiles) {
            return urlArray.map { url in
                (url.path, (try? url.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast)
                }
                .sorted(by: { $0.1 > $1.1 }) // sort descending modification dates
                .map { $0.0 } // extract file names

        } else {
            return nil
        }
    }

    class func removeFileWithPath(_ path: String) {
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch let err as NSError {
            logD(err.debugDescription)
        }
    }

    class func safeAreaBottomInsets() -> CGFloat {
        if #available(iOS 11, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
        }
        return 0
    }
}
