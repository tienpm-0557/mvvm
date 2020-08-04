//
//  DependencyManager.swift
//  MVVM
//

import Foundation

fileprivate extension String {
    
    static func describing(for type: Any) -> String {
        var desc = String(describing: type)
        if desc.hasPrefix("Optional<") {
            desc = desc.replacingOccurrences(of: "Optional<", with: "")
                .replacingOccurrences(of: ">", with: "")
        }
        return desc
    }
}

protocol IMutableDependencyResolver {
    
    func getService(_ type: Any) -> Any?
    func registerService(_ factory: Factory<Any>, type: Any)
    func removeService(_ type: Any)
}

extension IMutableDependencyResolver {
    
    func getService<T>() -> T {
        return getService(T.self) as! T
    }
    
    func registerService<T>(_ factory: Factory<T>) {
        return registerService(Factory {
            factory.create()
        }, type: T.self)
    }
}

class DefaultDependencyResolver: IMutableDependencyResolver {
    
    private var registry = [String: Factory<Any>]()
    
    func getService(_ type: Any) -> Any? {
        let k: String = .describing(for: type)
        for key in registry.keys {
            if k == key {
                return registry[key]?.create()
            }
        }
        return nil
    }
    
    func registerService(_ factory: Factory<Any>, type: Any) {
        let k: String = .describing(for: type)
        registry[k] = factory
    }
    
    func removeService(_ type: Any) {
        let k = String(describing: type)
        registry.removeValue(forKey: k)
    }
}

public class DependencyManager {
    
    public static let shared = DependencyManager()
    
    private let resolver: IMutableDependencyResolver = DefaultDependencyResolver()
    
    public func registerDefaults() {
        registerService(Factory<INavigationService> { NavigationService() })
        registerService(Factory<IStorageService> { StorageService() })
        registerService(Factory<IAlertService> { AlertService() })
        registerService(Factory<LocalizeService> { LocalizeService.shared })
    }
    
    public func getService<T>() -> T {
        return resolver.getService()
    }
    
    public func registerService<T>(_ factory: Factory<T>) {
        resolver.registerService(factory)
    }
    
    public func removeService<T>(_ type: T.Type) {
        resolver.removeService(type)
    }
}




