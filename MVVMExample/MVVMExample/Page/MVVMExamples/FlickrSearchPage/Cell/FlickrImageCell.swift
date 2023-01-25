//
//  FlickrImageCell.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/23/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxCocoa
import RxSwift

class FlickrImageCell: BaseCollectionCell {
    @IBOutlet private weak var contentImage: UIImageView!
    @IBOutlet private weak var titleLb: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override class func getSize(withItem data: Any?) -> CGSize? {
        let screenSize = UIScreen.main.bounds
        return CGSize(width: (screenSize.width - 30) / 2, height: (screenSize.width - 30) * 3 / 5)
    }

    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = self.viewModel as? FlickrCellViewModel else {
            return
        }
        viewModel.rxImage ~> contentImage.rx.networkImage => disposeBag
        viewModel.rxTitle ~> titleLb.rx.text => disposeBag
    }
}
