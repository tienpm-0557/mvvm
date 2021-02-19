//
//  ServiceExamplesViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/14/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import WebKit
import MVVM
import Action
import RxSwift
import RxCocoa

// MARK: ViewModel For Service Examples
class ServiceExamplesPageViewModel: TableOfContentViewModel {
    var alertService: IAlertService = DependencyManager.shared.getService()
    
    private var mailService: MailService?
    private var shareService: ShareService?
    
    override func react() {
        super.react()
        mailService = DependencyManager.shared.getService()
        alertService = DependencyManager.shared.getService()
        shareService = DependencyManager.shared.getService()
    }
    
    override func fetchData() {
        let alert = MenuTableCellViewModel(model: MenuModel(withTitle: "Alert Service",
                                                            desc: "How to create alert service and register it"))
        
        let networkService = MenuTableCellViewModel(model: MenuModel(withTitle: "Alamofire Network Services.",
                                                                     desc: "Examples about how to use Alamofire Network Services."))
        
        let moyaNetworkService = MenuTableCellViewModel(model: MenuModel(withTitle: "Moya Network Services",
                                                                         desc: "Examples about how to use Moya Network Services."))
        
        let reachabilityService = MenuTableCellViewModel(model: MenuModel(withTitle: "Reachability service",
                                                                          desc: "Examples about how to use Reachability Network Services."))
        
        let mailService = MenuTableCellViewModel(model: MenuModel(withTitle: "Mail service",
                                                                  desc: "Examples about how to create and use Mail service."))
        
        let shareService = MenuTableCellViewModel(model: MenuModel(withTitle: "Share service",
                                                                   desc: "Examples about how to use share service Services."))
        
        itemsSource.reset([[alert, networkService, moyaNetworkService, reachabilityService, mailService, shareService]])
    }
    
    override func pageToNavigate(_ cellViewModel: BaseCellViewModel) -> UIViewController? {
        guard let indexPath = rxSelectedIndex.value else {
            return nil
        }
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
            
        case 4:
            /// Provide your emails, subjects, and message for mail detail.
            mailService?.sendMailTo(listEmail: ["phamminhtien305@gmail.com", "dinh.tung@sun-asterisk.com"],
                                    withSubject: "[Enter your subject]",
                                    withMessage: "[Enter your message]")
            
            mailService?.rxMailComposeState.subscribe(onNext: { [weak self] result in
                var message: String? = nil
                switch result {
                case .cancelled:
                    message = "Mail cancelled: you cancelled the operation and no email message was queued."
                case .saved:
                    message = "Mail saved: you saved the email message in the drafts folder."
                case .sent:
                    message = "Mail send: the email message is queued in the outbox. It is ready to send."
                case .failed:
                    message = "Mail failed: the email message was not saved or queued, possibly due to an error."
                default:
                    message = nil
                }
                if let message = message {
                    self?.alertService.presentOkayAlert(title: "MVVM Examples", message: message)
                }
            }) => disposeBag
            
            mailService?.rxMailSettingValidate.subscribe(onNext: {[weak self] validateMessage in
                self?.alertService.presentOkayAlert(title: "MVVM Examples", message: validateMessage)
            }) => disposeBag
            
        case 5:
            shareService?.openShare(title: "[Your share Title]",
                                    url: "https://github.com/tienpm-0557/mvvm/blob/master/README.md")
            shareService?.rxShareServiceState.subscribe(onNext: {[weak self] result in
                guard let result = result else {
                    return
                }
                if result.completed {
                    self?.alertService.presentOkayAlert(title: "",
                                                        message: "Share success!")
                } else {
                    if let err = result.error {
                        self?.alertService.presentOkayAlert(title: "",
                                                            message: err.localizedDescription)
                    }
                }
            }) => disposeBag
            
        default: ()
        }
        
        return page
    }
}
