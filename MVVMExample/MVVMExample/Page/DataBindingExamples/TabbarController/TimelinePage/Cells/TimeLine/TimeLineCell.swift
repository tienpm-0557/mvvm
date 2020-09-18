//
//  TimeLineCell.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 9/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxSwift
import RxCocoa

class TimeLineCell: BaseTableCell {
    ///User info
    @IBOutlet private weak var avatarImg: UIImageView!
    @IBOutlet private weak var userDisplayNameLb: UILabel!
    
    @IBOutlet private weak var titleLb: UILabel!
    @IBOutlet private weak var descLb: UILabel!
    @IBOutlet private weak var photoImg: UIImageView!
    @IBOutlet private weak var createDateLb: UILabel!
    @IBOutlet private weak var reactionLb: UILabel!
    @IBOutlet private weak var likeLb: UILabel!
    @IBOutlet private weak var commentLb: UILabel!
    
    @IBOutlet private weak var likeBtn: UIButton!
    @IBOutlet private weak var commentBtn: UIButton!
    @IBOutlet private weak var shareBtn: UIButton!
    @IBOutlet private weak var reactionBtn: UIButton!
    
    @IBOutlet private weak var userInfoBtn: UIButton!
    
    @IBOutlet private weak var separateLineImgHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        separateLineImgHeight.constant = 1 / UIScreen.main.scale
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = self.viewModel as? TimelineCellViewModel else {
            return
        }
        
        viewModel.rxDescription ~> descLb.rx.text => disposeBag
        viewModel.rxCreateDate ~> createDateLb.rx.text => disposeBag
        viewModel.rxTitle ~> titleLb.rx.text => disposeBag
        viewModel.rxReaction ~> reactionLb.rx.text => disposeBag
        viewModel.rxThumbnail ~> photoImg.rx.networkImage => disposeBag
        
        viewModel.rxAvatar ~> avatarImg.rx.networkImage => disposeBag
        viewModel.rxUserDisplayName ~> userDisplayNameLb.rx.text => disposeBag
        
        likeBtn.rx.bind(to: viewModel.likeAction, input: likeBtn)
        commentBtn.rx.bind(to: viewModel.commentAction, input: likeBtn)
        shareBtn.rx.bind(to: viewModel.shareAction, input: likeBtn)
        reactionBtn.rx.bind(to: viewModel.reactionAction, input: reactionBtn)
        userInfoBtn.rx.bind(to: viewModel.userInfoAction, input: userInfoBtn)
    }
}
