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

    override func react() {
        super.react()
        isInfinity = false
        setupPage()
    }
    
    func setupPage() {
        let vc0 = TabPage()
        vc0.view.backgroundColor = .tabbarBackgroundColor
        let page0 = UIPageItem(model: self.model, viewController: vc0)
        
        let vc1 = TabPage()
        let page1 = UIPageItem(model: self.model, viewController: vc1)
        
        let vc2 = TabPage()
        vc2.view.backgroundColor = .tabbarBackgroundColor
        let page2 = UIPageItem(model: self.model, viewController: vc2)
        
        let vc3 = TabPage()
        let page3 = UIPageItem(model: self.model, viewController: vc3)
        
        let vc4 = TabPage()
        vc4.view.backgroundColor = .tabbarBackgroundColor
        let page4 = UIPageItem(model: self.model, viewController: vc4)
            
        itemsSource.append([page0, page1, page2, page3, page4])
    }
}
