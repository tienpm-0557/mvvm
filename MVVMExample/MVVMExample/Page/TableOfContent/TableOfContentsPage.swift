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
    }

    override func setupTableView(_ tableView: UITableView) {
        super.setupTableView(tableView)
        tableView.estimatedRowHeight = 100
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
    
    override func cellIdentifier(_ cellViewModel: Any) -> String {
        return MenuTableViewCell.identifier
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
            page = TableOfContentsPage(model: MvvmExamplesPageViewModel(model: cellViewModel.model))
        case 2:
            page = TableOfContentsPage(model: DatabindingExamplesPageViewModel(model: cellViewModel.model))
        case 3:
            page = TableOfContentsPage(model: ServiceExamplesPageViewModel(model: cellViewModel.model))
        case 4:
            page = TableOfContentsPage(model: TransitionExamplesPageViewModel(model: cellViewModel.model))
        case 5:
            page = TableOfContentsPage(model: WebViewExamplesPageViewModel(model: cellViewModel.model))
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

//MARK: ViewModel For MVVM Examples
class MvvmExamplesPageViewModel: TableOfContentViewModel {
    
    override func fetchData() {
        let listPage = MenuTableCellViewModel(model: MenuModel(withTitle: "ListPage Examples", desc: "Demostration on how to use ListPage"))
        let collectionPage = MenuTableCellViewModel(model: MenuModel(withTitle: "CollectionPage Examples", desc: "Demostration on how to use CollectionPage"))
        let advanced = MenuTableCellViewModel(model: MenuModel(withTitle: "Advanced Example 1", desc: "When using MVVM, we should forget about Delegate as it is against to MVVM rule.\nThis example is to demostrate how to get result from other page without using Delegate"))
        let searchBar = MenuTableCellViewModel(model: MenuModel(withTitle: "Advanced Example 2", desc: "An advanced example on using Search Bar to search images on Flickr."))
        itemsSource.reset([[listPage, collectionPage, advanced, searchBar]])
    }
    
    override func pageToNavigate(_ cellViewModel: BaseCellViewModel) -> UIViewController? {
        guard let indexPath = rxSelectedIndex.value else { return nil }
        
        var page: UIViewController?
        switch indexPath.row {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        case 3:
            break
            
        default: ()
        }
        
        return page
    }
}

//MARK: ViewModel For Collection Examples
class DatabindingExamplesPageViewModel: TableOfContentViewModel {
    override func fetchData() {
        let segmentBar = MenuTableCellViewModel(model: MenuModel(withTitle: "One-way, Two-way and Action Binding",
                                                desc: "How to setup data binding between ViewModel and View"))
        
        let customControl = MenuTableCellViewModel(model: MenuModel(withTitle: "Custom Control with Data Binding",
                                                                 desc: "How to create a control with two-way binding property."))
        
        
        itemsSource.reset([[segmentBar, customControl]])
    }
    
    override func pageToNavigate(_ cellViewModel: BaseCellViewModel) -> UIViewController? {
        guard let indexPath = rxSelectedIndex.value else { return nil }
        var page: UIViewController?
        switch indexPath.row {
        case 0:
            break
        case 1:
            break
        default: ()
        }
        
        return page
    }
}


//MARK: ViewModel For Service Examples
class ServiceExamplesPageViewModel: TableOfContentViewModel {
    override func fetchData() {
        let alert = MenuTableCellViewModel(model: MenuModel(withTitle: "Alert Service",
                                                desc: "How to create alert service and register it"))
        
        itemsSource.reset([[alert]])
    }
    
    override func pageToNavigate(_ cellViewModel: BaseCellViewModel) -> UIViewController? {
        guard let indexPath = rxSelectedIndex.value else { return nil }
        var page: UIViewController?
        switch indexPath.row {
        case 0:
            break
        case 1:
            break
        default: ()
        }
        
        return page
    }
}

//MARK: ViewModel For Transition Examples
class TransitionExamplesPageViewModel: TableOfContentViewModel {
    override func fetchData() {
        let alert = MenuTableCellViewModel(model: MenuModel(withTitle: "Alert Service",
                                                desc: "How to create alert service and register it"))
        
        itemsSource.reset([[alert]])
    }
    
    override func pageToNavigate(_ cellViewModel: BaseCellViewModel) -> UIViewController? {
        guard let indexPath = rxSelectedIndex.value else { return nil }
        var page: UIViewController?
        switch indexPath.row {
        case 0:
            break
        case 1:
            break
        default: ()
        }
        
        return page
    }
}


//MARK: WebView Examples
class WebViewExamplesPageViewModel: TableOfContentViewModel {
    override func fetchData() {
        
        let alertPanel = MenuTableCellViewModel(model: MenuModel(withTitle: "Alert Panel With Message",
                                                                 desc: "Run java scription alert panel with message"))
        
        let confirmAlertPanel = MenuTableCellViewModel(model: MenuModel(withTitle: "Confirm Alert",
                                                                        desc: "Run java scription comfirm alert panel with message"))
        
        let authentication = MenuTableCellViewModel(model: MenuModel(withTitle: "Authentication",
                                                                        desc: "Handle Authentication use URLCredential"))
        
        
        let handleLinkError = MenuTableCellViewModel(model: MenuModel(withTitle: "Fail Provisional Navigation",
                                                                      desc: "Handle delegate method `didFailProvisionalNavigation`."))
        let evaluateJavaScript =  MenuTableCellViewModel(model: MenuModel(withTitle: "Evaluate JavaScript",
                                                                             desc: "Reactive wrapper for `evaluateJavaScript(_:completionHandler:)` method."))
        
        itemsSource.reset([[alertPanel, confirmAlertPanel, authentication, handleLinkError, evaluateJavaScript]])
    }
    
    override func pageToNavigate(_ cellViewModel: BaseCellViewModel) -> UIViewController? {
        guard let indexPath = rxSelectedIndex.value else { return nil }
        var page: UIViewController?
        switch indexPath.row {
        case 0:
            page = AlertWebPage(model: AlertWebPageViewModel(model: cellViewModel.model))
            break
        case 1:
            page = ConfirmAlertWebPage(model: ConfirmAlertWebViewModel(model: cellViewModel.model))
            break
        case 2:
            page = AuthenticationWebPage(model: AuthenticationWebViewModel(model: cellViewModel.model))
            break
        case 3:
            page = FailNavigationWebPage(model: FailNavigationWebViewModel(model: cellViewModel.model))
            break
        case 4:
            page = EvaluateJavaScriptWebPage(model: EvaluateJavaScriptWebViewModel(model: cellViewModel.model))
            break
        default: ()
        }
        
        return page
    }
}
