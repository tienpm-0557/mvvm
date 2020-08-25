//
//  ListPageExampleViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/14/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxCocoa
import RxSwift
import Action

class ListPageExampleViewModel: BaseListViewModel {

    let rxPageTitle = BehaviorRelay(value: "")
    
    lazy var addAction: Action<Void, Void> = {
        return Action() { .just(self.add()) }
    }()

    override func react() {
        super.react()
        let title = (self.model as? MenuModel)?.title ?? "Simple UITableView"
        rxPageTitle.accept(title)
    }
    
    private func add() {
        let number = Int.random(in: 1000...10000)
        let title = "This is your random number: \(number)"
        let cvm = SimpleListPageCellViewModel(model: SimpleModel(withTitle: title))
        itemsSource.append(cvm)
    }
        
    override func selectedItemDidChange(_ cellViewModel: BaseCellViewModel) {
        /// navigationService
        /// Use navigation service for push view controller into Navigation.
        /// In case View is Root. Navigation service will present viewcontroller.
        print("DEBUG: selectedItemDidChange \(cellViewModel.indexPath?.row ?? -1)")
    }
    
}

