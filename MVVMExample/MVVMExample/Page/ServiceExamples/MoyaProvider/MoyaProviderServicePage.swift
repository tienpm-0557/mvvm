//
//  MoyaProviderServicePage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 6/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM

class MoyaProviderServicePage: BasePage {
    
    override func initialize() {
        DependencyManager.shared.registerService(Factory<FlickrService> {
            FlickrService()
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
}
