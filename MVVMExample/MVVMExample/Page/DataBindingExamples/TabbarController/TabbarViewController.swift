//
//  TabbarViewController.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 8/31/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import SwiftyJSON

class TabbarViewController: BaseTabBarPage {

    var _tabBarView: TabbarView?
    
    override func initialize() {
        super.initialize()
        enableBackButton = false
        self.view.backgroundColor = UIColor.white
        /// Setup Tabbar Controller
        let vm0 = TabPageViewModel(model: TabbarModel(JSON: ["title":"Home", "index":0]))
        let tab0 = TabPage(viewModel: vm0)
        let nv0 = NavigationPage(rootViewController: tab0)
        tab0.view.backgroundColor = UIColor.tabbarBackgroundColor
        
        let vm1 = TabPageViewModel(model: TabbarModel(JSON: ["title":"Messages", "index":1]))
        let tab1 = TabPage(viewModel: vm1)
        let nv1 = NavigationPage(rootViewController: tab1)
        
        let vm2 = TabPageViewModel(model: TabbarModel(JSON: ["title":"Notifications", "index":2]))
        let tab2 = TabPage(viewModel: vm2)
        tab2.view.backgroundColor = UIColor.tabbarBackgroundColor
        let nv2 = NavigationPage(rootViewController: tab2)
        
        let vm3 = TabPageViewModel(model: TabbarModel(JSON: ["title":"Profile", "index":3]))
        let tab3 = TabPage(viewModel: vm3)
        let nv3 = NavigationPage(rootViewController: tab3)
        
        self.viewControllers = [nv0, nv1, nv2, nv3]
        
        _tabBarView = TabbarView.newTabbarView()
        
        if let tabbarView = _tabBarView {
            self.view.addSubview(tabbarView)
        }
        /// Use PureLayout set Tabbar's constraint
        _tabBarView?.autoPinEdge(toSuperviewEdge: .bottom)
        _tabBarView?.autoPinEdge(toSuperviewEdge: .left)
        _tabBarView?.autoPinEdge(toSuperviewEdge: .right)
        _tabBarView?.autoSetDimension(.height, toSize: 82)
        
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = self.viewModel as? TabbarControllerViewModel else { return }
        guard let tabbarView = self._tabBarView else { return }
        viewModel.rxSelectedIndex ~> tabbarView.rxSelectedIndex => disposeBag
        
        tabbarView.rxSelectedIndex.subscribe(onNext: { (index) in
            self.selectedIndex = index
        }) => disposeBag
        
        self.rx.title.onNext("Tabbar Controller")
    }

}
