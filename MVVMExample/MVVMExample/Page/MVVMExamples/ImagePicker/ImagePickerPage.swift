//
//  ImagePickerPage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 8/5/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxCocoa
import RxSwift

class ImagePickerPage: BasePage {
    @IBOutlet private weak var titleTxt: UITextField!
    @IBOutlet private weak var descLb: UITextView!
    @IBOutlet private weak var photoImg: UIImageView!
    @IBOutlet private weak var photoBtn: UIButton!
    @IBOutlet private weak var localBtn: UIButton!
    @IBOutlet private weak var cameraBtn: UIButton!
    @IBOutlet private weak var actackViewHeight: NSLayoutConstraint!

    let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        enableBackButton = true
        addBtn.title = "Post"
        self.navigationItem.rightBarButtonItem = addBtn
    }

    override func initialize() {
        super.initialize()
        guard let model = self.viewModel?.model as? MenuModel else {
            return
        }
        self.rx.title.onNext(model.title)
    }

    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = self.viewModel as? ImagePickerViewModel else {
            return
        }
        addBtn.rx.bind(to: viewModel.postAction, input: ())
        viewModel.rxTitle <~> titleTxt.rx.text => disposeBag
        viewModel.rxDescription <~> descLb.rx.text => disposeBag
        descLb.rx.didBeginEditing.subscribe(onNext: {
            self.descLb.rx.text.onNext("")
        }) => disposeBag

        descLb.rx.didEndEditing.subscribe(onNext: {
            if self.descLb.text.isEmpty {
                self.descLb.rx.text.onNext("What's on your mind?")
            }
        }) => disposeBag

        viewModel.rxImage.subscribe(onNext: {[weak self] image in
            if image == nil {
                self?.actackViewHeight.constant = 0
            } else {
                self?.actackViewHeight.constant = 80
            }
            self?.photoImg.image = image
        }) => disposeBag

        photoBtn.rx.tap
            .flatMapLatest { [weak self]_ in
                return UIImagePickerController.rx.createWithParent(self, animated: true) { picker in
                    picker.sourceType = .camera
                    picker.allowsEditing = false
                }
                .flatMap { $0.rx.didFinishPickingMediaWithInfo }
            }
            .map { info in
                return info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
            }
            .bind(to: viewModel.rxImage) => disposeBag
        viewModel.rxCanPost.subscribe { enable in
            print("rxCanPost: Enable \(enable)")
        } => disposeBag
    }
}
