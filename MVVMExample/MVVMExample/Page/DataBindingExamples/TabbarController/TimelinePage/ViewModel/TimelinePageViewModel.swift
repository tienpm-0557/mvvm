//
//  TimelinePageViewModel.swift
//  MVVMExample
//
//  Created by tienpm on 9/16/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxCocoa
import RxSwift
import Action

class TimelinePageViewModel: BaseListViewModel {
    let alertService: IAlertService = DependencyManager.shared.getService()
    var networkService: NetworkService?
    var tmpBag: DisposeBag?
    let rxTille = BehaviorRelay<String?>(value: "")
    lazy var getDataAction: Action<Void, Void> = {
        return Action { .just(self.getData()) }
    }()
    lazy var loadMoreAction: Action<Void, Void> = {
        return Action { .just(self.loadMore()) }
    }()

    override func react() {
        super.react()
        guard let model = self.model as? TabbarModel else {
            return
        }
        rxTille.accept(model.title)
        networkService = DependencyManager.shared.getService()
    }

    private func getData() {
        self.networkService?.loadTimeline(withPage: self.page, withLimit: self.limit)
            .map(prepareSources)
            .subscribe(onSuccess: {[weak self] results in
                if let data = results {
                    self?.itemsSource.append(data, animated: false)
                }
            }, onFailure: { _ in
            }) => tmpBag
    }

    private func loadMore() {
        print("DEBUG: Loading more")
    }

    private func prepareSources(_ response: TimelineResponseModel?) -> [BaseCellViewModel]? {
        guard let response = response else {
            return []
        }
        if response.stat == .badRequest {
            alertService.presentOkayAlert(title: "Error",
                                          message: "\(response.message)\nPlease be sure to provide your own SECRET key from MTLAB.")
        }
        return response.timelines
    }
}
