//
//  DynamicCollectionPageViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxSwift
import RxCocoa
import Action

class DynamicCollectionPageViewModel: BaseListViewModel {
    let rxPageTitle = BehaviorRelay<String?>(value: "")
    
    override func react() {
        super.react()
        fetchData()
        let title = (self.model as? MenuModel)?.title ?? "Dynamic UICollectionView"
        rxPageTitle.accept(title)
        rxState.subscribe(onNext: { state in
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
            if self.rxState.value == .normal {
                self.rxState.accept(.loadingMore)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    print("DEBUG: start load more content")
                    self.add()
                    self.rxState.accept(.normal)
                }
            }
        }
    }
    
    /// Dummy data: Append data when did loadmore 10 item per page
    private func add() {
        var reuslt = [DynamicCollectionCellModel]()
        for _ in 1...10 {
            let number = Int.random(in: 1000...10000)
            let title = "This is your random number: \(number)"
            let model = SectionTextModel(withTitle: title,
                                         desc: """
                                                Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
                                                Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
                                                Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
                """)
            let cvm = DynamicCollectionCellModel(model: model)
            reuslt.append(cvm)
        }
        itemsSource.append(reuslt, animated: false)
    }
    
    override func selectedItemDidChange(_ cellViewModel: BaseCellViewModel, _ indexPath: IndexPath) {
        /// navigationService
        /// Use navigation service for push view controller into Navigation.
        /// In case View is Root. Navigation service will present viewcontroller.
        print("DEBUG: selectedItemDidChange \(cellViewModel.indexPath?.row ?? -1)")
    }
}
