//
//  TimelinePage.swift
//  MVVMExample
//
//  Created by tienpm on 9/16/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxSwift
import RxCocoa

class TimelinePage: BaseListPage {
    
    let indicatorView = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
     
    override func initialize() {
        super.initialize()
           
        /// Before use. You must register your service
        DependencyManager.shared.registerService(Factory<NetworkService> {
            NetworkService()
        })
        
        indicatorView.hidesWhenStopped = true
    }
       
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = self.viewModel as? TimelinePageViewModel else {
            return
        }
        
        viewModel.rxTille ~> self.rx.title => disposeBag
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func setupTableView(_ tableView: UITableView) {
        super.setupTableView(tableView)
        tableView.register(cellType: SectionImageCell.self)
        tableView.register(cellType: SectionTextCell.self)
        tableView.register(headerType: SectionHeaderListView.self)
    }
    
    override func getItemSource() -> RxCollection? {
        guard let viewModel = viewModel as? TimelinePageViewModel else { return nil }
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
