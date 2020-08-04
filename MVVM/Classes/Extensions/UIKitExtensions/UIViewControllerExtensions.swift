//
//  UINavigationControllerExtensions.swift
//  MVVM
//

import UIKit

extension UIViewController {
    @objc open func onUpdateLocalize() {
        self.view.onUpdateLocalize()
    }
}

public extension UINavigationController {
    
    func popViewController(animated: Bool, completions: ((UIViewController?) -> Void)?) {
        if animated {
            CATransaction.begin()
            let page = popViewController(animated: animated)
            CATransaction.setCompletionBlock { completions?(page) }
            CATransaction.commit()
        } else {
            let page = popViewController(animated: animated)
            completions?(page)
        }
    }
    
    func popToRootViewController(animated: Bool, completions: (([UIViewController]?) -> Void)?) {
        if animated {
            CATransaction.begin()
            let pages = popToRootViewController(animated: animated)
            CATransaction.setCompletionBlock { completions?(pages) }
            CATransaction.commit()
        } else {
            let pages = popToRootViewController(animated: animated)
            completions?(pages)
        }
    }
    
    func popToViewController(at index: Int, animated: Bool, completions: (([UIViewController]?) -> Void)?) {
        let len = viewControllers.count
        if index >= 0 && index < len - 1 {
            if animated {
                CATransaction.begin()
                let pages = popToViewController(viewControllers[index], animated: animated)
                CATransaction.setCompletionBlock { completions?(pages) }
                CATransaction.commit()
            } else {
                let pages = popToViewController(viewControllers[index], animated: animated)
                completions?(pages)
            }
        }
    }
    
    func popToViewController(_ viewController: UIViewController, animated: Bool, completions: (([UIViewController]?) -> Void)?) {
        if animated {
            CATransaction.begin()
            let pages = popToViewController(viewController, animated: animated)
            CATransaction.setCompletionBlock { completions?(pages) }
            CATransaction.commit()
        } else {
            let pages = popToViewController(viewController, animated: animated)
            completions?(pages)
        }
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool, completions: (() -> Void)?) {
        if animated {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completions)
            pushViewController(viewController, animated: animated)
            CATransaction.commit()
        } else {
            pushViewController(viewController, animated: animated)
            completions?()
        }
    }
}

