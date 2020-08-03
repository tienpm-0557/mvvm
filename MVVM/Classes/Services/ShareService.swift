//
//  ShareService.swift
//  Action
//
//  Created by pham.minh.tien on 8/3/20.
//

import Foundation
import RxSwift
import RxCocoa

public class ShareService {
    
    public init() {
        
    }
    
    public var rxShareServiceState = BehaviorRelay<(completed:Bool, items:[Any]?, error: Error?)?>(value: nil)
    
    public func openShare(title: String, url: String) {
        if let myWebSite = URL(string: url) {
            let objectToShare = [myWebSite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectToShare, applicationActivities: nil)
            
            activityVC.completionWithItemsHandler =  {[weak self] (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
                self?.rxShareServiceState.accept((completed, returnedItems, error))
            }
            
            /// Present activity View Controller
            let window = UIApplication.shared.keyWindow
            guard let rootViewContorller = window?.rootViewController else {
                return
            }
            
            rootViewContorller.present(activityVC, animated: true)
        } else {
            let err = NSError(domain: "", code: 404, userInfo: ["message": "URL Invalid"])
            rxShareServiceState.accept((false, nil, err))
        }
    }
}

