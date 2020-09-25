//
//  PostDetailPage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 9/25/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM


class PostDetailPage: BaseListPage {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initialize() {
        super.initialize()
        enableBackButton = true
        
    }

    override func getItemSource() -> RxCollection? {
        return nil
    }
}
