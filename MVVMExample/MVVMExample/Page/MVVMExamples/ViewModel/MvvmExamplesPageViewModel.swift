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
import Action

//MARK: ViewModel For MVVM Examples
class MvvmExamplesPageViewModel: TableOfContentViewModel {
    
    override func fetchData() {
        let listPage = MenuTableCellViewModel(model: MenuModel(withTitle: "Simple UITableView Page",
                                                               desc: "Demostration on how to use ListPage"))
        
        let listCollectionPage = MenuTableCellViewModel(model: MenuModel(withTitle: "UITableView Sections Page",
                                                                         desc: "Demostration on how to use Section List Page"))
        
        let listCollectionHeaderFooterPage = MenuTableCellViewModel(model: MenuModel(withTitle: "UITableView with Header & Footer Page",
                                                                                     desc: "Demostration on how to use Section List Page"))
        let dynamicListPage = MenuTableCellViewModel(model: MenuModel(withTitle: "Dynamic List Page",
                                                                      desc: "UITableView support load more data."))
        
        let collectionPage = MenuTableCellViewModel(model: MenuModel(withTitle: "UICollection Page",
                                                                     desc: "Demostration on how to use CollectionPage"))
        
        let dynamicCollectionPage = MenuTableCellViewModel(model: MenuModel(withTitle: "Dynamic UICollection Page",
                                                                            desc: "Demostration on how to use CollectionPage support load more data."))
        
        let advanced = MenuTableCellViewModel(model: MenuModel(withTitle: "Contact Page",
                                                               desc: "When using MVVM, we should forget about Delegate as it is against to MVVM rule.\nThis example is to demostrate how to get result from other page without using Delegate"))
        
        let searchBar = MenuTableCellViewModel(model: MenuModel(withTitle: "Flickr Search Page",
                                                                desc: "An advanced example on using Search Bar to search images on Flickr."))
        
        let webKit = MenuTableCellViewModel(model: MenuModel(withTitle: "WebKit",
                                                             desc: "Examples about how to create a  Webkit and apply it."))
        
        let mediaPicker = MenuTableCellViewModel(model: MenuModel(withTitle: "Media Picker",
                                                                  desc: "Examples about how to create a UIImagePickerController, MPMediaPickerController and apply it."))
        
        let qrcode = MenuTableCellViewModel(model: MenuModel(withTitle: "Scan QR Code(coming soon)",
                                                                  desc: "Examples about how to create scan QR code screen and apply it."))
        
        itemsSource.reset([[listPage, listCollectionPage, listCollectionHeaderFooterPage, dynamicListPage, collectionPage, dynamicCollectionPage, advanced, searchBar, webKit, mediaPicker, qrcode]])
    }
    
    override func pageToNavigate(_ cellViewModel: BaseCellViewModel) -> UIViewController? {
        guard let indexPath = rxSelectedIndex.value else { return nil }
        
        var page: UIViewController?
        switch indexPath.row {
        case 0:
            /// Simple UITableview
            let vm = ListPageExampleViewModel(model: cellViewModel.model)
            let vc = ListPageExamplePage(viewModel: vm)
            page = vc
        case 1:
            /// UITableview with Header
            let vm = SectionListPageViewModel(model: cellViewModel.model)
            let vc = SectionListPage(viewModel: vm)
            page = vc
        case 2:
            /// UITableview with header & footer
            let vm = SectionListPageViewModel(model: cellViewModel.model)
            let vc = HeaderFooterListPage(viewModel: vm)
            page = vc
        case 3:
            /// UITableview support load more data
            let vm = DynamicListPageViewModel(model: cellViewModel.model)
            let vc = DynamicListPage(viewModel: vm)
            page = vc
        case 4:
            /// Simple UICollectionView
            let vm = CollectionPageViewModel(model: cellViewModel.model)
            let vc = SimpleCollectionPage(viewModel: vm)
            page = vc
        case 5:
            /// UICollection View support loadmore data.
            let vm = DynamicCollectionPageViewModel(model: cellViewModel.model)
            let vc = DynamicCollectionPage(viewModel: vm)
            page = vc
        case 6:
            /// Advanced Example 1
            let vm = ContactListPageViewModel(model: cellViewModel.model)
            let vc = ContactListPage(viewModel: vm)
            page = vc
        case 7:
            /// Advanced Example 2
            let vm = FlickrImageSearchPageViewModel(model: cellViewModel.model)
            let vc = FlickrImageSearchPage(viewModel: vm)
            page = vc
        case 8:
            /// UIWebkit Examples
            let vm = WebViewExamplesPageViewModel(model: cellViewModel.model)
            let vc = WebKitExamplesPage(viewModel: vm)
            page = vc
        case 9:
            /// Image Picker
            let vm = ImagePickerViewModel(model: cellViewModel.model)
            let vc = ImagePickerPage(viewModel: vm)
            page = vc
        default: ()
        }
        
        return page
    }
}
