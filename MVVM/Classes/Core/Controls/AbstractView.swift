//
//  AbstractView.swift
//  MVVM
//

import UIKit

open class AbstractView: UIView {
    
    public static func nibName() -> String{
        return String(describing: self)
    }
    
    public init() {
        super.init(frame: .zero)
        initialize()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    open func initialize() {}
    open func setupView() {}
}

open class AbstractControlView: UIControl {
    
    public init() {
        super.init(frame: .zero)
        setupView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    open func setupView() {}
}
