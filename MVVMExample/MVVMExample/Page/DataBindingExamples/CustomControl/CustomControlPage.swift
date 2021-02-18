//
//  CustomControlPage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 6/2/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM

class CustomControlPage: BasePage {

    let segmentedView = SegmentedView(withTitles: ["Tab 1", "Tab 2", "Tab 3"])
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()   
    }
    
    override func initialize() {
        super.initialize()
        
        enableBackButton = true
        view.addSubview(segmentedView)
        segmentedView.autoPinEdge(toSuperviewSafeArea: .top)
        segmentedView.autoPinEdge(toSuperviewEdge: .leading)
        segmentedView.autoPinEdge(toSuperviewEdge: .trailing)
        
        view.addSubview(label)
        label.autoPinEdge(.top, to: .bottom, of: segmentedView, withOffset: 50)
        label.autoAlignAxis(toSuperviewAxis: .vertical)
    }
    
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel as? CustomControlViewPageModel else { return }
        
        viewModel.rxPageTitle ~> rx.title => disposeBag
        viewModel.rxSelectedIndex <~> segmentedView.rx.selectedIndex => disposeBag
        viewModel.rxSelectedText ~> label.rx.text => disposeBag
    }
}
