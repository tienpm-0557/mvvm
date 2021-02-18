//
//  UIPageExampleViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 9/4/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxSwift
import RxCocoa

class UIPageExampleViewModel: BaseUIPageViewModel {
    let rxPageTitle = BehaviorRelay<String>(value: "")
    
    override func react() {
        super.react()
        isInfinity = false
        setupPage()
        
        guard let model = self.model as? MenuModel else {
            return
        }
        rxPageTitle.accept(model.title)
    }
    
    func setupPage() {
        let model0 = TabbarModel(JSON: ["title": "Vivid Sky Blue", "hex": "4CC9F0"])
        let vc0 = TabPage(viewModel: TabPageViewModel(model: model0))
        let page0 = UIPageItem(model: model0, viewController: vc0)
        
        let model1 = TabbarModel(JSON: ["title": "Skype Blue Crayola", "hex": "75DBFA"])
        let vc1 = TabPage(viewModel: TabPageViewModel(model: model1))
        let page1 = UIPageItem(model: self.model, viewController: vc1)
        
        let model2 = TabbarModel(JSON: ["title": "Vivid Sky Blue", "hex": "4CC9F0"])
        let vc2 = TabPage(viewModel: TabPageViewModel(model: model2))
        let page2 = UIPageItem(model: model2, viewController: vc2)
        
        let model3 = TabbarModel(JSON: ["title": "Skype Blue Crayola", "hex": "75DBFA"])
        let vc3 = TabPage(viewModel: TabPageViewModel(model: model3))
        let page3 = UIPageItem(model: model3, viewController: vc3)
        
        let model4 = TabbarModel(JSON: ["title": "Vivid Sky Blue", "hex": "4CC9F0"])
        let vc4 = TabPage(viewModel: TabPageViewModel(model: model4))
        let page4 = UIPageItem(model: model4, viewController: vc4)
            
        itemsSource.append([page0, page1, page2, page3, page4])
    }
}
