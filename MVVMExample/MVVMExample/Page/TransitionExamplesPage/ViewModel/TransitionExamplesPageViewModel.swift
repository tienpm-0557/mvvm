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
    
    lazy var clockAction: Action<Void, Void> = {
        return Action() { .just(self.pushWithClockAnimation()) }
    }()
    
    var usingShowModal: Bool = false
    
    convenience init(model: Model?, usingShowModal: Bool) {
        self.init(model: model)
        self.usingShowModal = usingShowModal
    }
    
    override func react() {
        super.react()
        let title = (self.model as? IntroductionModel)?.title ?? "Transition Examples"
        rxPageTitle.accept(title)
    }
    
    
    private func pushAndFlip() {
        ///Create flip page model
        let model = BaseViewModel(model: TransitionContentModel(withTitle: "Flip animator", desc: "Example transition page with flip animation.", url: "https://github.com/tienpm-0557/mvvm/blob/AddBaseNonGeneric/README.md"))
        ///Create flip animator
        let animator = FlipAnimator()
        self.pushWithAnimator(animator, model: model)
    }
    
    private func pushAndZoom() {
        let model = BaseViewModel(model: TransitionContentModel(withTitle: "Zoom animator", desc: "Example transition page with Zoom animation.", url: "https://github.com/tienpm-0557/mvvm/blob/AddBaseNonGeneric/README.md"))
        let animator = ZoomAnimator()
        self.pushWithAnimator(animator, model: model)
        
    }
    
    private func pushWithClockAnimation() {
        let model = BaseViewModel(model: TransitionContentModel(withTitle: "Zoom animator", desc: "Example transition page with Clock animation.", url: "https://github.com/tienpm-0557/mvvm/blob/AddBaseNonGeneric/README.md"))
//        let animator = ClockAnimator(withDuration: 1.0, self.usingShowModal)
        
        let animator = ClockAnimator()
        self.pushWithAnimator(animator, model: model)
    }
    
    private func pushWithCircleAnimation() {
        let model = BaseViewModel(model: TransitionContentModel(withTitle: "Zoom animator", desc: "Example transition page with Clock animation.", url: "https://github.com/tienpm-0557/mvvm/blob/AddBaseNonGeneric/README.md"))
        let animator = ClockAnimator()
        self.pushWithAnimator(animator, model: model)
    }
    
    
    private func pushWithAnimator(_ animator: Animator, model: BaseViewModel) {
        let page = TransitionContentPage(viewModel: model)
        if usingShowModal {
            animator.isPresenting = usingShowModal
            let navPage = NavigationPage(rootViewController: page)
            navigationService.push(to: navPage, options: .modal(animator: animator))
        } else {
            navigationService.push(to: page, options: .push(with: animator))
        }
    }
    
}


