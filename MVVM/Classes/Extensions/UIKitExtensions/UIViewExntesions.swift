//
//  UIViewExntesions.swift
//  MVVM
//

import UIKit

public extension UIView {
    class var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle.main)
    }
    
    class var nibName: String {
        return String(describing: self)
    }
    
    class var className: String {
        return NSStringFromClass(self.self)
    }
    
    /// Load Xib from name
    static func loadFrom<T: UIView>(nibNamed: String, bundle: Bundle? = nil) -> T? {
        let nib = UINib(nibName: nibNamed, bundle: bundle)
        return nib.instantiate(withOwner: nil, options: nil)[0] as? T
    }
    
    func getGesture<G: UIGestureRecognizer>(_ comparison: ((G) -> Bool)? = nil) -> G? {
        return gestureRecognizers?.first(where: { g -> Bool in
            if let comparison = comparison {
                return g is G && comparison(g as! G)
            }
            
            return g is G
        }) as? G
    }
    
    func getConstraint(byAttribute attr: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        return constraints.first { cst -> Bool in
            return cst.firstAttribute == attr
        }
    }
    
    /// Clear all subviews, destroy if needed
    func clearAll() {
        if let stackView = self as? UIStackView {
            stackView.arrangedSubviews.forEach { view in
                (view as? IDestroyable)?.destroy()
                stackView.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        } else {
            subviews.forEach { view in
                (view as? IDestroyable)?.destroy()
                view.removeFromSuperview()
            }
        }
    }
    
    /// Clear all constraints
    func clearConstraints() {
        constraints.forEach { $0.autoRemove() }
    }
}

public extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable @objc var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable @objc var borderColor: UIColor {
        get {
            let color = UIColor(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowOffset = CGSize.zero
            layer.shadowOpacity = 0.3
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor {
        get {
            return UIColor(cgColor: layer.shadowColor ?? UIColor.black.cgColor)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable var lightShadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowOffset = CGSize(width: 0, height: 0.5)
            layer.shadowOpacity = 1.0
            layer.shadowRadius = shadowRadius
        }
    }
    
    /// Set box shadow
    @objc
    func setShadow(offset: CGSize, color: UIColor, opacity: Float, radius: CGFloat) {
        let shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowPath = shadowPath.cgPath
    }
    
    @objc
    func onUpdateLocalize() {
        for subView: UIView in self.subviews {
            subView.onUpdateLocalize()
        }
    }
    
    /// Set layer border style
    func setBorder(with color: UIColor, width: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    /// Set corder radius for specific corners
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func setupBackgroundGradient(colorTop: CGColor, colorBottom: CGColor) {
        let gl = CAGradientLayer()
        gl.colors = [colorTop, colorBottom]
        gl.startPoint = CGPoint(x: 0, y: 0.5)
        gl.endPoint = CGPoint(x: 1, y: 0.5)
        gl.frame = self.bounds
        self.layer.insertSublayer(gl, at: 0)
    }
}
