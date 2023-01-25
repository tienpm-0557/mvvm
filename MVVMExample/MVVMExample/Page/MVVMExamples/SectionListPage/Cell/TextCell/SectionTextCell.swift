//
//  SectionTextCell.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/15/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxCocoa
import RxSwift

class SectionTextCell: BaseTableCell {
    @IBOutlet private weak var titleLbl: UILabel!
    @IBOutlet private weak var descLbl: UILabel!
    @IBOutlet private weak var layout: StackLayout!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLbl.numberOfLines = 0
        titleLbl.font = Font.system.bold(withSize: 17)
        descLbl.numberOfLines = 0
        descLbl.font = Font.system.normal(withSize: 15)
        layout.autoPinEdgesToSuperviewEdges(with: .all(5))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func initialize() {
        super.initialize()
    }

    override func bindViewAndViewModel() {
        guard let viewModel = self.viewModel as? SectionTextCellViewModel else {
            return
        }
        viewModel.rxTitle ~> titleLbl.rx.text => disposeBag
        viewModel.rxDesc ~> descLbl.rx.text => disposeBag
    }
}
