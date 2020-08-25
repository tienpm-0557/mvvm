//
//  DynamicCollectionViewCell.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxSwift
import RxCocoa

class DynamicCollectionViewCell: BaseCollectionCell {

    @IBOutlet private weak var titleLbl: UILabel!
    @IBOutlet private weak var descLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override class func getSize(withItem data: Any?) -> CGSize? {
        let screenSize = UIScreen.main.bounds
        return CGSize(width: screenSize.width - 20, height: 100)
    }
    
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel as? DynamicCollectionCellModel else { return }

        viewModel.rxTitle ~> titleLbl.rx.text => disposeBag
        viewModel.rxDesc ~> descLbl.rx.text => disposeBag
    }
    

}
