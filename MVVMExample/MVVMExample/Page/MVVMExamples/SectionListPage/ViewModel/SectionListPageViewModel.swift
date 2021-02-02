//
//  SectionListPageViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/15/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxSwift
import RxCocoa
import Action

class SectionListPageViewModel: BaseListViewModel {
    
    let rxPageTitle = BehaviorRelay(value: "")
    
    let imageUrls = [
        "https://images.pexels.com/photos/371633/pexels-photo-371633.jpeg?auto=compress&cs=tinysrgb&h=350",
        "https://images.pexels.com/photos/210186/pexels-photo-210186.jpeg?auto=compress&cs=tinysrgb&h=350",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI3cP_SZVm5g43t4U8slThjjp6v1dGoUyfPd6ncEvVQQG1LzDl",
        "https://images.pexels.com/photos/414171/pexels-photo-414171.jpeg?auto=compress&cs=tinysrgb&h=350"
    ]
    
    lazy var addAction: Action<Void, Void> = {
        return Action() { .just(self.addSection()) }
    }()
    
    lazy var sortAction: Action<Void, Void> = {
        return Action() { .just(self.sort()) }
    }()
    
    var tmpBag: DisposeBag?
    
    override func react() {
        rxPageTitle.accept("Section List Page")
        itemsSource.asObservable()
            .subscribe(onNext: { sectionLists in
                self.tmpBag = DisposeBag()
                
                for sectionList in sectionLists {
                    if let cvm = sectionList.element as? SectionHeaderViewViewModel {
                        cvm.addAction
                            .executionObservables
                            .switchLatest()
                            .subscribe(onNext: self.addCell) => self.tmpBag
                    }
                }
            }) => disposeBag
    }
    
    private func addCell(_ vm: SectionHeaderViewViewModel) {
        if let sectionIndex = itemsSource.indexForSection(withKey: vm) {
            let randomIndex = Int.random(in: 0...1)
            
            // randomly show text cell or image cell
            if randomIndex == 0 {
                // ramdom image from imageUrls
                let index = Int.random(in: 0..<imageUrls.count)
                let url = imageUrls[index]
                let model = SectionImageModel(withUrl: url)
                
                itemsSource.append(SectionImageCellViewModel(model: model), to: sectionIndex)
            } else {
                itemsSource.append(SectionTextCellViewModel(model: SectionTextModel(withTitle: "Just a text cell title",
                                                                                    desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.")), to: sectionIndex)
            }
        }
    }
    
    // add section
    private func addSection() {
        let headerVM = HeaderFooterModel(withTitle: "Section title #\(itemsSource.count + 1)",
            desc: "List page examples",
            footer: "Footer #\(itemsSource.count + 1)")
        
        let vm = SectionHeaderViewViewModel(model: headerVM)
        itemsSource.appendSectionViewModel(vm)
    }
    
    private func sort() {
        guard itemsSource.count > 0 else { return }
        
        let section = Int.random(in: 0..<itemsSource.count)
        itemsSource.sort(by: { (cvm1, cvm2) -> Bool in
            if let m1 = cvm1.model as? NumberModel, let m2 = cvm2.model as? NumberModel {
                return m1.number < m2.number
            }
            return false
        }, at: section)
    }
}

