//
//  SimpleCollectionViewCell.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM


class SimpleCollectionViewCell: BaseCollectionCell {

    let titleLbl = UILabel()
    
    override func initialize() {
        cornerRadius = 5
        backgroundColor = .black
        
        titleLbl.textColor = .white
        titleLbl.numberOfLines = 0
        titleLbl.font = Font.system.bold(withSize: 17)
        
        let layout = StackLayout().direction(.vertical).children([
            titleLbl
        ])
        contentView.addSubview(layout)
        layout.autoPinEdgesToSuperviewEdges(with: .all(5))

    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = viewModel as? SimpleCollectionViewDellModel  else { return }
        viewModel.rxTitle ~> titleLbl.rx.text => disposeBag
    }
    
    override class func getSize(withItem data: Any?) -> CGSize? {
        let screenSize = UIScreen.main.bounds
        return CGSize(width: (screenSize.width - 30) / 2, height: 60)
    }
}
