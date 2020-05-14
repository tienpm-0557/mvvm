//
//  MvvmExamplesPageViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/14/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import MVVM
import RxCocoa
import WebKit

//MARK: ViewModel For MVVM Examples
class MvvmExamplesPageViewModel: TableOfContentViewModel {
    
    override func fetchData() {
        let listPage = MenuTableCellViewModel(model: MenuModel(withTitle: "ListPage Examples", desc: "Demostration on how to use ListPage"))
        let collectionPage = MenuTableCellViewModel(model: MenuModel(withTitle: "CollectionPage Examples", desc: "Demostration on how to use CollectionPage"))
        let advanced = MenuTableCellViewModel(model: MenuModel(withTitle: "Advanced Example 1", desc: "When using MVVM, we should forget about Delegate as it is against to MVVM rule.\nThis example is to demostrate how to get result from other page without using Delegate"))
        let searchBar = MenuTableCellViewModel(model: MenuModel(withTitle: "Advanced Example 2", desc: "An advanced example on using Search Bar to search images on Flickr."))
        itemsSource.reset([[listPage, collectionPage, advanced, searchBar]])
    }
    
    override func pageToNavigate(_ cellViewModel: BaseCellViewModel) -> UIViewController? {
        guard let indexPath = rxSelectedIndex.value else { return nil }
        
        var page: UIViewController?
        switch indexPath.row {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        case 3:
            break
            
        default: ()
        }
        
        return page
    }
}
