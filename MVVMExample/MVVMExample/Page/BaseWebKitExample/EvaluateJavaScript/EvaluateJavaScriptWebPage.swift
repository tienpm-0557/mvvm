//
//  EvaluateJavaScriptWebPage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/14/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit

class EvaluateJavaScriptWebPage: IntroductionPage {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // In Case: EvaluateJavaScriptWebViewModel
        if viewModel is EvaluateJavaScriptWebViewModel {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.evaluateJavaScript("presentAlert()")
            }
        }
    }
}
