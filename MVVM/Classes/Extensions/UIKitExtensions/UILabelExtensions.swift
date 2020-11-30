//
//  UILabelExtensions.swift
//  MVVM
//
//  Created by tienpm on 11/28/20.
//

import Foundation

public extension UILabel {
    public func setLineSpacing(lineSpacing: CGFloat = 0.0,
                        lineHeightMultiple: CGFloat = 0.0,
                        alignment: NSTextAlignment = .left) {
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.alignment = alignment
        paragraphStyle.lineBreakMode = lineBreakMode
        
        let attributedString: NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSMakeRange(0, attributedString.length) )
        
        self.attributedText = attributedString
    }
    
    
    public func setHTMLFromString(htmlText: String, withTextHexColor hex: String = "929292") {
        let modifiedFont = String(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(self.font!.pointSize)\">%@</span>", htmlText)

        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        self.attributedText = attrStr
        self.textColor = UIColor(hexString: hex)
    }
    
    public func setHTMLFromStringWithSettingFontSize(htmlText: String, withTextHexColor hex: String = "929292") {
        var font = self.font!.pointSize
        if let fontSize = UserDefaults.standard.value(forKey: "FontSize") as? CGFloat {
            font = fontSize
        }
        let modifiedFont = String(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(font)\">%@</span>", htmlText)

        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        self.attributedText = attrStr
        self.textColor = UIColor(hexString: hex)
    }
}
