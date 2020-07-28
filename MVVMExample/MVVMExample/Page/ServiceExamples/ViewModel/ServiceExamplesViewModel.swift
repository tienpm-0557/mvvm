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
        let networkService = MenuTableCellViewModel(model: MenuModel(withTitle: "Alamofire Network Services.",
                                                                     desc: "Examples about how to use Alamofire Network Services."))
        let moyaNetworkService = MenuTableCellViewModel(model: MenuModel(withTitle: "Moya Network Services (coming soon)",
                                                                     desc: "Examples about how to use Moya Network Services."))
        let reachabilityService = MenuTableCellViewModel(model: MenuModel(withTitle: "Reachability service",
                                                                     desc: "Examples about how to use Reachability Network Services."))
        let mailService = MenuTableCellViewModel(model: MenuModel(withTitle: "Mail service (coming soon)", desc: "Examples about how to use Mail service Services."))
        
        let shareService = MenuTableCellViewModel(model: MenuModel(withTitle: "Share service (coming soon)", desc: "Examples about how to use share service Services."))
        
        itemsSource.reset([[alert, networkService, moyaNetworkService, reachabilityService, mailService, shareService]])
    }
    
    override func pageToNavigate(_ cellViewModel: BaseCellViewModel) -> UIViewController? {
        guard let indexPath = rxSelectedIndex.value else { return nil }
        var page: UIViewController?
        switch indexPath.row {
        case 0: // Alert service.
            let vm = AlertServiceViewModel(model: cellViewModel.model)
            let vc = AlertServicePage(viewModel: vm)
            page = vc
        case 1: // Alamofire network service.
            let vm = NetworkServicePageViewModel(model: cellViewModel.model)
            let vc = NetworkServicePage(viewModel: vm)
            page = vc
        case 2: // Moya network service.
            let vm = MoyaProviderServicePageViewModel(model: cellViewModel.model)
            let vc = MoyaProviderServicePage(viewModel: vm)
            page = vc
        case 3: // Reachability service.
            let vm = ReachabilityPageViewModel(model: cellViewModel.model)
            let vc = ReachabilityPage(viewModel: vm)
            page = vc
        default: ()
        }
        
        return page
    }
}
