//
//  SimpleTableCell.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/14/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import RxCocoa
import MVVM

class SimpleTableCell: BaseTableCell {

    @IBOutlet private weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLbl.autoPinEdgesToSuperviewEdges(with: .symmetric(horizontal: 15, vertical: 10))
    }

    override func initialize() {
        /// Avoid use outlet property here. The function is called before load lib.
        ///Update outlet into awakeFromNib
        selectionStyle = .none
    }
    
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel as? SimpleListPageCellViewModel else { return }
        viewModel.rxTitle ~> titleLbl.rx.text => disposeBag
    }
}

class SimpleListPageCellViewModel: BaseCellViewModel {
    
    let rxTitle = BehaviorRelay<String?>(value: nil)
    
    override func react() {
        guard let viewModel = model as? SimpleModel else {
            return
        }
        rxTitle.accept(viewModel.title)
    }
}

