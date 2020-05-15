//
//  SectionListPage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/15/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxSwift
import RxCocoa
import Action


class SectionListPage: BaseListPage {
    @IBOutlet private weak var addBtn: UIButton!
    @IBOutlet private weak var sortBtn:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        autoEstimateRowHeight = false
    }

    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = self.viewModel as? SectionListPageViewModel else {
            return
        }
        
        viewModel.rxPageTitle ~> self.rx.title => disposeBag
        addBtn.rx.bind(to: viewModel.addAction, input:())
        sortBtn.rx.bind(to: viewModel.sortAction, input: ())
        
    }
    
    override func setupTableView(_ tableView: UITableView) {
        super.setupTableView(tableView)
        tableView.register(cellType: SectionImageCell.self)
        tableView.register(cellType: SectionTextCell.self)
        tableView.register(headerType: SectionHeaderListView.self)
    }
    
    override func getItemSource() -> RxCollection? {
        guard let viewModel = viewModel as? SectionListPageViewModel else { return nil }
        return viewModel.itemsSource
    }
    
    override func cellIdentifier(_ cellViewModel: Any, _ returnClassName: Bool = false) -> String {
        switch cellViewModel {
        case is SectionImageCellViewModel:
            return SectionImageCell.identifier(returnClassName)
        default:
            return SectionTextCell.identifier(returnClassName)
        }
    }
    
    override func headerIdentifier(_ headerViewModel: Any, _ returnClassName: Bool = false) -> String {
        return returnClassName ? SectionHeaderListView.className : SectionHeaderListView.identifier
    }
    
    override func destroy() {
        super.destroy()
        viewModel?.destroy()
    }
}
