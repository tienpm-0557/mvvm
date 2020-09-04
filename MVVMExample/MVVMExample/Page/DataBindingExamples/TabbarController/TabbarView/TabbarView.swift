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
        self.backgroundColor = UIColor.tabbarBackgroundColor
        buttons.forEach { (btn) in
            btn.setTitleColor(.tabbarTitleColor, for: .normal)
            btn.setTitleColor(.tabbarTitleSelectedColor, for: .selected)
            btn.backgroundColor = UIColor.clear
            
            btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        }
        
        self.prevButton = buttons.first
        
        guard let selectBtn = self.prevButton else { return }
        self.setSelectedTab(selectBtn)
    }
    
    
    @IBAction func didSelectedTab(_ sender: UIButton) {
        if let prevButton = self.prevButton {
            setNormalTab(prevButton)
        }
        
        prevButton = sender
        setSelectedTab(sender)
        rxSelectedIndex.accept(sender.tag)
    }
    
    fileprivate func setNormalTab(_ normalBtn: UIButton) {
        normalBtn.isSelected = false
        normalBtn.backgroundColor = UIColor.clear
    }
    
    fileprivate func setSelectedTab(_ selectedBtn: UIButton) {
        selectedBtn.isSelected = true
        selectedBtn.backgroundColor = .tabbarBackgroundSelectedColor
    }
}
