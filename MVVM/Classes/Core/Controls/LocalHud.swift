//
//  InlineLoaderView.swift
//  MVVM
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: LocalHud {
    
    public var show: Binder<Bool> {
        return Binder(base) { view, value in
            if value {
                view.show()
            } else {
                view.hide()
            }
        }
    }
}

open class LocalHud: UIView {
    
    /// Subclasses override this method to style and re-layout components
    open func setupView() { }
    
    /// Subclasses override this method to setup a custom show animation if needed
    open func show() { }
    
    /// Subclasses override this method to setup a custom hide animation if needed
    open func hide() { }
}

class DefaultLocalHud: LocalHud {
    
    let label = UILabel()
    let indicatorView = UIActivityIndicatorView(style: .white)
    
    override func setupView() {
        indicatorView.hidesWhenStopped = true
        indicatorView.color = .black
        addSubview(indicatorView)
        indicatorView.autoAlignAxis(toSuperviewAxis: .vertical)
        indicatorView.autoPinEdge(toSuperviewEdge: .top)
        
        label.textColor = .lightGray
        label.font = Font.system.normal(withSize: 15)
        label.text = "LOADING"
        addSubview(label)
        label.autoPinEdge(.top, to: .bottom, of: indicatorView, withOffset: 3)
        label.autoAlignAxis(toSuperviewAxis: .vertical)
        label.autoPinEdge(toSuperviewEdge: .bottom)
        
        // layout self
        autoCenterInSuperview()
    }
    
    override func show() {
        isHidden = false
        indicatorView.startAnimating()
    }
    
    override func hide() {
        isHidden = true
        indicatorView.stopAnimating()
    }
}












