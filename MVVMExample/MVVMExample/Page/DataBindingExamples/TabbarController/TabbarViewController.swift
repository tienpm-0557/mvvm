//
//  TabbarViewController.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 8/31/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM

class TabbarViewController: BaseTabBarPage {

    var _tabBarView: TabbarView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initialize() {
        super.initialize()
        
        _tabBarView = TabbarView.newTabbarView()
        _tabBarView?.frame = CGRect(x: 0, y: 600, width: 414, height: 60)
        if let tabbarView = _tabBarView {
            self.view.addSubview(tabbarView)
        }   
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = self.viewModel as? TabbarControllerViewModel else { return }
        guard let tabbarView = self._tabBarView else { return }
        viewModel.rxSelectedIndex ~> tabbarView.rxSelectedIndex => disposeBag
        
        tabbarView.rxSelectedIndex.subscribe(onNext: { (index) in
            
        }) => disposeBag
    }

}
