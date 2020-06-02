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
            let vm = ValidatePageViewModel(model: cellViewModel.model)
            let vc = ValidatePage(viewModel: vm)
            page = vc
        case 1:
            let vm = CustomControlViewPageModel(model: cellViewModel.model)
            let vc = CustomControlPage(viewModel: vm)
            page = vc
        default: ()
        }
        
        return page
    }
}
