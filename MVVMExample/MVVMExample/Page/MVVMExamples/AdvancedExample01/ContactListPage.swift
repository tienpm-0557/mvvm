//
//  ContactListPage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/22/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM

class ContactListPage: BaseListPage {
    
    let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableBackButton = true
        navigationItem.rightBarButtonItem = addBtn
        // Do any additional setup after loading the view.
        
    }

    override func setupTableView(_ tableView: UITableView) {
        super.setupTableView(tableView)
        tableView.separatorStyle = .singleLine
        tableView.estimatedRowHeight = 70
        tableView.register(cellType: ContactTableViewCell.self)
        
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = self.viewModel as? ContactListPageViewModel else { return }
        
        addBtn.rx.bind(to: viewModel.addAction, input: ())
    }

    override func cellIdentifier(_ cellViewModel: Any, _ returnClassName: Bool = false) -> String {
        return returnClassName ? ContactTableViewCell.className : ContactTableViewCell.identifier
    }
    
    override func getItemSource() -> RxCollection? {
        guard let viewModel = viewModel as? ContactListPageViewModel else { return nil }
        return viewModel.itemsSource
    }
        
    override func destroy() {
        super.destroy()
        viewModel?.destroy()
    }

}
