//
//  CollectionPageViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import Action
import RxSwift
import RxCocoa

class CollectionPageViewModel: BaseListViewModel {

    let rxPageTitle = BehaviorRelay(value: "")
    
    lazy var addAction: Action<Void, Void> = {
        return Action() { .just(self.add()) }
    }()
    
    override func react() {
        super.react()
        
        let title = (self.model as? MenuModel)?.title ?? "Simple UICollectionView"
        rxPageTitle.accept(title)
        
        let headerVM =  HeaderFooterModel(withTitle: "Section title #\(itemsSource.count + 1)",
            desc: "List page examples",
            footer: "Footer #\(itemsSource.count + 1)")
        
        let vm = SectionHeaderViewViewModel(model: headerVM)
        itemsSource.appendSectionViewModel(vm, animated: false)
    }
    
    /// Add collection Cell
    func add() {
        /// Dummy cell model
        let number = Int.random(in: 1000...10000)
        let title = "This is your random number: \(number)"
        let model = SectionTextModel(withTitle: title, desc:  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.")
        let cvm = SimpleCollectionViewDellModel(model: model)
        itemsSource.append(cvm)
    }

    override func selectedItemDidChange(_ cellViewModel: BaseCellViewModel) {
        guard let cellViewModel = cellViewModel as? SimpleCollectionViewDellModel else {
            return
        }
        
        print("DEBUG: Collection View did select item \(cellViewModel.indexPath?.row ?? 0) \(cellViewModel.rxTitle.value ?? "")")
        
    }
}
