//
//  AnimatorDelegate.swift
//  MVVM
//

import UIKit

public class AnimatorDelegate: NSObject {
    
    let animator: Animator
    
    public init(withAnimator animator: Animator) {
        self.animator = animator
        super.init()
    }
}

extension AnimatorDelegate: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isPresenting = true
        return animator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isPresenting = false
        return animator
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class PresentationController: UIPresentationController {
    
    override var shouldRemovePresentersView: Bool { return true }
}











