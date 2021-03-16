//
//  NonGenericExampleMenusPage.swift
//  MVVM_Example
//
//  Created by pham.minh.tien on 5/3/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import MVVM
import RxCocoa
import RxSwift
import Action

class TableOfContentsPage: BaseListPage {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        enableBackButton = !(navigationController?.viewControllers.count == 1)
    }

    override func setupTableView(_ tableView: UITableView) {
        super.setupTableView(tableView)
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = .singleLine
        tableView.register(cellType: MenuTableViewCell.self)
    }
    
    // Register event: Connect view to ViewModel.
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = viewModel as? TableOfContentViewModelType else {
            return
        }
        viewModel.inputs.rxPageTitle ~> rx.title => disposeBag
    }
    
    override func destroy() {
        super.destroy()
        viewModel?.destroy()
    }
    
    override func cellIdentifier(_ cellViewModel: Any, _ returnClassName: Bool = false) -> String {
        return MenuTableViewCell.identifier(returnClassName)
    }
    
    override func getItemSource() -> RxCollection? {
        guard let viewModel = viewModel as? TableOfContentViewModelType else {
            return nil
        }
        return viewModel.outputs.itemsSource
    }
    
    // Not recommended for use. override selectedItemDidChange on ViewModel.
    override func selectedItemDidChange(_ cellViewModel: Any, _ indexPath: IndexPath) {}
}
