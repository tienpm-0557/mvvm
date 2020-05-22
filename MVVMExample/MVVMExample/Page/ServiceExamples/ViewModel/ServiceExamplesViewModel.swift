//
//  ServiceExamplesViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/14/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import MVVM
import RxCocoa
import WebKit

//MARK: ViewModel For Service Examples
class ServiceExamplesPageViewModel: TableOfContentViewModel {
    override func fetchData() {
        let alert = MenuTableCellViewModel(model: MenuModel(withTitle: "Alert Service",
                                                desc: "How to create alert service and register it"))
        let networkService = MenuTableCellViewModel(model: MenuModel(withTitle: "Network Services",
                                                                     desc: "Examples about how to use Network Services."))
        let reachability = MenuTableCellViewModel(model: MenuModel(withTitle: "Reachability service",
                                                                     desc: "Examples about how to use Network Services."))
        
        
        
        itemsSource.reset([[alert, networkService, reachability]])
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
