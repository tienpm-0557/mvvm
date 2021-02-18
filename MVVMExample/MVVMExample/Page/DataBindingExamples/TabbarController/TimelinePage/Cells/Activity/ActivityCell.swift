//
//  ActivityCell.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 9/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxSwift
import RxCocoa

class ActivityCell: BaseTableCell {
    @IBOutlet private weak var tweetsLb: UILabel!
    @IBOutlet private weak var followingLb: UILabel!
    @IBOutlet private weak var followerLb: UILabel!
    @IBOutlet private weak var likesLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = self.viewModel as? ActivityCellViewModel else {
            return
        }
        
        viewModel.rxTweets ~> tweetsLb.rx.text => disposeBag
        viewModel.rxFollowing ~> followingLb.rx.text => disposeBag
        viewModel.rxFollower ~> followerLb.rx.text => disposeBag
        viewModel.rxLikes ~> likesLb.rx.text => disposeBag   
    }
    
    override func initialize() {
        super.initialize()
    }
}
