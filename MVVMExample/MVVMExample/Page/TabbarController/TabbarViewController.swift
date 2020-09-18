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
        
        /// Setup Tabbar Controller
        let timelineViewModel = TimelinePageViewModel(model: TabbarModel(JSON: ["title": "Home", "index": 0]))
        let tab0 = TimelinePage(viewModel: timelineViewModel)
        let nv0 = NavigationPage(rootViewController: tab0)
        
        let vm1 = TabPageViewModel(model: TabbarModel(JSON: ["title":"Messages", "index":1]))
        let tab1 = TabPage(viewModel: vm1)
        let nv1 = NavigationPage(rootViewController: tab1)
        
        let vm2 = TabPageViewModel(model: TabbarModel(JSON: ["title":"Notifications", "index":2]))
        let tab2 = TabPage(viewModel: vm2)
        let nv2 = NavigationPage(rootViewController: tab2)
        
        let vm3 = TabPageViewModel(model: TabbarModel(JSON: ["title":"Profile", "index":3]))
        let tab3 = TabPage(viewModel: vm3)
        let nv3 = NavigationPage(rootViewController: tab3)
        
        self.viewControllers = [nv0, nv1, nv2, nv3]
        self.addTabBarView()
    }

    fileprivate func addTabBarView() {
        _tabBarView = TabbarView.newTabbarView()
        
        if let tabbarView = _tabBarView {
            self.view.addSubview(tabbarView)
        }
        /// Use PureLayout set Tabbar's constraint
        _tabBarView?.autoPinEdge(toSuperviewEdge: .bottom)
        _tabBarView?.autoPinEdge(toSuperviewEdge: .left)
        _tabBarView?.autoPinEdge(toSuperviewEdge: .right)
        _tabBarView?.autoSetDimension(.height, toSize: SystemConfiguration.TabbarHeight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
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
