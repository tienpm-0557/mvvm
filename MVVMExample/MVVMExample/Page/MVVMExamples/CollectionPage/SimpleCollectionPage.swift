//
//  SimpleCollectionPage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxCocoa
import RxSwift

class SimpleCollectionPage: BaseCollectionPage {
    
    let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = addBtn
    }

    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = viewModel as? CollectionPageViewModel else { return }
        viewModel.rxPageTitle ~> self.rx.title => disposeBag
        addBtn.rx.bind(to: viewModel.addAction, input: ())
    }
    
    override func getItemSource() -> RxCollection? {
        guard let viewModel = viewModel as? CollectionPageViewModel else { return nil }
        return viewModel.itemsSource
    }
    
    override func registerNibWithColletion(_ collectionView: UICollectionView) {
        collectionView.register(collectionViewCell: SimpleCollectionViewCell.self)
        collectionView.register(headerType: HeaderCollectionView.self)
    }
    
    override func cellIdentifier(_ cellViewModel: Any, _ isClass: Bool = false) -> String {
        return isClass ? SimpleCollectionViewCell.className : SimpleCollectionViewCell.identifier
    }

    override func headerIdentifier(_ headerViewModel: Any, _ returnClassName: Bool = false) -> String? {
        return returnClassName ? HeaderCollectionView.className : HeaderCollectionView.identifier
    }
    
    
}
