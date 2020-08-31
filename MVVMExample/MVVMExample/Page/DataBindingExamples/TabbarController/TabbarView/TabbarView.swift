//
//  TabbarView.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 8/31/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxSwift
import RxCocoa
import Action

class TabbarView: AbstractView {
    
    @IBOutlet private var buttons: Array<UIButton>!
    private var prevButton: UIButton?
    
    let rxSelectedIndex = BehaviorRelay(value: 0)
    
    lazy var testAction: Action<AnyObject, Void> = {
        return Action<AnyObject, Void> { input in
            return .just(())
        }
    }()
    
    
    class func newTabbarView() -> TabbarView? {
        guard let _tabBarView = TabbarView.loadFrom(nibNamed: TabbarView.nibName(), bundle: Bundle.main) as? TabbarView else {
            return nil
        }
        _tabBarView.setupView()
        return _tabBarView
    }
    
    override func setupView() {
        super.setupView()
        
    }
    
    @IBAction func didSelectedTab(_ sender: UIButton) {
        if let prevButton = self.prevButton {
            prevButton.isSelected = false
        }
        
        prevButton = sender
        sender.isSelected = true
        
        rxSelectedIndex.accept(sender.tag)
        
        
    }
}
