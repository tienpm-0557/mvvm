//
//  NetworkServicePage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/26/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM

class NetworkServicePage: BasePage {
    
    @IBOutlet private var cURLTxt: UITextView!
    @IBOutlet private var responseTxt: UITextView!
    
    let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 400, height: 30))
    let indicatorView = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableBackButton = true
        // Do any additional setup after loading the view.
        
        if let textField = searchBar.subviews[0].subviews.last as? UITextField {
            textField.rightView = indicatorView
            textField.rightViewMode = .always
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let viewModel = self.viewModel as? NetworkServicePageViewModel else {
            return
        }
        viewModel.rxSearchText.accept("animal")
    }
    
    override func initialize() {
        super.initialize()
        enableBackButton = true
        
        cURLTxt.translatesAutoresizingMaskIntoConstraints = false
        cURLTxt.isScrollEnabled = false
        
        DependencyManager.shared.registerService(Factory<NetworkService> {
            NetworkService()
        })
        
        // setup search bar
        searchBar.placeholder = "Search for Flickr images"
        navigationItem.titleView = searchBar

        indicatorView.hidesWhenStopped = true
        
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = self.viewModel as? NetworkServicePageViewModel else {
            return
        }
        
        viewModel.rxPageTitle ~> self.rx.title => disposeBag
        viewModel.rxSearchText <~> searchBar.rx.text => disposeBag
        viewModel.rxCurlText ~> self.cURLTxt.rx.text => disposeBag
        viewModel.rxResponseText ~> self.responseTxt.rx.text => disposeBag
    }
    

}
