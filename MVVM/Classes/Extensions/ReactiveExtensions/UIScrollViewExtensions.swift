//
//  UIScrollViewExtensions.swift
//  MVVM
//

import UIKit
import RxSwift

public extension Reactive where Base: UIScrollView {
    
    func endReach(_ distance: CGFloat) -> Observable<Void> {
        return Observable.create { observer in
            return self.base.rx.contentOffset.subscribe(onNext: { offset in
                let scrollViewHeight = self.base.frame.size.height
                let scrollContentSizeHeight = self.base.contentSize.height
                let scrollOffset = offset.y
                
                let scrollSize = scrollOffset + scrollViewHeight
                
                // at the bottom
                if scrollSize >= scrollContentSizeHeight - distance {
                    observer.onNext(())
                }
            })
        }
    }
}
