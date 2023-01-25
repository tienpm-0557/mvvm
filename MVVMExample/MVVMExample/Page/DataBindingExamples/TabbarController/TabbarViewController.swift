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
    var tabBarView: TabbarView?

    override func initialize() {
        super.initialize()
        enableBackButton = false
        /// Setup Tabbar Controller
        let timelineViewModel = TimelinePageViewModel(model: TabbarModel(JSON: ["title": "Home", "index": 0]))
        let tab0 = TimelinePage(viewModel: timelineViewModel)
        let nv0 = NavigationPage(rootViewController: tab0)

        let vm1 = TabPageViewModel(model: TabbarModel(JSON: ["title": "Messages", "index": 1]))
        let tab1 = TabPage(viewModel: vm1)
        let nv1 = NavigationPage(rootViewController: tab1)

        let vm2 = TabPageViewModel(model: TabbarModel(JSON: ["title": "Notifications", "index": 2]))
        let tab2 = TabPage(viewModel: vm2)
        let nv2 = NavigationPage(rootViewController: tab2)

        let vm3 = TabPageViewModel(model: TabbarModel(JSON: ["title": "Profile", "index": 3]))
        let tab3 = TabPage(viewModel: vm3)
        let nv3 = NavigationPage(rootViewController: tab3)

        self.viewControllers = [nv0, nv1, nv2, nv3]
        self.addTabBarView()
        self.addCloseBtn()
    }

    fileprivate func addTabBarView() {
        tabBarView = TabbarView.newTabbarView()
        if #available(iOS 12.0, *) {
            tabBarView?.updateDarkmode(self.traitCollection.userInterfaceStyle == .dark)
        } else {
            // Fallback on earlier versions
        }
        if let tabbarView = tabBarView {
            self.view.addSubview(tabbarView)
        }
        /// Use PureLayout set Tabbar's constraint
        tabBarView?.autoPinEdge(toSuperviewEdge: .bottom)
        tabBarView?.autoPinEdge(toSuperviewEdge: .left)
        tabBarView?.autoPinEdge(toSuperviewEdge: .right)
        tabBarView?.autoSetDimension(.height, toSize: SystemConfiguration.TabbarHeight)
    }

    func addCloseBtn() {
        /// Note: In example we have two navigation on stack.
        /// Navigation Service only get navigation on top stack.
        // self.navigationService.pop()
        var positionY = 30
        if DeviceManager.DeviceType.isIphoneX {
            positionY = 50
        }
        let button = UIButton(frame: CGRect(x: 10, y: positionY, width: 110, height: 25))
        button.addTarget(self, action: #selector(self.popView), for: UIControl.Event.touchUpInside)
        button.backgroundColor = UIColor.groupTableViewBackground
        button.cornerRadius = 5
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = Font.system.bold(withSize: 12)
        button.setTitle("Close Example", for: UIControl.State.normal)
        self.view.addSubview(button)
    }

    @objc
    func popView() {
        self.navigationController?.popViewController(animated: true)
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
        guard let viewModel = self.viewModel as? TabbarControllerViewModel else {
            return
        }
        guard let tabbarView = self.tabBarView else {
            return
        }
        viewModel.rxSelectedIndex ~> tabbarView.rxSelectedIndex => disposeBag

        tabbarView.rxSelectedIndex.subscribe(onNext: { index in
            self.selectedIndex = index
        }) => disposeBag

        self.rx.title.onNext("Tabbar Controller")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard UIApplication.shared.applicationState == .inactive else {
            return
        }

        if #available(iOS 12.0, *) {
            self.tabBarView?.updateDarkmode(self.traitCollection.userInterfaceStyle == .dark)
        } else {
            // Fallback on earlier versions
            self.tabBarView?.updateDarkmode(false)
        }
    }
}
