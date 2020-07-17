//
//  ReachabilityService.swift
//  Action
//
//  Created by dinh.tung on 7/17/20.
//

import Foundation
import Reachability
import RxSwift
import RxCocoa

public class ReachabilityService {
    
    public static let share = ReachabilityService()
    private var reachability: Reachability?
    public var connectState = BehaviorRelay<Reachability.Connection?>(value: nil)
    private var option: String?
    
    public func startReachability(_ option:String = "") {
        self.option = option
        do {
            reachability = try Reachability()
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        
        reachability?.whenReachable = { reachability in
            print("NETWORK: connection did change \(reachability.connection.description)")
            if option == "alert" {
                
            } else if option == "status bar" {
                
            }
            
            switch reachability.connection {
            case .wifi:
                self.connectState.accept(.wifi)
            case .cellular:
                self.connectState.accept(.cellular)
            default:
                self.connectState.accept(.unavailable)
            }
        }
        
        reachability?.whenUnreachable = { _ in
            self.connectState.accept(.unavailable)
        }
    }
}
