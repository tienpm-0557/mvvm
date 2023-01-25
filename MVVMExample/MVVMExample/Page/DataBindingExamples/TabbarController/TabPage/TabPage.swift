//
//  TabPage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 9/4/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM

class TabPage: BasePage {
    @IBOutlet private weak var hexLb: UILabel!
    @IBOutlet private weak var nameLb: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func initialize() {
        super.initialize()
        enableBackButton = true
    }

    override func bindViewAndViewModel() {
    super.bindViewAndViewModel()
    guard let viewModel = self.viewModel as? TabPageViewModel else {
        return
    }
    viewModel.rxTitle ~> self.rx.title => disposeBag
    viewModel.rxBackgroundHex.subscribe(onNext: { value in
        if let hex = value {
            self.view.backgroundColor = UIColor(hexString: hex)
        }
    }) => disposeBag
    viewModel.rxName ~> nameLb.rx.text => disposeBag
    viewModel.rxBackgroundHex ~> hexLb.rx.text => disposeBag
}
}
