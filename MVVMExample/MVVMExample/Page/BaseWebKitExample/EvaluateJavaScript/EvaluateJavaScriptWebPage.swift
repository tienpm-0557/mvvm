//
//  EvaluateJavaScriptWebPage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/14/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import Action
import RxSwift
import RxCocoa

class EvaluateJavaScriptWebPage: IntroductionPage {
    let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    lazy var addAction: Action<Void, Void> = {
        return Action() { .just(self.add()) }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableBackButton = true
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = addBtn
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        
        addBtn.rx.bind(to: self.addAction, input: ())
    }
    
    func add() {
        self.evaluateJavaScript("presentAlert()")
    }
}
