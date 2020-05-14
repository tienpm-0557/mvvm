//
//  ScrollLayout.swift
//  MVVM
//
//  Created by Macintosh HD on 5/6/19.
//

import UIKit

/// Wrap scroll view into a horizontal or vertical stack layout
public class ScrollLayout: UIScrollView {
    
    private let layout = StackLayout()
    private let containerView = UIView()
    
    private var topConstraint: NSLayoutConstraint!
    private var leftConstraint: NSLayoutConstraint!
    private var bottomConstraint: NSLayoutConstraint!
    private var rightConstraint: NSLayoutConstraint!
    
    /// List of subviews inside stack layout
    public var children: [UIView] {
        return layout.arrangedSubviews
    }
    
    public init(axis: NSLayoutConstraint.Axis = .vertical) {
        layout.direction(axis)
        super.init(frame: .zero)
        
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        addSubview(containerView)
        containerView.autoPinEdgesToSuperviewEdges()
        switch layout.axis {
        case .vertical:
            alwaysBounceVertical = true
            containerView.autoMatch(.width, to: .width, of: self)
        default:
            alwaysBounceHorizontal = true
            containerView.autoMatch(.height, to: .height, of: self)
        }
        
        containerView.addSubview(layout)
        topConstraint = layout.autoPinEdge(toSuperviewEdge: .top)
        leftConstraint = layout.autoPinEdge(toSuperviewEdge: .leading)
        bottomConstraint = layout.autoPinEdge(toSuperviewEdge: .bottom)
        rightConstraint = layout.autoPinEdge(toSuperviewEdge: .trailing)
    }
    
    private func updatePaddings(_ paddings: UIEdgeInsets) {
        topConstraint.constant = paddings.top
        leftConstraint.constant = paddings.left
        bottomConstraint.constant = -paddings.bottom
        rightConstraint.constant = -paddings.right
    }
}

public extension ScrollLayout {
    
    /// Append a child into stack layout, accept only UIView or StackItem type,
    /// otherwise will be ignore
    @discardableResult
    func appendChild(_ child: Any) -> ScrollLayout {
        layout.children([child])
        return self
    }
    
    /// Append children into stack layout, accept only UIView or StackItem type,
    /// otherwise will be ignore
    @discardableResult
    func appendChildren(_ children: [Any]) -> ScrollLayout {
        layout.children(children)
        return self
    }
    
    /// Insert a specific child at index
    @discardableResult
    func insertChild(_ child: Any, at index: Int) -> ScrollLayout {
        layout.child(child, at: index)
        return self
    }
    
    /// Remove a specific child at index
    @discardableResult
    func removeChild(at index: Int) -> ScrollLayout {
        layout.removeChild(at: index)
        return self
    }
    
    /// Remove all children inside the layout
    @discardableResult
    func removeAll() -> ScrollLayout {
        layout.clearAll()
        return self
    }
    
    /// Remove all children inside the layout
    @discardableResult
    func paddings(_ insets: UIEdgeInsets = .zero) -> ScrollLayout {
        updatePaddings(insets)
        return self
    }
    
    /// Spacing between items
    @discardableResult
    func interitemSpacing(_ value: CGFloat) -> ScrollLayout {
        layout.spacing(value)
        return self
    }
}
