//
//  SectionImageCell.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/15/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM

class SectionImageCell: BaseTableCell {

    @IBOutlet private weak var netImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        netImageView.contentMode = .scaleAspectFill
        netImageView.clipsToBounds = true
        contentView.addSubview(netImageView)
        netImageView.autoMatch(.height, to: .width, of: netImageView, withMultiplier: 9/16.0)
        netImageView.autoPinEdgesToSuperviewEdges(with: .symmetric(horizontal: 15, vertical: 10))
    }
    
    override func initialize() {
        super.initialize()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel as? SectionImageCellViewModel else { return }
        
        viewModel.rxImage ~> netImageView.rx.networkImage => disposeBag
    }
}
