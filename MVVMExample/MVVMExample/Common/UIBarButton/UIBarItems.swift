//
//  SettingButtonView.swift
//  LetsSee
//
//  Created by tienpm on 11/15/20.
//

import UIKit
import Action
import MVVM
import RxSwift
import RxCocoa
/// For example
/*
 * Ex create Navigation bar button with title. (Title Only)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem.titleButton(withTitle: "MENU",
                                                                        withAction: viewModel.rxMenuAction)
 
 * Ex create Menu Icon Button. (Icon Only)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem.imageButton(withImage: "icon-menu",
                                                                        withAction: viewModel.rxMenuAction)
 
 * Ex create navi back button. (Icon & Title)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem.barButton(withContentInsets: UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0),
                                                                      withTitle: "Back",
                                                                      withImage: "icon-back",
                                                                      withTitleColor: UIColor(hexString: "2ECC71"),
                                                                      withAction: viewModel.rxMenuAction)
 
 
 * Ex create notification button with badge.
    self.navigationItem.rightBarButtonItem = UIBarButtonItem.bagdeButton(withImage: "icon-notifi",
                                                                        withAction: viewModel.rxNotifiAction,
                                                                        withBagde: viewModel.rxBagde.asObservable())
 
 ### TITLE VIEW:
 * Ex Title View.
    self.navigationItem.titleView = UIBarTitle.imageTitleView(withTitle: "Home Screen")
 
 * Ex Title View with Image.
    self.navigationItem.titleView = UIBarTitle.imageTitleView(withTitle: "Home Screen", withImage: "icon-notifi")
 
 * Ex Title View With Dropdown action
 
 */
///

//MARK: Custom View For NavigationBar UIBarButtonItem

let kUIBarItemsNibName: String = "UIBarItems"

struct UIBarButtonOption {
    var frame: CGRect
    var contentInset: UIEdgeInsets?
    var title: String?
    var selectedTitle: String?
    var font: UIFont?
    var image: String?
    var selectedImage: String?
    var titleColor: UIColor?
    var selectedTitleColor: UIColor?
    var hasBagde: Bool
    var bagde: Observable<Int?>?
    var cornerRadius: CGFloat
    var roundCorners: UIRectCorner
    
    init(frame: CGRect = CGRect(x: 0, y: 0, width: 40, height: 40),
         title: String? = nil,
         selectedTitle: String? = nil,
         titleColor: UIColor? = UIColor.black,
         selectedTitleColor: UIColor? = UIColor.black,
         font: UIFont? = UIFont.systemFont(ofSize: 14),
         image: String? = nil,
         selectedImage: String? = nil,
         hasBagde: Bool = false,
         bagde: Observable<Int?>? = nil,
         cornerRadius: CGFloat = 0.0,
         roundCorners: UIRectCorner = .allCorners,
         contentInset: UIEdgeInsets? = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        self.frame = frame
        self.title = title
        self.selectedTitle = selectedTitle
        self.font = font
        self.image = image
        self.selectedImage = selectedImage
        self.cornerRadius = cornerRadius
        self.roundCorners = roundCorners
        self.titleColor = titleColor
        self.hasBagde = hasBagde
        self.bagde = bagde
        self.selectedTitleColor = selectedTitleColor
        self.contentInset = contentInset
    }
}

class UIBarButton: UIView {
    @IBOutlet private weak var barButton: UIButton!
    @IBOutlet private weak var bagdeLabel: UILabel!
    @IBOutlet private weak var bagdeView: UIView!
    
    private var disposeBag = DisposeBag()
    
    class func instanceFromNib(withOption option: UIBarButtonOption,
                               action: Action<AnyObject, Void>) -> UIBarButton {
        var view: UIBarButton?
        let nib = UINib(nibName: kUIBarItemsNibName, bundle: Bundle.main)
        nib.instantiate(withOwner: nil, options: nil).forEach { v in
            if v is UIBarButton { view = v as? UIBarButton }
        }
        
        guard let barBtn = view else {
            return UIBarButton()
        }
        
        barBtn.barButton.setTitle(option.title, for: .normal)
        barBtn.barButton.setTitle(option.selectedTitle, for: .selected)
        barBtn.barButton.setTitleColor(option.titleColor, for: .normal)
        barBtn.barButton.titleLabel?.font = option.font
        barBtn.frame = option.frame
        barBtn.barButton.setImage(UIImage(named: option.image ?? ""),
                                  for: .normal)
        barBtn.barButton.setImage(UIImage(named: option.selectedImage ?? ""),
                                  for: .selected)
        barBtn.barButton.rx.bind(to: action, input: (barBtn.barButton))
        
        if option.hasBagde {
            barBtn.bagdeView.isHidden = false
        } else {
            barBtn.bagdeView.isHidden = true
        }
        
        option.bagde?.subscribe(onNext: { bagde in
            if let bd = bagde, bd > 0 {
                barBtn.bagdeView.isHidden = false
                barBtn.bagdeLabel.text = "\(bd)"
            } else {
                barBtn.bagdeView.isHidden = true
            }
        }) => barBtn.disposeBag
        barBtn.roundCorners(corners: option.roundCorners, radius: option.cornerRadius)
        barBtn.barButton.contentEdgeInsets = option.contentInset ?? UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        return barBtn
    }
}

extension UIBarButtonItem {
    convenience init(withOption option: UIBarButtonOption,
                             withAction action: Action<AnyObject, Void>) {
        self.init()
        customView = UIBarButton.instanceFromNib(withOption: option, action: action)
    }

    static func barButton(withFrame frame: CGRect = CGRect(x: 0, y: 0, width: 60, height: 40),
                          withContentInsets contentInsets: UIEdgeInsets? = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                          withTitle title: String,
                          withImage image: String,
                          withTitleColor color: UIColor? = UIColor.black,
                          withAction action: Action<AnyObject, Void>) -> UIBarButtonItem {
        let option = UIBarButtonOption(frame: frame,
                                       title: title,
                                       selectedTitle: title,
                                       titleColor: color,
                                       selectedTitleColor: color,
                                       image: image,
                                       selectedImage: image,
                                       contentInset: contentInsets)
        return UIBarButtonItem(withOption: option, withAction: action)
    }
    
    static func titleButton(withFrame frame: CGRect = CGRect(x: 0, y: 0, width: 60, height: 40),
                            withTitle title: String,
                            withAction action: Action<AnyObject, Void>) -> UIBarButtonItem {
        let option = UIBarButtonOption(frame: frame, title: title, selectedTitle: title)
        return UIBarButtonItem(withOption: option, withAction: action)
    }
    
    static func imageButton(withFrame frame: CGRect = CGRect(x: 0, y: 0, width: 60, height: 40),
                            withImage image: String,
                            withSelectedImage selectedImage: String? = nil,
                            withAction action: Action<AnyObject, Void>) -> UIBarButtonItem {
        let option = UIBarButtonOption(frame: frame, image: image, selectedImage: selectedImage ?? image)
        return UIBarButtonItem(withOption: option, withAction: action)
    }
    
    static func bagdeButton(withFrame frame: CGRect = CGRect(x: 0, y: 0, width: 40, height: 40),
                           withImage image: String,
                           withSelectedImage selectedImage: String? = nil,
                           withAction action: Action<AnyObject, Void>,
                           withBagde bagde: Observable<Int?>) -> UIBarButtonItem {
        let option = UIBarButtonOption(frame: frame,
                                       image: image,
                                       selectedImage: selectedImage ?? image,
                                       hasBagde: true,
                                       bagde: bagde)
        return UIBarButtonItem(withOption: option, withAction: action)
    }
}

//MARK: - NavigationBar Title View
enum UIBarTitleType {
    case normal
    case image
    case dropdown
}

class UIBarTitle: UIView {
    @IBOutlet private weak var titleLb: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var dropdownBtn: UIButton!
    
    private var disposeBag = DisposeBag()
    
    class func instanceFromNib(title: String,
                               frame: CGRect,
                               image: String? = nil,
                               dropdownIcon icon: String? = nil,
                               type: UIBarTitleType = .normal) -> UIBarTitle {
        var view: UIBarTitle?
        let nib = UINib(nibName: kUIBarItemsNibName, bundle: Bundle.main)
        nib.instantiate(withOwner: nil, options: nil).forEach { v in
            if v is UIBarTitle { view = v as? UIBarTitle }
        }
        
        guard let titleView = view else {
            return UIBarTitle()
        }
        
        titleView.frame = frame
        titleView.setupView(withImage: image,
                            withTitle: title)
        switch type {
        case .dropdown:
            titleView.setupDropView(image: icon)
            
        default:
            ()
        }
        return titleView
    }
    
    private func setupDropView(image: String?) {
        dropdownBtn.isHidden = false
        dropdownBtn.setImage(UIImage(named: image ?? ""), for: .normal)
    }
    
    private func setupView(withImage image: String?,
                           withTitle title: String) {
        dropdownBtn.isHidden = true
        imageView.isHidden = image == nil
        imageView.image = UIImage(named: image ?? "")
        titleLb.text = title
    }
    
    class func imageTitleView(withTitle title: String,
                              withFrame frame: CGRect = CGRect(x: 0, y: 0, width: 80, height: 40),
                              withImage image: String? = nil) -> UIBarTitle {
        let titleView = UIBarTitle.instanceFromNib(title: title,
                                                   frame: frame,
                                                   image: image,
                                                   type: .image)
        return titleView
    }
    
    class func dropdownTitleView(withTitle title: String,
                                 withDropdownIcon icon: String?,
                                 withFrame frame: CGRect = CGRect(x: 0, y: 0, width: 80, height: 40)) -> UIBarTitle {
        let titleView = UIBarTitle.instanceFromNib(title: title,
                                                   frame: frame,
                                                   dropdownIcon: icon,
                                                   type: .dropdown)
        return titleView
    }
    
    class func imageWithDropdownTitleView(withTitle title: String,
                                          withFrame frame: CGRect = CGRect(x: 0, y: 0, width: 80, height: 40),
                                          withImage image: String? = nil) -> UIBarTitle {
        let titleView = UIBarTitle.instanceFromNib(title: title,
                                                   frame: frame,
                                                   image: image,
                                                   type: .image)
        return titleView
    }
}
