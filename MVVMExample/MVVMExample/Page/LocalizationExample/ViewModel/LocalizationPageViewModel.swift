//
//  LocalizationPageViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 8/4/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import MVVM
import Action
import RxSwift
import RxCocoa

class LocalizationPageViewModel: BaseViewModel {
    private var localizationService: LocalizeService?
    
    var rxPageTitle = BehaviorRelay<String>(value: "")
    
    lazy var rxJPAction: Action<Void, Void> = {
        return Action() { .just(self.selectJPLocale()) }
    }()
    
    lazy var rxEnglishAction: Action<Void, Void> = {
        return Action() { .just(self.selectedEngLocale()) }
    }()
    
    override func react() {
        super.react()
        localizationService = DependencyManager.shared.getService()
        rxPageTitle.accept(LocalizedStringConfigs.strLocalizePageTitle.localized)
    }
    
    private func selectJPLocale() {
        localizationService?.setCurrentLocale("ja")
    }
    
    private func selectedEngLocale() {
        localizationService?.setCurrentLocale("en")
    }

    override func onUpdateLocalize() {
        super.onUpdateLocalize()
        print("DEBUG: PageModel onUpdateLocalize")
        rxPageTitle.accept(LocalizedStringConfigs.strLocalizePageTitle.localized)
    }
    
}
