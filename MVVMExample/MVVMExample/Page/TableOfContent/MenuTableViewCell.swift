//
//  MenuTableViewCell.swift
//  MVVM_Example
//
//  Created by pham.minh.tien on 5/3/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import MVVM
import RxCocoa
import RxSwift

class MenuTableViewCell: BaseTableCell {
    @IBOutlet private weak var titleLbl: UILabel!
    @IBOutlet private weak var descLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        accessoryType = .disclosureIndicator
    }
    
    override func initialize() {
        accessoryType = .disclosureIndicator
        selectionStyle = .none
    }
    
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel as? MenuTableCellViewModel else {
            return
        }
        viewModel.rxTitle ~> titleLbl.rx.text => disposeBag
        viewModel.rxDesc ~> descLbl.rx.text => disposeBag
    }
}

class MenuTableCellViewModel: BaseCellViewModel {
    let rxTitle = BehaviorRelay<String?>(value: nil)
    let rxDesc = BehaviorRelay<String?>(value: nil)
    
    override func react() {
        var title = ""
        var desc = ""
        if let introModel = model as? IntroductionModel {
            title = introModel.title
            desc = introModel.desc
        } else if let menuModel = model as? MenuModel {
            title = menuModel.title
            desc = menuModel.desc
        }
        
        rxTitle.accept(title)
        rxDesc.accept(desc)
    }
}
