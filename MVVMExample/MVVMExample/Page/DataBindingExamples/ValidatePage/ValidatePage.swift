//
//  ValidatePage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 6/1/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM

class ValidatePage: BasePage {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var helloLbl: UILabel!
    @IBOutlet private weak var emailTxt: UITextField!
    @IBOutlet private weak var passTxt: UITextField!
    @IBOutlet private weak var submitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initialize() {
        super.initialize()
        
        enableBackButton = true
        
        /*
        scrollView.autoPinEdge(toSuperviewSafeArea: .top)
        scrollView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        */
        helloLbl.font = Font.system.bold(withSize: 18)
        
        emailTxt.borderStyle = .roundedRect
        emailTxt.placeholder = "Enter your name"
        
        passTxt.borderStyle = .roundedRect
        passTxt.placeholder = "Enter your pass"
        passTxt.isSecureTextEntry = true
        
        submitBtn.setTitle("Submit", for: .normal)
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.setTitleColor(.lightGray, for: .disabled)
        submitBtn.setBackgroundImage(UIImage.from(color: .blue), for: .normal)
        submitBtn.setBackgroundImage(UIImage.from(color: .gray), for: .disabled)
        submitBtn.contentEdgeInsets = .symmetric(horizontal: 10, vertical: 5)
        submitBtn.cornerRadius = 5
    }
    
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel as? ValidatePageViewModel else {
            return
        }
        
        viewModel.rxPageTitle ~> rx.title => disposeBag // One-way binding is donated by ~>
        viewModel.rxHelloText ~> helloLbl.rx.text => disposeBag // One-way binding is donated by ~>
        viewModel.rxEmail <~> emailTxt.rx.text => disposeBag // Two-way binding is donated by <~>
        viewModel.rxPass <~> passTxt.rx.text => disposeBag // Two-way binding is donated by <~>
        submitBtn.rx.bind(to: viewModel.submitAction, input: ()) // action binding
    }
}
