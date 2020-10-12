//
//  ContactEditPage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/22/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM


class ContactEditPage: BasePage {

    let scrollView = ScrollLayout()
    let containerView = UIView()
    
    let nameTxt = UITextField()
    let phoneTxt = UITextField()
    let submitBtn = UIButton(type: .custom)
    let cancelBtn = UIButton(type: .custom)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    override func initialize() {
        title = "Add/Edit Contact"
        
        enableBackButton = true
        
        view.addSubview(scrollView)
        scrollView.frame = CGRect(x: 0, y: 50, width: 200, height: 200)
        
        scrollView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        nameTxt.borderStyle = .roundedRect
        nameTxt.placeholder = "Enter your name"
        
        phoneTxt.borderStyle = .roundedRect
        phoneTxt.placeholder = "Enter your phone number"
        
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.setTitleColor(.white, for: .normal)
        cancelBtn.setBackgroundImage(UIImage.from(color: .red), for: .normal)
        cancelBtn.contentEdgeInsets = .symmetric(horizontal: 10, vertical: 5)
        cancelBtn.cornerRadius = 5
        
        submitBtn.setTitle("Save", for: .normal)
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.setTitleColor(.lightGray, for: .disabled)
        submitBtn.setBackgroundImage(UIImage.from(color: .blue), for: .normal)
        submitBtn.setBackgroundImage(UIImage.from(color: .gray), for: .disabled)
        submitBtn.contentEdgeInsets = .symmetric(horizontal: 10, vertical: 5)
        submitBtn.cornerRadius = 5
        
        let buttonLayout = StackLayout().justifyContent(.fillEqually).spacing(10).children([
            cancelBtn,
            submitBtn
        ])
        
        scrollView.paddings(.all(20)).appendChildren([
            StackSpaceItem(height: 40),
            nameTxt,
            StackSpaceItem(height: 20),
            phoneTxt,
            StackSpaceItem(height: 40),
            buttonLayout
        ])
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = self.viewModel as? ContactEditPageViewModel else { return }
        
        viewModel.rxName <~> nameTxt.rx.text => disposeBag
        viewModel.rxPhone <~> phoneTxt.rx.text => disposeBag
        
        cancelBtn.rx.bind(to: viewModel.cancelAction, input: ())
        submitBtn.rx.bind(to: viewModel.saveAction, input: ())
    }
    
    override func onBack() {
        navigationService.pop(with: PopOptions(popType: .dismissPopup))
    }

}
