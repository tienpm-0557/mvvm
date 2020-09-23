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
    @IBOutlet private var topLineHeight: NSLayoutConstraint!
    private var prevButton: UIButton?
    let rxSelectedIndex = BehaviorRelay(value: 0)
    
    private var darkmode: Bool = false {
        didSet {
            if darkmode {
                buttons.forEach { (btn) in
                    btn.backgroundColor = UIColor.black
                }
                self.backgroundColor = UIColor.black
            } else {
                buttons.forEach { (btn) in
                    btn.backgroundColor = UIColor.tabbarBackgroundColor
                }
                self.backgroundColor = UIColor.tabbarBackgroundColor
            }
        }
    }
    
    class func newTabbarView() -> TabbarView? {
        guard let _tabBarView = TabbarView.loadFrom(nibNamed: TabbarView.nibName(),
                                                    bundle: Bundle.main) as? TabbarView else {
            return nil
        }
        _tabBarView.setupView()
        return _tabBarView
    }
    
    override func setupView() {
        super.setupView()
        /// Setup tab items
        self.backgroundColor = UIColor.tabbarBackgroundColor
        buttons.forEach { (btn) in
            btn.setTitleColor(.tabbarTitleColor, for: .normal)
            btn.setTitleColor(.tabbarTitleSelectedColor, for: .selected)
            if self.darkmode {
                btn.backgroundColor = UIColor.black
            } else {
                btn.backgroundColor = UIColor.tabbarBackgroundColor
            }
            
            
            btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        self.prevButton = buttons.first
        /// Top line
        topLineHeight.constant = 1 / UIScreen.main.scale
        /// Update selected button
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

        if self.darkmode {
            normalBtn.backgroundColor = UIColor.black
        } else {
            normalBtn.backgroundColor = UIColor.tabbarBackgroundColor
        }
    }
    
    fileprivate func setSelectedTab(_ selectedBtn: UIButton) {
        selectedBtn.isSelected = true
        if self.darkmode {
            selectedBtn.backgroundColor = UIColor.black
        } else {
            selectedBtn.backgroundColor = .tabbarBackgroundSelectedColor
        }
        
    }
    
    func updateDarkmode(_ darkmode:Bool) {
        self.darkmode = darkmode
    }
}
