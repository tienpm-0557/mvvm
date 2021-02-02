//
//  CoreDataManager.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 10/1/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MagicalRecord

class CoreDataManager: NSObject {

    class func setupCoreDataStack() {
        MagicalRecord.setupCoreDataStack()
        MagicalRecord.setupAutoMigratingCoreDataStack()
    }
    
    class func saveContext() {
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }
    
    // Mark: Core data helper
    class func archiveNSDataFromObject(_ params: Any!,
                                       withKey _key: String) -> Data! {
        if params == nil {
            return nil
        }
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(requiringSecureCoding: true)
        archiver.encode(params as AnyObject, forKey: _key)
        archiver.finishEncoding()
        return data as Data
    }
    
    class func unarchiveNSData(withData data : Data,
                               withKey key : String) -> Any? {
        do {
            let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
            let jsonData = unarchiver.decodeObject(forKey: key)
            return jsonData
        } catch {
            return nil
        }
    }
}
