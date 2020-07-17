//
//  ReachabilityPage.swift
//  MVVMExample
//
//  Created by dinh.tung on 7/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM

class ReachabilityPage: BasePage {

    @IBOutlet weak var connectionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = viewModel as? ReachabilityPageViewModel else {
            return
        }
        viewModel.rxPageTitle ~> self.rx.title => disposeBag
        viewModel.rxLabelContent ~> connectionLabel.rx.text => disposeBag
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
