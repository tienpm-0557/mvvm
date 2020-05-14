//
//  UINavigationItemExtensions.swift
//  MVVM
//

import UIKit

extension UINavigationItem {
    
    @discardableResult
    @objc open func setTitle(_ title: String? = nil, textColor: UIColor = .white, alignment: NSTextAlignment = .center, font: UIFont = Font.system.bold(withSize: 18)) -> UILabel {
        let titleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        titleLbl.textColor = textColor
        titleLbl.text = title
        titleLbl.textAlignment = alignment
        titleLbl.font = font
        titleView = titleLbl
    
        return titleLbl
    }
}








