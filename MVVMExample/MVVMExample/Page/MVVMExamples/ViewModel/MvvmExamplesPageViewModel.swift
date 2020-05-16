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
        let listPage = MenuTableCellViewModel(model: MenuModel(withTitle: "Simple UITableView Page", desc: "Demostration on how to use ListPage"))
        let listCollectionPage = MenuTableCellViewModel(model: MenuModel(withTitle: "UITableView Sections Page", desc: "Demostration on how to use Section List Page"))
        let listCollectionHeaderFooterPage = MenuTableCellViewModel(model: MenuModel(withTitle: "UITableView with Header & Footer Page", desc: "Demostration on how to use Section List Page"))
        let dynamicListPage = MenuTableCellViewModel(model: MenuModel(withTitle: "Dynamic List Page", desc: "UITableView support load more data."))
        
        let collectionPage = MenuTableCellViewModel(model: MenuModel(withTitle: "UICollection Page", desc: "Demostration on how to use CollectionPage"))
        let advanced = MenuTableCellViewModel(model: MenuModel(withTitle: "Advanced Example 1", desc: "When using MVVM, we should forget about Delegate as it is against to MVVM rule.\nThis example is to demostrate how to get result from other page without using Delegate"))
        let searchBar = MenuTableCellViewModel(model: MenuModel(withTitle: "Advanced Example 2", desc: "An advanced example on using Search Bar to search images on Flickr."))
        itemsSource.reset([[listPage, listCollectionPage, listCollectionHeaderFooterPage, dynamicListPage, collectionPage, advanced, searchBar]])
    }
    
    override func pageToNavigate(_ cellViewModel: BaseCellViewModel) -> UIViewController? {
        guard let indexPath = rxSelectedIndex.value else { return nil }
        
        var page: UIViewController?
        switch indexPath.row {
        case 0:
            /// Simple UITableview
            let vm = ListPageExampleViewModel(model: cellViewModel.model)
            let vc = ListPageExamplePage(model: vm)
            page = vc
        case 1:
            /// UITableview with Header
            let vm = SectionListPageViewModel(model: cellViewModel.model)
            let vc = SectionListPage(model: vm)
            page = vc
        case 2:
            /// UITableview with header & footer
            let vm = SectionListPageViewModel(model: cellViewModel.model)
            let vc = HeaderFooterListPage(model: vm)
            page = vc
        case 3:
            /// UITableview support load more data
            let vm = DynamicListPageViewModel(model: cellViewModel.model)
            let vc = DynamicListPage(model: vm)
            page = vc
            break
            
        default: ()
        }
        
        return page
    }
}
