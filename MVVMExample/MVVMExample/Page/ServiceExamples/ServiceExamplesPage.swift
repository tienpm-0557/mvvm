//
//  ServiceExamplesPage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/14/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxCocoa
import RxSwift
import Action

class ServiceExamplesPage: TableOfContentsPage {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func initialize() {
        super.initialize()
        DependencyManager.shared.registerService(Factory<MailService> { MailService() })
        DependencyManager.shared.registerService(Factory<ShareService> { ShareService() })
    }
}
