//
//  LocalizationPage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 8/4/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxSwift
import RxCocoa

class LocalizationPage: BasePage {
    @IBOutlet private var localizeLb: UILabel!
    @IBOutlet private var englishBtn: UIButton!
    @IBOutlet private var japaneseBtn: UIButton!
    
    override func initialize() {
        super.initialize()
        self.enableBackButton = true
        localizeLb.text = LocalizedStringMessage.strTestMessage.localized
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        
        guard let viewModel = self.viewModel as? LocalizationPageViewModel else {
            return
        }
        
        viewModel.rxPageTitle ~> rx.title => disposeBag
        englishBtn.rx.bind(to: viewModel.rxEnglishAction, input: ())
        japaneseBtn.rx.bind(to: viewModel.rxJPAction, input: ())
    }
    
    override func onUpdateLocalize() {
        super.onUpdateLocalize()
        print("DEBUG: Page onUpdateLocalize")
        localizeLb.text = LocalizedStringMessage.strTestMessage.localized
         self.navigationItem.backBarButtonItem?.title = ""
    }
}
