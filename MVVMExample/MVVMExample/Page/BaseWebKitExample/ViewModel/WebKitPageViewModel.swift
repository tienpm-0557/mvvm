//
//  WebKitPageViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/14/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import Foundation
import MVVM
import RxCocoa
import WebKit

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
