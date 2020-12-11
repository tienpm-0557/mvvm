//
//  ContactListPageViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/22/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import Action
import RxSwift
import RxCocoa


class WrapperPage: NavigationPage, IPopupView {
    
    var widthConstraint: NSLayoutConstraint!
    var heightConstraint: NSLayoutConstraint!
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { (_) in
            self.adjustPopupSize()
        }, completion: nil)
        
    }
    
    func popupLayout() {
        view.cornerRadius = 7
        view.autoCenterInSuperview()
        widthConstraint = view.autoSetDimension(.width, toSize: 320)
        heightConstraint = view.autoSetDimension(.height, toSize: 480)
    }
    
    func show(overlayView: UIView) {
        adjustPopupSize()
        
        view.transform = CGAffineTransform(scaleX: 0, y: 0)
        view.isHidden = false
        
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut,
                       animations: {
                        
            overlayView.alpha = 1
            self.view.transform = .identity
                        
        }, completion: nil)
    }
    
    func hide(overlayView: UIView, completion: @escaping (() -> ())) {
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
                        
            overlayView.alpha = 0
            self.view.alpha = 0
            self.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                        
        }) { _ in
            completion()
        }
    }
    
    private func adjustPopupSize() {
        guard let superview = view.superview else { return }
        if superview.bounds.height < heightConstraint.constant {
            heightConstraint.constant = superview.bounds.height - 20
        } else {
            heightConstraint.constant = 480
        }
        
        if superview.bounds.width < widthConstraint.constant {
            widthConstraint.constant = superview.bounds.width - 20
        } else {
            widthConstraint.constant = 320
        }
        
        view.layoutIfNeeded()
    }
}

class ContactListPageViewModel: BaseListViewModel {

    lazy var addAction: Action<Void, Void> = {
        return Action() { .just(self.add())}
    }()
    
    private func add() {
        handleContactModification()
    }
    
    override func selectedItemDidChange(_ cellViewModel: BaseCellViewModel, _ indexPath: IndexPath) {
        guard let model = cellViewModel.model as? ContactModel else {
            return
        }
        handleContactModification(model)
    }
    
    private func handleContactModification(_ model: ContactModel? = nil) {
        let vm = ContactEditPageViewModel(model: model)
        let page = ContactEditPage(viewModel: vm)
        
        // as you are controlling the ViewModel of edit page,
        // so we can get the result out without using any Delegates
        vm.saveAction.executionObservables.switchLatest().subscribe(onNext: { contactModel in
            if model == nil {
                let cvm = ContactCellViewModel(model: contactModel)
                self.itemsSource.append(cvm)
            } else if let cvm = self.rxSelectedItem.value {
                cvm.model = contactModel
            }
        }) => disposeBag
        
        let navPage = WrapperPage(rootViewController: page)
        navigationService.push(to: navPage, options: PushOptions(pushType: .popup(.defaultOptions)))
    }
}
