//
//  SectionFooterListView.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/16/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxSwift
import RxCocoa


class SectionFooterListView: BaseHeaderTableView {
    
    @IBOutlet private weak var titleLbl: UILabel!
    @IBOutlet private weak var descLbl: UILabel!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override class func height(withItem _item: BaseViewModel) -> CGFloat {
        return 60
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundView?.backgroundColor = .groupTableViewBackground
    }
    
    override func initialize() {
        
    }
    
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel as? SectionHeaderViewViewModel else { return }

        viewModel.rxFooter ~> titleLbl.rx.text => disposeBag
        viewModel.rxDesc ~> descLbl.rx.text => disposeBag
    }


}
