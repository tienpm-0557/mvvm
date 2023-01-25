//
//  MoyaProviderServicePage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 6/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM

class MoyaProviderServicePage: BasePage {
    @IBOutlet private var cURLLb: UILabel!
    @IBOutlet private var responseTxt: UITextView!

    let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 400, height: 30))
    let indicatorView = UIActivityIndicatorView(style: .medium)

    override func initialize() {
        super.initialize()
        enableBackButton = true
        DependencyManager.shared.registerService(Factory<MoyaService> {
            MoyaService()
        })

        cURLLb.translatesAutoresizingMaskIntoConstraints = false
        // setup search bar
        searchBar.placeholder = "Search for Flickr images"
        navigationItem.titleView = searchBar

        indicatorView.hidesWhenStopped = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let viewModel = self.viewModel as? MoyaProviderServicePageViewModel else {
            return
        }
        viewModel.rxSearchText.accept("Animal")
        if let textField = searchBar.subviews[0].subviews.last as? UITextField {
            textField.rightView = indicatorView
            textField.rightViewMode = .always
        }
    }

    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = self.viewModel as? MoyaProviderServicePageViewModel else {
            return
        }
        viewModel.rxPageTitle ~> self.rx.title => disposeBag
        viewModel.rxSearchText <~> searchBar.rx.text => disposeBag
        viewModel.rxCurlText ~> self.cURLLb.rx.text => disposeBag
        viewModel.rxResponseText ~> self.responseTxt.rx.text => disposeBag
        viewModel.rxIsSearching.subscribe(onNext: {[weak self] searching in
            if searching {
                self?.indicatorView.startAnimating()
            } else {
                self?.indicatorView.stopAnimating()
            }
        }) => disposeBag
    }
}
