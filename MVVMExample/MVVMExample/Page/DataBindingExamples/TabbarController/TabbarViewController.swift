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
        let timelineViewModel = TimelinePageViewModel(model: TabbarModel(JSON: ["title": "TimeLine", "index": 0]))
        let tab0 = TimelinePage(viewModel: timelineViewModel)
        let nv0 = NavigationPage(rootViewController: tab0)
        
        if #available(iOS 13.0, *) {
            let app = UINavigationBarAppearance()
            app.backgroundColor = .blue
            nv0.navigationBar.scrollEdgeAppearance = app
        } else {
            // Fallback on earlier versions
        }
        
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
        
        self.addCloseBtn()
    }
    
    func addCloseBtn() {
        let button = UIButton(frame: CGRect(x: 10, y: 40, width: 110, height: 25))
        button.addTarget(self, action: #selector(self.popView), for: UIControl.Event.touchUpInside)
        button.backgroundColor = UIColor.groupTableViewBackground
        button.cornerRadius = 5
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = Font.system.bold(withSize: 12)
        
        button.setTitle("Close Example", for: UIControl.State.normal)
        self.view.addSubview(button)
    }
    
    @objc func popView() {
        /// Note: In example we have two navigation on stack.
        /// Navigation Service only get navigation on top stack.
        // self.navigationService.pop()
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
