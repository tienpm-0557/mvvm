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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        
    }
}
