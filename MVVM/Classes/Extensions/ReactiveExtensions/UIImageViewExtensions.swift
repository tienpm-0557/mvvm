//
//  UIImageViewExtensions.swift
//  MVVM
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import AlamofireImage

public struct NetworkImage {
    
    public private(set) var url: URL? = nil
    public private(set) var placeholder: UIImage? = nil
    public private(set) var completion: ((AFIDataResponse<UIImage>) -> Void)? = nil
    
    public init(withURL url: URL? = nil, placeholder: UIImage? = nil, completion: ((AFIDataResponse<UIImage>) -> Void)? = nil) {
        self.url = url
        self.placeholder = placeholder
        self.completion = completion
    }
}

public extension Reactive where Base: UIImageView {
    
    /// Simple binder for `NetworkImage`
    var networkImage: Binder<NetworkImage> {
        return networkImage()
    }
    
    /// Optional image transition and completion that allow View to do more action after completing download image
    func networkImage(_ imageTransition: UIImageView.ImageTransition = .crossDissolve(0.25), completion: ((AFIDataResponse<UIImage>) -> Void)? = nil) -> Binder<NetworkImage> {
        return Binder(base) { view, image in
            if let placeholder = image.placeholder {
                view.image = placeholder
            }
            
            if let url = image.url {
                view.af_setImage(withURL: url, imageTransition: imageTransition, completion: { response in
                    /// callback for ViewModel to handle after completion
                    image.completion?(response)
                    
                    /// callback for View to handle after completion
                    completion?(response)
                })
            }
        }
    }
}








