//
//  TransitionExamplesPageViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/14/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import MVVM
import RxCocoa
import WebKit
import Action
//MARK: ViewModel For Transition Examples
class TransitionExamplesPageViewModel: BaseViewModel {
    
    let rxPageTitle = BehaviorRelay<String>(value: "")
    
    lazy var flipAction: Action<Void, Void> = {
        return Action() { .just(self.pushAndFlip()) }
    }()
    
    lazy var zoomAction: Action<Void, Void> = {
        return Action() { .just(self.pushAndZoom()) }
    }()
    
    override func react() {
        super.react()
        let title = (self.model as? IntroductionModel)?.title ?? "Transition Examples"
        rxPageTitle.accept(title)
    }
    
    
    private func pushAndFlip() {
        /*
        let page = FlipPage(viewModel: ViewModel<Model>())
        let animator = FlipAnimator()
        if usingModal {
            let navPage = NavigationPage(rootViewController: page)
            navigationService.push(to: navPage, options: .modal(animator: animator))
        } else {
            navigationService.push(to: page, options: .push(with: animator))
        }
         */
    }
    
    private func pushAndZoom() {
        /*
        let page = ZoomPage(viewModel: ViewModel<Model>())
        let animator = ZoomAnimator()
        if usingModal {
            let navPage = NavigationPage(rootViewController: page)
            navigationService.push(to: navPage, options: .modal(animator: animator))
        } else {
            navigationService.push(to: page, options: .push(with: animator))
        }
        */
    }
     
    
    
}
