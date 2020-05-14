//
//  UIGestureRecognizerExtensions.swift
//  MVVM
//

import UIKit
import RxSwift
import RxCocoa
import Action

public extension Reactive where Base: UIGestureRecognizer {
    
    var isEnabled: Binder<Bool> {
        return Binder(base) { $0.isEnabled = $1 }
    }
}

public extension UIGestureRecognizer {
    
    /// Bind action with input transformation
    func bind<Input, Output>(to action: Action<Input, Output>, inputTransform: @escaping (UIGestureRecognizer) -> (Input))   {
        // This effectively disposes of any existing subscriptions.
        unbindAction()
        
        // For each tap event, use the inputTransform closure to provide an Input value to the action
        rx.event
            .map { _ in inputTransform(self) }
            .bind(to: action.inputs)
            .disposed(by: actionDisposeBag)
        
        // Bind the enabled state of the control to the enabled state of the action
        action
            .enabled
            .bind(to: rx.isEnabled)
            .disposed(by: actionDisposeBag)
    }
    
    /// Bind action with static input
    func bind<Input, Output>(to action: Action<Input, Output>, input: Input)   {
        bind(to: action) { _ in input }
    }
    
    /// Unbinds any existing action, disposing of all subscriptions.
    func unbindAction() {
        resetActionDisposeBag()
    }
}
