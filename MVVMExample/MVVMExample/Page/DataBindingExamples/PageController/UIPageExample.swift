//
//  UIPageExample.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 9/4/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM

class UIPageExample: BaseUIPage {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initialize() {
        super.initialize()
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
    }
    
    override func getItemSource() -> ReactiveCollection<UIPageItem>? {
        guard let viewModel = viewModel as? UIPageExampleViewModel else { return nil }
        return viewModel.itemsSource
    }

}
