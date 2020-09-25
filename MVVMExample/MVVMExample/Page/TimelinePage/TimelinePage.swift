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
    
    @IBOutlet private weak var bottomPadding: NSLayoutConstraint!
    
    let indicatorView = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.accessibilityIdentifier = "TimelineNavigationAccessibilityId"
        // Do any additional setup after loading the view.
        guard let viewModel = self.viewModel as? TimelinePageViewModel else { return }
        viewModel.getDataAction.execute()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomPadding.constant = SystemConfiguration.TabbarHeight
    }
     
    override func initialize() {
        super.initialize()
        /// Before using. You must register your service
        DependencyManager.shared.registerService(Factory<NetworkService> {
            NetworkService()
        })
        
        DependencyManager.shared.registerService(Factory<ShareService> {
            ShareService()
        })
        
        indicatorView.hidesWhenStopped = true
    }
       
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = self.viewModel as? TimelinePageViewModel else { return }
        viewModel.rxTille ~> self.rx.title => disposeBag
        
        // Call out load more when reach to end of table view
        tableView.rx.endReach(30).subscribe(onNext: {
            viewModel.loadMoreAction.execute(())
        }) => disposeBag
    }

    override func setupTableView(_ tableView: UITableView) {
        super.setupTableView(tableView)
        tableView.register(cellType: ActivityCell.self)
        tableView.register(cellType: TimeLineCell.self)
    }
    
    override func getItemSource() -> RxCollection? {
        guard let viewModel = viewModel as? TimelinePageViewModel else { return nil }
        return viewModel.itemsSource
    }
    
    override func cellIdentifier(_ cellViewModel: Any, _ returnClassName: Bool = false) -> String {
        switch cellViewModel {
        case is ActivityCellViewModel:
            return ActivityCell.identifier(returnClassName)
        case is TimelineCellViewModel:
            return TimeLineCell.identifier(returnClassName)
        default:
            return TimeLineCell.identifier(returnClassName)
        }
    }
    
    override func selectedItemDidChange(_ cellViewModel: Any) {
        let page = PostDetailPage()
        let animator = RectanglerAnimator(withDuration: TimeInterval(0.5), isPresenting: false) 
        navigationService.push(to: page, options: .push(with: animator))
    }
    
    override func destroy() {
        super.destroy()
        viewModel?.destroy()
    }
    
}
