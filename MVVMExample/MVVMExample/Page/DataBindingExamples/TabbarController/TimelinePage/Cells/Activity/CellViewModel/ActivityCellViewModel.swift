//
//  ActivityCellViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 9/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxSwift
import RxCocoa
import Action

class ActivityCellViewModel: BaseCellViewModel {
    let rxTweets = BehaviorRelay<String?>(value: "")
    let rxFollowing = BehaviorRelay<String?>(value: "")
    let rxFollower = BehaviorRelay<String?>(value: "")
    let rxLikes = BehaviorRelay<String?>(value: "")

    override func react() {
        super.react()
        guard let model = self.model as? ActivityModel else {
            return
        }
        rxTweets.accept("\(model.tweets)")
        rxFollowing.accept("\(model.following)")
        rxFollower.accept("\(model.follower)")
        rxLikes.accept("\(model.likes)")
    }
}
