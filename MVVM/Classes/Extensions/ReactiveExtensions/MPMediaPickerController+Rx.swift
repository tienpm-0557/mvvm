//
//  MPMediaPickerController+Rx.swift
//  MVVM
//
//  Created by pham.minh.tien on 12/23/20.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import MediaPlayer

extension Reactive where Base: MPMediaPickerController {
    public var pickerDelegate: DelegateProxy<MPMediaPickerController,
                                             MPMediaPickerControllerDelegate > {
        return RxMediaPickerDelegateProxy.proxy(for: base)
    }
    
    public var didPickMediaItems: Observable<[MPMediaItem]> {
        return pickerDelegate.methodInvoked(#selector(MPMediaPickerControllerDelegate.mediaPicker(_:didPickMediaItems:))).map({ info in
            if let mediaCollection = info[1] as? MPMediaItemCollection {
                return mediaCollection.items
            }
            return []
        })
    }
    
    public var didCancel: Observable<()> {
        return pickerDelegate.methodInvoked(#selector(MPMediaPickerControllerDelegate.mediaPickerDidCancel(_:))).map { _ in () }
    }
}

public class RxMediaPickerDelegateProxy : DelegateProxy<MPMediaPickerController,
                                                        MPMediaPickerControllerDelegate>,
                                          DelegateProxyType,
                                          MPMediaPickerControllerDelegate,
                                          UINavigationControllerDelegate {
    public init(imagePicker: MPMediaPickerController) {
        super.init(parentObject: imagePicker,
                   delegateProxy: RxMediaPickerDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxMediaPickerDelegateProxy(imagePicker: $0) }
    }
    
    public static func currentDelegate(for object: MPMediaPickerController) -> (MPMediaPickerControllerDelegate)? {
        return object.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: (MPMediaPickerControllerDelegate)?, to object: MPMediaPickerController) {
        object.delegate = delegate
    }
}

extension Reactive where Base: MPMediaPickerController {
    static public func createWithParent(_ parent: UIViewController?,
                                        animated: Bool = true,
                                        configureImagePicker: @escaping (MPMediaPickerController) throws -> () = { _ in })
    -> Observable<MPMediaPickerController> {
        return Observable.create { [weak parent] observer in
            let mediaPicker = MPMediaPickerController()
            let dismissDisposable = Observable.merge(
                mediaPicker.rx.didPickMediaItems.map{ _ in ()},
                mediaPicker.rx.didCancel
            )
            .subscribe(onNext: {  _ in
                observer.on(.completed)
            })
            
            do {
                try configureImagePicker(mediaPicker)
            }
            catch let error {
                observer.on(.error(error))
                return Disposables.create()
            }
            
            guard let parent = parent else {
                observer.on(.completed)
                return Disposables.create()
            }
            
            parent.present(mediaPicker, animated: animated, completion: nil)
            observer.on(.next(mediaPicker))
            
            return Disposables.create(dismissDisposable, Disposables.create {
                dismissViewController(mediaPicker, animated: animated)
            })
        }
    }
}
