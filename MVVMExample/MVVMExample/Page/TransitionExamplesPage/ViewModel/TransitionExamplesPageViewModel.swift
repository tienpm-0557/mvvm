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
    
    lazy var circleAction: Action<Void, Void> = {
        return Action() { .just(self.pushWithCircleAnimation()) }
    }()
    
    lazy var crossAndFadeAction: Action<Void, Void> = {
        return Action() { .just(self.pushWithCrossAndFadeAnimation()) }
    }()
    
    lazy var rectangularAction: Action<Void, Void> = {
        return Action() { .just(self.pushWithRectangularAnimation()) }
    }()
    
    lazy var multiCircleAction: Action<Void, Void> = {
        return Action() { .just(self.pushWithMultiCircleAnimation()) }
    }()
    
    lazy var tiledFlipAction: Action<Void, Void> = {
        return Action() { .just(self.pushWithTileFlipAnimation()) }
    }()
    
    lazy var imageRepeatingAction: Action<Void, Void> = {
        return Action() { .just(self.pushWithImageRepeatingAnimation())}
    }()
    
    lazy var multiFlipAction: Action<Void, Void> = {
        return Action() { .just(self.pushWithMultiFlipAnimation()) }
    }()
    
    lazy var angleLineAction: Action<Void, Void> = {
        return Action() { .just(self.pushWithAngleLineAnimation())}
    }()
    
    lazy var straightLineAction: Action<Void, Void> = {
        return Action() { .just(self.pushWithStraightLineAnimation()) }
    }()
    
    lazy var collidingDiamondsAction: Action<Void, Void> = {
        return Action() { .just(self.pushWithCollidingDiamondsAnimation()) }
    }()
    
    lazy var shrinkingGrowingAction: Action<Void, Void> = {
        return Action() { .just(self.pushWithShrinkingGrowingAnimation()) }
    }()
    
    lazy var splitFromCenterAction: Action<Void, Void> = {
        return Action() { .just(self.pushWithSplitFromCenterAnimation()) }
    }()
    
    lazy var swingInAction: Action<Void, Void> = {
        return Action() { .just(self.pushWithSwingInAnimation()) }
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
        let model = BaseViewModel(model: TransitionContentModel(withTitle: "Flip Animation",
                                                                desc: "Example transition page with Flip animation.",
                                                                url: "https://github.com/tienpm-0557/mvvm/blob/AddBaseNonGeneric/README.md"))
        ///Create flip animator
        let animator = FlipAnimator(withDuration: 0.5, isPresenting: self.usingShowModal)
        self.pushWithAnimator(animator, model: model)
    }
    
    private func pushAndZoom() {
        let model = BaseViewModel(model: TransitionContentModel(withTitle: "Zoom Animation",
                                                                desc: "Example transition page with Zoom animation.",
                                                                url: "https://github.com/tienpm-0557/mvvm/blob/AddBaseNonGeneric/README.md"))
        let animator = ZoomAnimator(withDuration: 2.0, isPresenting: self.usingShowModal)
        self.pushWithAnimator(animator, model: model)
        
    }
    
    private func pushWithClockAnimation() {
        let model = BaseViewModel(model: TransitionContentModel(withTitle: "Zoom Animation",
                                                                desc: "Example transition page with Clock animation.",
                                                                url: "https://github.com/tienpm-0557/mvvm/blob/AddBaseNonGeneric/README.md",
                                                                withBGColor: "#F2F2F7"))
        
        let animator = ClockAnimator(withDuration: TimeInterval(0.5), isPresenting: self.usingShowModal)
        self.pushWithAnimator(animator, model: model)
    }
    
    private func pushWithCircleAnimation() {
        let model = BaseViewModel(model: TransitionContentModel(withTitle: "Circle Animation",
                                                                desc: "Example transition page with Circle animation.",
                                                                url: "https://github.com/tienpm-0557/mvvm/blob/AddBaseNonGeneric/README.md",
                                                                withBGColor: "#F2F2F7"))
        let animator = CircleAnimator(withDuration: TimeInterval(0.25), isPresenting: self.usingShowModal)
        self.pushWithAnimator(animator, model: model)
    }
    
    private func pushWithCrossAndFadeAnimation() {
        let model = BaseViewModel(model: TransitionContentModel(withTitle: "Cross And Fade",
                                                                desc: "Example transition page with Cross And Fade animation",
                                                                url: "https://github.com/tienpm-0557/mvvm/blob/AddBaseNonGeneric/README.md"))
        let animator = CrossFadeAnimator(withDuration: TimeInterval(0.75), isPresenting: self.usingShowModal)
        self.pushWithAnimator(animator, model: model)
    }
    
    private func pushWithRectangularAnimation() {
        let model = BaseViewModel(model: TransitionContentModel(withTitle: "Rectangular Animation",
                                                                desc: "Example transition page with Rectangular animation",
                                                                url: "https://github.com/tienpm-0557/mvvm/blob/AddBaseNonGeneric/README.md"))
        let animator = RectanglerAnimator(withDuration: TimeInterval(0.25), isPresenting: self.usingShowModal)
        self.pushWithAnimator(animator, model: model)
    }
    
    private func pushWithMultiCircleAnimation() {
        let model = BaseViewModel(model: TransitionContentModel(withTitle: "Multi Circle",
                                                                desc: "Example transition page with Multi Circle animation",
                                                                url: "https://github.com/tienpm-0557/mvvm/blob/AddBaseNonGeneric/README.md"))
        let animator = MultiCircleAnimator(withDuration: TimeInterval(0.25), isPresenting: self.usingShowModal)
        self.pushWithAnimator(animator, model: model)
    }
    
    private func pushWithTileFlipAnimation() {
        let model = BaseViewModel(model: TransitionContentModel(withTitle: "Tiled Flip Animation",
                                                                desc: "Example transition page with Tiled Flip animation",
                                                                url: "https://github.com/tienpm-0557/mvvm/blob/AddBaseNonGeneric/README.md"))
        let animator = TiledFlipAnimator(withDuration: TimeInterval(0.75), isPresenting: self.usingShowModal)
        self.pushWithAnimator(animator, model: model)
    }

    private func pushWithImageRepeatingAnimation() {
        let model = BaseViewModel(model: TransitionContentModel(withTitle: "Image Repeating Animation",
                                                                desc: "Example transition page with Image Repeating animation",
                                                                url: "https://github.com/tienpm-0557/mvvm/blob/AddBaseNonGeneric/README.md"))
        let animator = ImageRepeatingAnimator(withDuration: TimeInterval(0.5), isPresenting: self.usingShowModal)
        
        self.pushWithAnimator(animator, model: model)
    }
    
    private func pushWithMultiFlipAnimation() {
        let model = BaseViewModel(model: TransitionContentModel(withTitle: "Multi Flip Animation",
                                                                desc: "Example transition page with Multi Flip animation",
                                                                url: "https://github.com/tienpm-0557/mvvm/blob/AddBaseNonGeneric/README.md"))
        let animator = MultiFlipRetroAnimator(withDuration: TimeInterval(0.5), isPresenting: self.usingShowModal)
        
        self.pushWithAnimator(animator, model: model)
    }
    
    private func pushWithAngleLineAnimation() {
        let model = BaseViewModel(model: TransitionContentModel(withTitle: "Angle Line Animation",
                                                                desc: "Example transition page with Angle Line animation",
                                                                url: "https://github.com/tienpm-0557/mvvm/blob/AddBaseNonGeneric/README.md"))
        let animator = AngleLineAnimator(withDuration: TimeInterval(0.5), isPresenting: self.usingShowModal)
        
        self.pushWithAnimator(animator, model: model)
    }
    
    private func pushWithStraightLineAnimation() {
        let model = BaseViewModel(model: TransitionContentModel(withTitle: "Straight Line Animation",
                                                                desc: "Example transition page with Straight Line Animation",
                                                                url: "https://github.com/tienpm-0557/mvvm/blob/AddBaseNonGeneric/README.md"))
        let animator = StraightLineAnimator(withDuration: TimeInterval(0.25), isPresenting: self.usingShowModal)
        self.pushWithAnimator(animator, model: model)
    }
    
    private func pushWithCollidingDiamondsAnimation() {
        let model = BaseViewModel(model: TransitionContentModel(withTitle: "Colliding Diamonds Animation",
                                                                desc:"Example transition page with Colliding Diamonds Animation",
                                                                url: "https://github.com/tienpm-0557/mvvm/blob/AddBaseNonGeneric/README.md"))
        let animator = CollidingDiamondsAnimator(withDuration: TimeInterval(0.25), isPresenting: self.usingShowModal)
        self.pushWithAnimator(animator, model: model)
    }
    
    private func pushWithShrinkingGrowingAnimation() {
        let model = BaseViewModel(model: TransitionContentModel(withTitle: "Shrinking Growing Diamonds Animation",
                                                                desc: "Example transition page with Shrinking Growing Diamonds Animation",
                                                                url: "https://github.com/tienpm-0557/mvvm/blob/AddBaseNonGeneric/README.md"))
        let animator = ShrinkingGrowingDiamondsAnimator(withDuration: TimeInterval(0.5), isPresenting: self.usingShowModal)
        self.pushWithAnimator(animator, model: model)
    }
    
    private func pushWithSplitFromCenterAnimation() {
        let model = BaseViewModel(model: TransitionContentModel(withTitle: "Split from center Animation",
                                                                desc: "Example transition page with Split From Center Animation",
                                                                url: "https://github.com/tienpm-0557/mvvm/blob/AddBaseNonGeneric/README.md"))
        let animator = SplitFromCenterAnimator(withDuration: TimeInterval(0.5), isPresenting: self.usingShowModal)
        self.pushWithAnimator(animator, model: model)
    }
    
    private func pushWithSwingInAnimation() {
        let model = BaseViewModel(model: TransitionContentModel(withTitle: "Split from center Animation",
                                                                desc: "Example transition page with Swing In Animation",
                                                                url: "https://github.com/tienpm-0557/mvvm/blob/AddBaseNonGeneric/README.md"))
        let animator = SwingInAnimator(withDuration: TimeInterval(0.5), isPresenting: self.usingShowModal)
        self.pushWithAnimator(animator, model: model)
    }
    
    
    private func pushWithAnimator(_ animator: Animator, model: BaseViewModel) {
        let page = TransitionContentPage(viewModel: model)
        if usingShowModal {
            animator.isPresenting = usingShowModal
            let navPage = NavigationPage(rootViewController: page)
            navPage.statusBarStyle = .default
            navigationService.push(to: navPage, options: .modal(animator: animator))
        } else {
            navigationService.push(to: page, options: .push(with: animator))
        }
    }
    
}


