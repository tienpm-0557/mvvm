//
//  DynamicCollectionPage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxSwift
import RxCocoa
import Action

class DynamicCollectionPage: BaseCollectionPage {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func initialize() {
        super.initialize()
        allowLoadmoreData = true
    }

    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = self.viewModel as? DynamicCollectionPageViewModel else {
            return
        }
        viewModel.rxPageTitle ~> rx.title => disposeBag
        viewModel.rxState ~> self.rx.state => disposeBag
    }
    
    override func registerNibWithColletion(_ collectionView: UICollectionView) {
        collectionView.register(collectionViewCell: DynamicCollectionViewCell.self)
    }
    
    override func cellIdentifier(_ cellViewModel: Any, _ isClass: Bool = false) -> String {
        return isClass ? DynamicCollectionViewCell.className : DynamicCollectionViewCell.identifier
    }
    
    override func getItemSource() -> RxCollection? {
        guard let viewModel = viewModel as? DynamicCollectionPageViewModel else { return nil }
        return viewModel.itemsSource
    }
    
    override func destroy() {
        super.destroy()
        viewModel?.destroy()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
