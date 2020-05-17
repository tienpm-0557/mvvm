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
        tableView.register(cellType:MenuTableViewCell.self)
    }
    
    // Register event: Connect view to ViewModel.
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = viewModel as? TableOfContentViewModel else { return }
        viewModel.rxPageTitle ~> rx.title => disposeBag
    }
    
    override func destroy() {
        super.destroy()
        viewModel?.destroy()
    }
    
    override func cellIdentifier(_ cellViewModel: Any, _ returnClassName: Bool = false) -> String {
        return MenuTableViewCell.identifier(returnClassName)
    }
    
    override func getItemSource() -> RxCollection? {
        guard let viewModel = viewModel as? TableOfContentViewModel else { return nil }
        return viewModel.itemsSource
    }
    
    // Not recommended for use. override selectedItemDidChange on ViewModel.
    override func selectedItemDidChange(_ cellViewModel: Any) { }

}

/// Menu for home page
class TableOfContentViewModel: BaseListViewModel {
    
    let rxPageTitle = BehaviorRelay(value: "")

    override func react() {
        super.react()
        fetchData()
        let title = (self.model as? MenuModel)?.title ?? "Table Of Contents"
        rxPageTitle.accept(title)
    }
    
    func fetchData() {
        let intro = MenuTableCellViewModel(model: IntroductionModel(withTitle: "Introduction", desc: "MVVM is a library for who wants to start writing iOS application using MVVM (Model-View-ViewModel), written in Swift.", url: "https://github.com/tienpm-0557/mvvm/blob/AddBaseNonGeneric/README.md"))
        let mvvm = MenuTableCellViewModel(model: MenuModel(withTitle: "MVVM Examples",
                                                           desc: "Examples about different ways to use base classes Page, ListPage and CollectionPage."))
        let dataBinding = MenuTableCellViewModel(model: MenuModel(withTitle: "Data Binding Examples",
                                                                  desc: "Examples about how to use data binding."))
        
        let service = MenuTableCellViewModel(model: MenuModel(withTitle: "Service Examples", desc: "Examples about how to create a service and register it; how to inject to our ViewModel."))
        let transition = MenuTableCellViewModel(model: MenuModel(withTitle: "Transition Examples",
                                                                 desc: "Examples about how to create a custom transitioning animation and apply it."))
        let webKit = MenuTableCellViewModel(model: MenuModel(withTitle: "WebKit", desc: "Examples about how to create a  Webkit and apply it."))
        itemsSource.reset([[intro, mvvm, dataBinding, service, transition, webKit]])
    }
    
    func pageToNavigate(_ cellViewModel: BaseCellViewModel) -> UIViewController? {
        guard let indexPath = rxSelectedIndex.value else { return nil }
        
        var page: UIViewController?
        switch indexPath.row {
        case 0:
            page = IntroductionPage(model: IntroductionPageViewModel(model: cellViewModel.model))
        case 1:
            page = MVVMExamplePage(model: MvvmExamplesPageViewModel(model: cellViewModel.model))
        case 2:
            page = DataBindingExamplesPage(model: DatabindingExamplesPageViewModel(model: cellViewModel.model))
        case 3:
            page = ServiceExamplesPage(model: ServiceExamplesPageViewModel(model: cellViewModel.model))
        case 4:
            page = TransitionExamplesPage(model: TransitionExamplesPageViewModel(model: cellViewModel.model))
        case 5:
            page = WebKitExamplesPage(model: WebViewExamplesPageViewModel(model: cellViewModel.model))
        default: ()
        }
        return page
    }
    
    override func selectedItemDidChange(_ cellViewModel: BaseCellViewModel) {
        if let page = pageToNavigate(cellViewModel) {
            navigationService.push(to: page, options: .defaultOptions)
        }
    }
}
