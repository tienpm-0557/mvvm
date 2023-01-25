//
//  SectionHeaderListView.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/15/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxSwift
import RxCocoa

class SectionHeaderListView: BaseHeaderTableView {
    @IBOutlet private weak var titleLbl: UILabel!
    @IBOutlet private weak var addBtn: UIButton!

    override class func height(withItem item: BaseViewModel) -> CGFloat {
        return 30
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundView?.backgroundColor = .groupTableViewBackground
    }

    override func bindViewAndViewModel() {
        guard let viewModel = viewModel as? SectionHeaderViewViewModel else {
            return
        }
        viewModel.rxTitle ~> titleLbl.rx.text => disposeBag
        addBtn.rx.bind(to: viewModel.addAction, input: ())
    }
}
