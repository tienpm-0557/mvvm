//
//  DataBindingExamplesViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/14/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import MVVM
import RxCocoa
import WebKit

// MARK: ViewModel For Collection Examples
class DatabindingExamplesPageViewModel: TableOfContentViewModel {
    override func fetchData() {
        let segmentBar = MenuTableCellViewModel(model: MenuModel(withTitle: "One-way, Two-way and Action Binding",
                                                desc: "How to setup data binding between ViewModel and View"))
        let customControl = MenuTableCellViewModel(model: MenuModel(withTitle: "Custom Control with Data Binding",
                                                                 desc: "How to create a control with two-way binding property."))
        let page = MenuTableCellViewModel(model: MenuModel(withTitle: "UIPage Example",
                                                           desc: "Examples about how to create a  UIPageViewController"))
        let tabbar = MenuTableCellViewModel(model: MenuModel(withTitle: "TabbarController",
                                                             desc: "Examples about how to create a TabbarController"))
        itemsSource.reset([[segmentBar, customControl, page, tabbar]])
    }

    override func pageToNavigate(_ cellViewModel: BaseCellViewModel) -> UIViewController? {
        guard let indexPath = rxSelectedIndex.value else {
            return nil
        }
        var page: UIViewController?
        switch indexPath.row {
        case 0:
            let vm = ValidatePageViewModel(model: cellViewModel.model)
            let vc = ValidatePage(viewModel: vm)
            page = vc

        case 1:
            let vm = CustomControlViewPageModel(model: cellViewModel.model)
            let vc = CustomControlPage(viewModel: vm)
            page = vc

        case 2:
            let vm = UIPageExampleViewModel(model: cellViewModel.model)
            let vc = UIPageExample(viewModel: vm, withOption: nil)
            page = vc

        case 3:
            let vm = TabbarControllerViewModel(model: cellViewModel.model)
            let vc = TabbarViewController(viewModel: vm)
            page = vc

        default: ()
        }

        return page
    }
}
