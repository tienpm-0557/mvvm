//
//  HeaderCollectionView.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxSwift
import RxCocoa

class HeaderCollectionView: BaseHeaderCollectionView {
    @IBOutlet private weak var titleLbl: UILabel!
    
    override class func headerSize(withItem _item: BaseViewModel) -> CGSize {
        let screenSize = UIScreen.main.bounds
        return CGSize(width: screenSize.width, height: 50)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func initialize() {
        
    }
    
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel as? SectionHeaderViewViewModel else { return }
        viewModel.rxTitle ~> titleLbl.rx.text => disposeBag
    }
}
