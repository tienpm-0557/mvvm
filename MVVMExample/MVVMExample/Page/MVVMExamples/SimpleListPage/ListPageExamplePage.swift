//
//  ListPageExamplePage.swift
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

class ListPageExamplePage: BaseListPage {
    let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        enableBackButton = true
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = addBtn
    }

    override func setupTableView(_ tableView: UITableView) {
        super.setupTableView(tableView)
        /// separatorStyle disabled in BaseListPage
        tableView.separatorStyle = .singleLine
        tableView.estimatedRowHeight = 200
        tableView.register(cellType: SimpleTableCell.self)
    }

    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        
        guard let viewModel = viewModel as? ListPageExampleViewModel else { return }
        viewModel.rxPageTitle ~> rx.title => disposeBag
        addBtn.rx.bind(to: viewModel.addAction, input: ())
    }

    override func cellIdentifier(_ cellViewModel: Any, _ returnClassName: Bool = false) -> String {
        return returnClassName ? SimpleTableCell.className : SimpleTableCell.identifier
    }
    
    override func getItemSource() -> RxCollection? {
        guard let viewModel = viewModel as? ListPageExampleViewModel else { return nil }
        return viewModel.itemsSource
    }
    
    override func destroy() {
        super.destroy()
        viewModel?.destroy()
    }
}
