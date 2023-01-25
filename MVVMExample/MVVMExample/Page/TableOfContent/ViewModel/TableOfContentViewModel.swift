//
//  TableOfContentViewModel.swift
//  MVVMExample
//
//  Created by tienpm on 2/2/21.
//  Copyright © 2021 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxCocoa
import RxSwift

protocol TableOfContentViewModelInputs {
    var rxPageTitle: BehaviorRelay<String?> { get }
}

protocol TableOfContentViewModelOutputs {
    var itemsSource: ReactiveCollection<BaseCellViewModel> { get }
}

protocol TableOfContentViewModelType {
    var inputs: TableOfContentViewModelInputs { get }
    var outputs: TableOfContentViewModelOutputs { get }
}

/// Menu for home page
class TableOfContentViewModel: BaseListViewModel, TableOfContentViewModelType, TableOfContentViewModelInputs, TableOfContentViewModelOutputs {

    var inputs: TableOfContentViewModelInputs {
        return self
    }

    var outputs: TableOfContentViewModelOutputs {
        return self
    }
    let rxPageTitle = BehaviorRelay<String?>(value: "")

    override func react() {
        super.react()
        fetchData()
        let title = (self.model as? MenuModel)?.title ?? LocalizedStringConfigs.strTableOfContents.localized
        rxPageTitle.accept(title)
    }

    override func onUpdateLocalize() {
        super.onUpdateLocalize()
        let title = (self.model as? MenuModel)?.title ?? LocalizedStringConfigs.strTableOfContents.localized
        rxPageTitle.accept(title)
    }

    func fetchData() {
        let intro = MenuTableCellViewModel(model: IntroductionModel(withTitle: "Introduction",
                                                                    desc: "MVVM is a library for who wants to start writing iOS application using MVVM (Model-View-ViewModel), written in Swift.",
                                                                    url: "https://github.com/tienpm-0557/mvvm/blob/master/README.md"))
        let mvvm = MenuTableCellViewModel(model: MenuModel(withTitle: "MVVM Examples",
                                                           desc: "Examples about different ways to use base classes Page, ListPage and CollectionPage."))
        let dataBinding = MenuTableCellViewModel(model: MenuModel(withTitle: "Data Binding Examples",
                                                                  desc: "Examples about how to use data binding."))
        let service = MenuTableCellViewModel(model: MenuModel(withTitle: "Service Examples", desc: "Examples about how to create a service and register it; how to inject to our ViewModel."))
        let transition = MenuTableCellViewModel(model: MenuModel(withTitle: "Transition Examples",
                                                                 desc: "Examples about how to create a custom transitioning animation and apply it."))
        let storeKit = MenuTableCellViewModel(model: MenuModel(withTitle: "StoreKit Examples (coming soon)",
        desc: "Examples about how to use StoreKit in your application. (rate app, in-app  purchases...etc)"))

        let localization = MenuTableCellViewModel(model: MenuModel(withTitle: "Localization Examples",
        desc: "Examples about how to setting localize in your application."))

        itemsSource.reset([[intro, mvvm, service, transition, dataBinding, storeKit, localization]])
    }

    func pageToNavigate(_ cellViewModel: BaseCellViewModel) -> UIViewController? {
        guard let indexPath = rxSelectedIndex.value else {
            return nil
        }

        var page: UIViewController?
        switch indexPath.row {
        case 0:
            page = IntroductionPage(viewModel: IntroductionPageViewModel(model: cellViewModel.model))

        case 1:
            page = MVVMExamplePage(viewModel: MvvmExamplesPageViewModel(model: cellViewModel.model))

        case 2:
            page = ServiceExamplesPage(viewModel: ServiceExamplesPageViewModel(model: cellViewModel.model))

        case 3:
            page = TransitionExamplesPage(viewModel: TransitionExamplesPageViewModel(model: cellViewModel.model, usingShowModal: true))

        case 4:
            page = DataBindingExamplesPage(viewModel: DatabindingExamplesPageViewModel(model: cellViewModel.model))

        case 5:
            page = StoreKitPage(viewModel: StoreKitPageViewModel(model: cellViewModel.model))

        case 6:
            page = LocalizationPage(viewModel: LocalizationPageViewModel(model: cellViewModel.model))

        default: ()
        }
        return page
    }

    override func selectedItemDidChange(_ cellViewModel: BaseCellViewModel, _ indexPath: IndexPath) {
        if let page = pageToNavigate(cellViewModel) {
            navigationService.push(to: page, options: .defaultOptions)
        }
    }
}
