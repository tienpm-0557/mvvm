//
//  AbsoluteLayout.swift
//  MVVM
//
//  Created by Macintosh HD on 5/6/19.
//

import UIKit

open class AbsoluteLayout: UIView {
    
    public enum SizeAttribute {
        case none
        case fix(CGFloat)
        case ratio(CGFloat)
    }
    
    public enum PositionAttribute {
        case top(CGFloat)
        case left(CGFloat)
        case bottom(CGFloat)
        case right(CGFloat)
    }
    
    public struct AbsoluteStyle {
        let width: SizeAttribute
        let height: SizeAttribute
        let positions: [PositionAttribute]
        
        public init(positions: [PositionAttribute], width: SizeAttribute = .none, height: SizeAttribute = .none) {
            self.positions = positions
            self.width = width
            self.height = height
        }
    }
    
    public enum AbsolutePosition {
        case absolute(top: CGFloat?, left: CGFloat?, bottom: CGFloat?, right: CGFloat?)
        case topLeft(width: SizeAttribute, height: SizeAttribute)
        case centerTop(width: SizeAttribute, height: SizeAttribute)
        case topRight(width: SizeAttribute, height: SizeAttribute)
        case centerRight(width: SizeAttribute, height: SizeAttribute)
        case bottomRight(width: SizeAttribute, height: SizeAttribute)
        case centerBottom(width: SizeAttribute, height: SizeAttribute)
        case bottomLeft(width: SizeAttribute, height: SizeAttribute)
        case centerLeft(width: SizeAttribute, height: SizeAttribute)
        case fill(insets: UIEdgeInsets)
    }
    
    public init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Subclasses use this for customizations
    open func setupView() {}
}

public extension AbsoluteLayout {
    
    /// Add a child to layout with specific positions
    @discardableResult
    func addChild(_ child: UIView, position: AbsolutePosition = .fill(insets: .zero), width: SizeAttribute = .none, height: SizeAttribute = .none) -> AbsoluteLayout {
        addSubview(child)
        switch position {
        case .absolute(let top, let left, let bottom, let right):
            if let top = top {
                child.autoPinEdge(toSuperviewEdge: .top, withInset: top)
            }
            
            if let left = left {
                child.autoPinEdge(toSuperviewEdge: .leading, withInset: left)
            }
            
            if let bottom = bottom {
                child.autoPinEdge(toSuperviewEdge: .bottom, withInset: bottom)
            }
            
            if let right = right {
                child.autoPinEdge(toSuperviewEdge: .trailing, withInset: right)
            }
            
        case .topLeft:
            child.autoPinEdge(toSuperviewEdge: .top)
            child.autoPinEdge(toSuperviewEdge: .leading)
            
        case .centerTop:
            child.autoPinEdge(toSuperviewEdge: .top)
            child.autoAlignAxis(toSuperviewAxis: .vertical)
            
        case .topRight:
            child.autoPinEdge(toSuperviewEdge: .top)
            child.autoPinEdge(toSuperviewEdge: .trailing)

            
        case .centerRight:
            child.autoPinEdge(toSuperviewEdge: .trailing)
            child.autoAlignAxis(toSuperviewAxis: .horizontal)
            
        case .bottomRight:
            child.autoPinEdge(toSuperviewEdge: .bottom)
            child.autoPinEdge(toSuperviewEdge: .trailing)
            
        case .centerBottom:
            child.autoPinEdge(toSuperviewEdge: .bottom)
            child.autoAlignAxis(toSuperviewAxis: .vertical)
            
        case .bottomLeft:
            child.autoPinEdge(toSuperviewEdge: .bottom)
            child.autoPinEdge(toSuperviewEdge: .leading)
            
        case .centerLeft:
            child.autoPinEdge(toSuperviewEdge: .leading)
            child.autoAlignAxis(toSuperviewAxis: .horizontal)
            
        case .fill(let insets):
            child.autoPinEdgesToSuperviewEdges(with: insets)
        }
        
        switch width {
        case .fix(let value):
            child.autoSetDimension(.width, toSize: value)
        case .ratio(let value):
            child.autoMatch(.width, to: .width, of: self, withMultiplier: value)
        default: ()
        }
        
        switch height {
        case .fix(let value):
            child.autoSetDimension(.height, toSize: value)
        case .ratio(let value):
            child.autoMatch(.height, to: .height, of: self, withMultiplier: value)
        default: ()
        }
        
        return self
    }
}


