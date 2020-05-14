//
//  NavigationService.swift
//  MVVM
//

import UIKit

public enum PushType {
    case auto, push, modally(UIModalPresentationStyle), popup(PopupOptions)
}

public enum PopType {
    case auto, pop, popToRoot, popTo(index: Int), dismiss, dismissPopup
}

/// Popup options, allow to change overlay color and enable dimiss when tap outside the popup
public struct PopupOptions {
    
    public let shouldDismissOnTapOutside: Bool
    public let overlayColor: UIColor
    
    public init(shouldDismissOnTapOutside: Bool = true, overlayColor: UIColor = UIColor(r: 0, g: 0, b: 0, a: 0.7)) {
        self.shouldDismissOnTapOutside = shouldDismissOnTapOutside
        self.overlayColor = overlayColor
    }
    
    public static var defaultOptions: PopupOptions {
        return PopupOptions()
    }
}

/// Push options for pushing new page, including push, modally or popup
public struct PushOptions {
    
    public let pushType: PushType
    public let animator: Animator?
    public let animated: Bool
    
    public init(pushType: PushType = .auto, animator: Animator? = nil, animated: Bool = true) {
        self.pushType = pushType
        self.animator = animator
        self.animated = animated
    }
    
    public static var defaultOptions: PushOptions {
        return PushOptions()
    }
    
    public static var auto: PushOptions {
        return PushOptions(pushType: .auto)
    }
    
    public static func push(with animator: Animator? = nil) -> PushOptions {
        return PushOptions(pushType: .push, animator: animator)
    }
    
    public static func modal(presentationStyle: UIModalPresentationStyle = .currentContext, animator: Animator? = nil) -> PushOptions {
        return PushOptions(pushType: .modally(presentationStyle), animator: animator)
    }
    
    public static func popup(_ options: PopupOptions = .defaultOptions) -> PushOptions {
        return PushOptions(pushType: .popup(options))
    }
}

/// Pop options for poping/dismissing current active page
public struct PopOptions {
    
    public let popType: PopType
    public let animated: Bool
    
    public init(popType: PopType = .auto, animated: Bool = true) {
        self.popType = popType
        self.animated = animated
    }
    
    public static var defaultOptions: PopOptions {
        return PopOptions()
    }
    
    public static var auto: PopOptions {
        return PopOptions(popType: .auto)
    }
    
    public static var pop: PopOptions {
        return PopOptions(popType: .pop)
    }
    
    public static var popToRoot: PopOptions {
        return PopOptions(popType: .popToRoot)
    }
    
    public static func popTo(index: Int) -> PopOptions {
        return PopOptions(popType: .popTo(index: index))
    }
    
    public static var dismiss: PopOptions {
        return PopOptions(popType: .dismiss)
    }
    
    public static var dismissPopup: PopOptions {
        return PopOptions(popType: .dismissPopup)
    }
}

public protocol INavigationService {
    
    func push(to page: UIViewController, options: PushOptions)
    func pop(with options: PopOptions)
}

extension INavigationService {
    
    public func push(to page: UIViewController, options: PushOptions = .defaultOptions) {
        push(to: page, options: options)
    }
    
    public func pop(with options: PopOptions = .defaultOptions) {
        pop(with: options)
    }
}

public class NavigationService: INavigationService {
    
    private var topPage: UIViewController? {
        return DDConfigurations.topPageFindingBlock.create()
    }
    
    // MARK: - Push functions
    
    public func push(to page: UIViewController, options: PushOptions) {
        guard let topPage = topPage else { return }
        
        let handlePush = {
            if let animator = options.animator {
                // attach animtor to destination page
                (page as? ITransitionView)?.animatorDelegate = AnimatorDelegate(withAnimator: animator)
            }
            
            topPage.navigationController?.pushViewController(page, animated: options.animated)
        }
        
        let handleModal = { (presentationStyle: UIModalPresentationStyle) in
            if let animator = options.animator {
                let delegate = AnimatorDelegate(withAnimator: animator)
                (page as? ITransitionView)?.animatorDelegate = delegate
                page.transitioningDelegate = delegate
                page.modalPresentationStyle = presentationStyle
            }
            
            topPage.present(page, animated: options.animated)
        }
        
        switch options.pushType {
        case .auto:
            if topPage.navigationController != nil {
                handlePush()
            } else {
                handleModal(.custom)
            }
            
        case .push: handlePush()
            
        case .modally(let presentationStyle): handleModal(presentationStyle)
            
        case .popup(let options):
            let presenterPage = PresenterPage(contentPage: page, options: options)
            presenterPage.modalPresentationStyle = .overFullScreen
            topPage.present(presenterPage, animated: false)
        }
    }
    
    // MARK: - Pop functions
    
    public func pop(with options: PopOptions) {
        guard let topPage = topPage else { return }
        
        let destroyPageBlock = DDConfigurations.destroyPageBlock
        let handleDismiss = {
            topPage.dismiss(animated: options.animated) {
                destroyPageBlock(topPage)
                destroyPageBlock(topPage.navigationController)
                destroyPageBlock(topPage.tabBarController)
            }
        }
        
        switch options.popType {
        case .auto:
            if let navPage = topPage.navigationController {
                navPage.popViewController(animated: options.animated) { destroyPageBlock($0) }
            } else {
                handleDismiss()
            }
            
        case .pop:
            topPage.navigationController?.popViewController(animated: options.animated) { destroyPageBlock($0) }
            
        case .popToRoot:
            topPage.navigationController?.popToRootViewController(animated: options.animated) { pages in
                pages?.forEach { destroyPageBlock($0) }
            }
            
        case .popTo(let index):
            topPage.navigationController?.popToViewController(at: index, animated: options.animated) { pages in
                pages?.forEach { destroyPageBlock($0) }
            }
            
        case .dismiss:
            handleDismiss()
            
        case .dismissPopup:
            let presenterPage = topPage.navigationController?.parent ?? topPage.tabBarController?.parent ?? topPage.parent ?? topPage
            presenterPage.dismiss(animated: false)
        }
    }
}






