//
//  MVVMExamplePage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/14/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit

class MVVMExamplePage: TableOfContentsPage {
    override func initialize() {
        super.initialize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Custom your UIBarButtonItem
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.barButton(withContentInsets: UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0),
                                                                          withTitle: "MVVM",
                                                                          withImage: "icon-back",
                                                                          withTitleColor: UIColor(hexString: "2ECC71"),
                                                                          withAction: self.backAction)
    }
}
