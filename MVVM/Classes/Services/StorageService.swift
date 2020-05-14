//
//  StorageService.swift
//  MVVM
//

import UIKit
import RxSwift
import ObjectMapper

public protocol IStorageService {
    
    func save<T>(_ value: T, forKey key: String)
    func get<T>(forKey key: String) -> T?
    
    func saveModel<T: Model>(_ model: T?, forKey key: String)
    func loadModel<T: Model>(forKey key: String) -> T?
    
    func saveModels<T: Model>(_ models: [T]?, forKey key: String)
    func loadModels<T: Model>(forKey key: String) -> [T]?
    
    func remove(_ key: String)
}

open class StorageService: IStorageService {
    
    private let defaults = UserDefaults.standard
    
    /// Save generic type to UserDefaults
    public func save<T>(_ value: T, forKey key: String) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    /// Get generic type from UserDefaults
    public func get<T>(forKey key: String) -> T? {
        return defaults.value(forKey: key) as? T
    }
    
    /// Save model to UserDefaults
    public func saveModel<T: Model>(_ model: T?, forKey key: String) {
        if let model = model {
            let json = model.toJSON()
            defaults.set(json, forKey: key)
            defaults.synchronize()
        }
    }
    
    /// Load model from UserDefaults
    public func loadModel<T: Model>(forKey key: String) -> T? {
        if let json = defaults.object(forKey: key) {
            return Model.fromJSON(json)
        }
        
        return nil
    }
    
    /// Save an array of models to UserDefaults
    public func saveModels<T: Model>(_ models: [T]?, forKey key: String) {
        if let models = models {
            let json = models.toJSON()
            defaults.set(json, forKey: key)
            defaults.synchronize()
        }
    }
    
    /// Load an array of models from UserDefaults
    public func loadModels<T: Model>(forKey key: String) -> [T]? {
        if let json = defaults.object(forKey: key) {
            return Model.fromJSONArray(json)
        }
        
        return nil
    }
    
    /// Remove for key
    public func remove(_ key: String) {
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
}

















