//
//  ContactTableViewCell.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/22/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import Action
import RxCocoa
import RxSwift

class ContactTableViewCell: BaseTableCell {
    @IBOutlet private weak var avatarIv: UIImageView!
    @IBOutlet private weak var nameLbl: UILabel!
    @IBOutlet private weak var phoneLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarIv.image = UIImage(named: "default-contact")
        
        nameLbl.numberOfLines = 0
        nameLbl.font = Font.system.bold(withSize: 17)
        
        phoneLbl.numberOfLines = 0
        phoneLbl.font = Font.system.normal(withSize: 15)
    }
    
    override func initialize() {
        super.initialize()
    }
    
    open override class func height(withItem _item: BaseCellViewModel) -> CGFloat {
        return 70.0
    }
    
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel as? ContactCellViewModel else {
            return
        }
        
        viewModel.rxName ~> nameLbl.rx.text => disposeBag
        viewModel.rxPhone ~> phoneLbl.rx.text => disposeBag
    }
}
