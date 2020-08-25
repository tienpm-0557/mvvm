//
//  DynamicListPageViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/16/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxCocoa
import RxSwift

class DynamicListPageViewModel: BaseListViewModel {
    
    let rxPageTitle = BehaviorRelay(value: "")
    
    override func react() {
        super.react()
        fetchData()
        let title = (self.model as? MenuModel)?.title ?? "Dynamic UITableView"
        rxPageTitle.accept(title)
        rxState.subscribe(onNext: { (state) in
            self.rxPageTitle.accept(title + " \(state)")
        }) => disposeBag
    }
    
    func fetchData() {
        self.rxState.accept(.loadingData)
        add()
        self.rxState.accept(.normal)
    }
    
    override func loadMoreContent() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.rxState.accept(.loadingMore)        
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.add()
                self.rxState.accept(.normal)
            }
        }
    }
    
    private func add() {
        var reuslt = [SimpleListPageCellViewModel]()
        for _ in 1...10 {
            let number = Int.random(in: 1000...10000)
            let title = "This is your random number: \(number)"
            let cvm = SimpleListPageCellViewModel(model: SimpleModel(withTitle: title))
            reuslt.append(cvm)
        }
        itemsSource.append(reuslt, animated: false)
    }
    
    override func selectedItemDidChange(_ cellViewModel: BaseCellViewModel) {
        /// navigationService
        /// Use navigation service for push view controller into Navigation.
        /// In case View is Root. Navigation service will present viewcontroller.
        print("DEBUG: selectedItemDidChange \(cellViewModel.indexPath?.row ?? -1)")
    }
    
}
