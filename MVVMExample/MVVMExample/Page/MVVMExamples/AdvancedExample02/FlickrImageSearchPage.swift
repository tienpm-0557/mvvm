//
//  FlickrImageSearchPage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/23/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxSwift

class FlickrImageSearchPage: BaseCollectionPage {

    let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 400, height: 30))
    let indicatorView = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    override func initialize() {
        super.initialize()
        DependencyManager.shared.registerService(Factory<FlickrService> {
            FlickrService()
        })
        
        enableBackButton = true
        // setup search bar
        searchBar.placeholder = "Search for Flickr images"
        navigationItem.titleView = searchBar
        
        indicatorView.hidesWhenStopped = true
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let textField = searchBar.subviews[0].subviews.last as? UITextField {
            textField.rightView = indicatorView
            textField.rightViewMode = .always
        }
    }
    
    override func registerNibWithColletion(_ collectionView: UICollectionView) {
        collectionView.register(collectionViewCell: FlickrImageCell.self)
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = viewModel as? FlickrImageSearchPageViewModel else { return }
        viewModel.rxSearchText <~> searchBar.rx.text => disposeBag
        
        // toggle show/hide indicator next to search bar
        viewModel.rxState.subscribe(onNext: { (state) in
            if state == .loadingData {
                self.indicatorView.startAnimating()
            } else if state == .loadingMore {
                self.indicatorView.startAnimating()
            } else {
                self.indicatorView.stopAnimating()
            }
        }) => disposeBag
        
        // call out load more when reach to end of collection view
        collectionView.rx.endReach(30).subscribe(onNext: {
            viewModel.loadMoreAction.execute(())
        }) => disposeBag
    }
    
    override func getItemSource() -> RxCollection? {
        guard let viewModel = viewModel as? FlickrImageSearchPageViewModel else { return nil }
        return viewModel.itemsSource
    }
    
    override func cellIdentifier(_ cellViewModel: Any, _ isClass: Bool = false) -> String {
        return isClass ? FlickrImageCell.className : FlickrImageCell.identifier
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
