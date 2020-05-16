//
//  DynamicListPage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/16/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxCocoa
import RxSwift
import Action

class DynamicListPage: BaseListPage {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        enableBackButton = true
    }

    override func setupTableView(_ tableView: UITableView) {
        super.setupTableView(tableView)
        /// separatorStyle disabled in BaseListPage
        tableView.separatorStyle = .singleLine
        tableView.estimatedRowHeight = 200
        tableView.register(cellType: SimpleTableCell.self)
        allowLoadmoreData = true
        
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = self.viewModel as? DynamicListPageViewModel else {
            return
        }
        viewModel.rxPageTitle ~> rx.title => disposeBag
        viewModel.rxState ~> self.rx.state => disposeBag
    }
    
    override func cellIdentifier(_ cellViewModel: Any, _ returnClassName: Bool = false) -> String {
        return returnClassName ? SimpleTableCell.className : SimpleTableCell.identifier
    }

    override func getItemSource() -> RxCollection? {
        guard let viewModel = viewModel as? DynamicListPageViewModel else { return nil }
        return viewModel.itemsSource
    }
    
    override func destroy() {
        super.destroy()
        viewModel?.destroy()
    }
    
}
