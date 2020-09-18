//
//  TimelineCellViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 9/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxCocoa
import RxSwift
import Action

class TimelineCellViewModel: BaseCellViewModel {
    
    var alertService: IAlertService = DependencyManager.shared.getService()
    var shareService: ShareService = DependencyManager.shared.getService()
    
    let rxTitle = BehaviorRelay<String?>(value: "")
    let rxDescription = BehaviorRelay<String?>(value: "")
    let rxCreateDate = BehaviorRelay<String?>(value: "")
    let rxReaction = BehaviorRelay<String?>(value: "")
    let rxThumbnail = BehaviorRelay(value: NetworkImage())
    
    let rxUserDisplayName = BehaviorRelay<String?>(value: "")
    let rxAvatar = BehaviorRelay(value: NetworkImage())
    
    lazy var likeAction: Action<AnyObject, Void> = {
        return Action<AnyObject, Void> { input in
            return .just(self.like(input))
        }
    }()
    
    lazy var commentAction: Action<AnyObject, Void> = {
        return Action<AnyObject, Void> { input in
            return .just(self.comment(input))
        }
    }()
    
    lazy var shareAction: Action<AnyObject, Void> = {
        return Action<AnyObject, Void> { input in
            return .just(self.share(input))
        }
    }()
    
    lazy var reactionAction: Action<AnyObject, Void> = {
        return Action<AnyObject, Void> { input in
            return .just(self.reaction(input))
        }
    }()
    
    lazy var userInfoAction: Action<AnyObject, Void> = {
        return Action<AnyObject, Void> { input in
            return .just(self.userInfo(input))
        }
    }()
    
    override func react() {
        super.react()
        guard let model = self.model as? TimelineModel else { return }
        
        rxTitle.accept(model.title)
        rxDescription.accept(model.desc)
        
        rxCreateDate.accept(model.createDate)
        rxReaction.accept("\(model.reaction)")
        if let thumbnail = URL(string: model.thumbnail) {
            rxThumbnail.accept(NetworkImage(withURL: thumbnail, placeholder: UIImage.from(color: .black)))
        }
        
        if let avatar = URL(string: model.user?.avatar ?? "") {
            rxAvatar.accept(NetworkImage(withURL: avatar, placeholder: UIImage.from(color: .black)))
        }
        
        rxUserDisplayName.accept(model.user?.displayName ?? "")
    }
    
    fileprivate func like(_ sender: AnyObject) {
        if let btn = sender as? Button {
            btn.isSelected = !btn.isSelected
        }
        
        alertService.presentOkayAlert(title: "Like Action", message: "Coming soon!")
    }
    
    fileprivate func comment(_ sender: AnyObject) {
        alertService.presentOkayAlert(title: "Comment Action", message: "Coming soon!")
    }
    
    fileprivate func share(_ sender: AnyObject) {
        shareService.openShare(title: "MVVM",
                               url: "https://github.com/tienpm-0557/mvvm/blob/master/README.md")
    }
    
    fileprivate func reaction(_ sender: AnyObject) {
        alertService.presentOkayAlert(title: "Reaction Action", message: "Coming soon!")
    }
    
    fileprivate func userInfo(_ sender: AnyObject) {
        alertService.presentOkayAlert(title: "User Info Action", message: "Coming soon!")
    }
}
