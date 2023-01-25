# MVVM 

MVVM is a library for who wants to start writing iOS application using MVVM (Model-View-ViewModel), written in Swift.

- [Features](#features)
- [Requirements](#requirements)
- [Dependencies](#dependencies)
- [Installation](#installation)
- [Usage](#usage)
- [Example](#example)



## Features

- [x] Base classes for UIViewController,  UIView, UITableView, UICollectionView, UITableViewCell and UICollectionCell.
- [x] Base classes for ViewModel, ListViewModel and CellViewModel
- [x] Base classes for UIWekit. Support handle navigation, evaluateJavaScript, handle java script function...
- [x] Services injection: Network service base on Alamofire, Moya library. Localize service, Alert Service, Reachability service, Mail and Share service...
- [x] Custom transitioning for UINavigationController and UIViewController
- [x] Integration Fastlane app distribution.

## Requirements
- iOS 10.0+
- Xcode 10.0+
- Swift 5.0+

## Dependencies
The library heavily depends on [RxSwift](https://github.com/ReactiveX/RxSwift) for data-binding and events. For who does not familiar with Reactive Programming, I suggest to start reading about it first. Beside that, here are the list of dependencies:
- [RxSwift](https://github.com/ReactiveX/RxSwift)
- [Action](https://github.com/RxSwiftCommunity/Action)
- [Alamofire](https://github.com/Alamofire/Alamofire)
- [SDWebImage](https://github.com/SDWebImage/SDWebImage)
- [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper)
- [PureLayout](https://github.com/PureLayout/PureLayout)
- [Moya](https://github.com/Moya/Moya)

## Installation
[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate MVVM into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
pod 'MVVM', :path => '[Provide your path to MVVM.podspec file]'
    pod 'SwiftyJSON'
end
```

Then, run the following command:

```bash
$ pod install
```

## Usage

### At the glance
- The library is mainly written using Generic, so please familiar yourself with Swift Generic, and very important point, we can’t use Generic UIViewController to associate with UIViewController on InterfaceBuilder or Storyboard. So programmatically is prefer, but we can still use XIBs to instantiate our view (check example for more details). (Note: In this project  **Base classes** supports both generic and non-generic types)

- The idea is that each **Page** will contain a **ViewModel** property with type to be determined by generic **VM** or **BaseViewModel**

### Libray Components
##### Page (BasePage), ListPage (BaseListpage), CollectionPage (BaseCollectionPage), BaseWebView.
I prefer **Page** or **BasePage** over **ViewController** in term of MVVM. For create new a UIViewController please instance of **Page<[VM]>** class or **BasePage** class.

**UIViewController**
```swift
open class Page<VM: IViewModel>: UIViewController, IView, ITransionView 
```

In case you do not want to use the Generic type create instance of BasePage class.
```swift
///Non-generic type
open class BasePage: UIViewController, ITransitionView
```
**UITableView**
```swift
open class ListPage<VM: IListViewModel>: Page<VM>
```

In case you do not want to use the Generic type create instance of BaseListPage class.
```swift
///Non-generic type
open class BaseListPage: BasePage, UITableViewDataSource, UITableViewDelegate
```
**UICollectionView**
```swift
open class CollectionPage<VM: IListViewModel>: Page<VM>
```
In case you do not want to use the Generic type create instance of BaseCollectionPage class.
```swift
///Non-generic type
open class BaseCollectionPage: BasePage
```

**UIWebkit**
```swift
///Non-generic type
open class BaseWebView: BasePage
```

##### View, TableCell and CollectionCell
Same as **Page**, View is also a generic UIView, while **TableCell** and **CollectionCell** are generic cell that can be used in **ListPage** and **CollectionPage**
In case you don't want to use generic type you can also use non generic type by create an instance of **BaseABC** class 
Ex: **BaseView**, **BaseCollectionCell**, **BaseTableCell**.
```swift
open class View<VM: IGenericViewModel>: UIView, IView
```

```swift
///Non-generic type
open class BaseView: UIView, IView
```

```swift
open class CollectionCell<VM: IGenericViewModel>: UICollectionViewCell, IView
```

```swift
///Non-generic type
open class BaseCollectionCell: UICollectionViewCell, IView
```

```swift
open class TableCell<VM: IGenericViewModel>: UITableViewCell, IView
```

```swift
///Non-generic type
open class BaseTableCell: UITableViewCell, IView
```

* With Generic Type: You must provide **VM**. They all have generic type **VM** to determine its own ViewModel
* By inheriting **View** or **Page**, and implementing 2 main methods:

```swift
open func initialize() {}

open func bindViewAndViewModel() {}
```

Then we have a full set of a view that can bind with ViewModel

##### ViewModel, ListViewModel and CellViewModel
Base classes for our ViewModel binding with: Page, BasePage
```swift
open class ViewModel<M: Model>: NSObject, IViewModel
```
Non-Generic type
```swift
open class BaseViewModel: NSObject, IViewModel, IReactable
```
Base classes for our ListViewModel binding with: ListPage, BaseListPage, CollectionPage, BaseCollectionPage
```swift
open class ListViewModel<M: Model, CVM: IGenericViewModel>: ViewModel<M>, IListViewModel
```
Non-Generic type
```swift
open class BaseListViewModel: BaseViewModel, IListViewModel {
```
Base classes for our CellViewModel binding with: TableCell, BaseTableCell, CollectionCell, BaseCollectionCell
```swift
open class CellViewModel<M: Model>: NSObject, IGenericViewModel
```
Non-Generic type
```swift
open class BaseCellViewModel: NSObject, IGenericViewModel, IIndexable, IReactable {
```

Base classes for our ViewModel only use for instance of BaseWebView.
```swift
open class BaseWebViewModel: BaseViewModel
```

**Note: With Generic Type**

- As we can see, **ViewModel** and **CellViewModel** use one generic type **M** (which is based type is Model). This generic type is for us to determine the model type for each ViewModel. The difference between **ViewModel** and **CellViewModel** is **ViewModel** contains navigation service that can help use to navigate between our pages in apllication, while **CellViewModel** does not.

- **ListViewModel** is a bit different. It uses one more generic type **CVM**, which represented for ViewModel type of a cell in side a page. In the other hand, it contains an items source array that can be bind with a list page or collection page

Please check examples for details usages of these base classes.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
```bash
$ open MVVMExample.xcworkspace
``` 
For example a viewmodel.
```

import UIKit
import MVVM
import RxCocoa
import RxSwift
import Action

class TimelinePageViewModel: BaseListViewModel {
    
    private let alertService: IAlertService = DependencyManager.shared.getService()
    private var networkService: NetworkService?
    private var tmpBag: DisposeBag?
    
    let rxTille = BehaviorRelay<String>(value: "")
    
    lazy var getDataAction: Action<Void, Void> = {
        return Action { .just(self.getData()) }
    }()
    
    lazy var loadMoreAction: Action<Void, Void> = {
        return Action { .just(self.loadMore()) }
    }()
    
    let rxState = PublishRelay<NetworkServiceState>()
    
    override func react() {
        super.react()
        
        guard let model = self.model as? TabbarModel else { return }
        rxTille.accept(model.title)
        
        networkService = DependencyManager.shared.getService()
    }
    
    private func getData() {
        self.networkService?.loadTimeline(withPage: self.page, withLimit: self.limit)
            .map(prepareSources).subscribe(onSuccess: {[weak self] (results) in
                if let data = results {
                    self?.itemsSource.append(data, animated: false)
                }
                self?.rxState.accept(.success)
        }, onError: { (error) in
            self.rxState.accept(.error)
        }) => tmpBag
    }
    
    private func loadMore() {
        print("Loading more content...")
    }
    
    private func prepareSources(_ response: TimelineResponseModel?) -> [BaseCellViewModel]? {
        guard let response = response else { return [] }
        if response.stat == .badRequest {
            alertService.presentOkayAlert(title: "Error",
                                          message: "\(response.message)\nPlease be sure to provide your own SECRET key from [ABC].")
        }
        return response.timelines as? [BaseCellViewModel]
    }
    
    override func selectedItemDidChange(_ cellViewModel: BaseCellViewModel,_ indexPath: IndexPath) {
        /// Do something
    }
    
}
```
And View
```

import UIKit
import MVVM
import RxSwift
import RxCocoa

class TimelinePage: BaseListPage {
    
    let indicatorView = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let viewModel = self.viewModel as? TimelinePageViewModel else { return }
        viewModel.getDataAction.execute()
        
    }
    
    override func initialize() {
        super.initialize()
        
        /// Before using. You must register necessary service
        DependencyManager.shared.registerService(Factory<NetworkService> {
            NetworkService()
        })
        
        DependencyManager.shared.registerService(Factory<ShareService> {
            ShareService()
        })
        
        indicatorView.hidesWhenStopped = true
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        
        guard let viewModel = self.viewModel as? TimelinePageViewModel else { return }
        viewModel.rxTille ~> self.rx.title => disposeBag
        
        // Call out load more when reach to end of table view
        tableView.rx.endReach(30).subscribe(onNext: {
            viewModel.loadMoreAction.execute(())
        }) => disposeBag
    }

    override func setupTableView(_ tableView: UITableView) {
        super.setupTableView(tableView)
        /// Register table view cell
        tableView.register(cellType: ActivityCell.self)
        tableView.register(cellType: TimeLineCell.self)
    }
    
    override func getItemSource() -> RxCollection? {
        /// Provide data source for UITableView
        guard let viewModel = viewModel as? TimelinePageViewModel else { return nil }
        return viewModel.itemsSource
    }
    
    override func cellIdentifier(_ cellViewModel: Any, _ returnClassName: Bool = false) -> String {
        switch cellViewModel {
        case is ActivityCellViewModel:
            return ActivityCell.identifier(returnClassName)
        case is TimelineCellViewModel:
            return TimeLineCell.identifier(returnClassName)
        default:
            return TimeLineCell.identifier(returnClassName)
        }
    }
    
    override func selectedItemDidChange(_ cellViewModel: Any,_ indexPath: IndexPath) {
        /// Handle did tap on table view cell
        let page = PostDetailPage()
        let animator = RectanglerAnimator(withDuration: TimeInterval(0.5), isPresenting: false) 
        navigationService.push(to: page, options: .push(with: animator))
    }
    
    override func destroy() {
        super.destroy()
        viewModel?.destroy()
    }
    
}

```


- Testing
Please check on testing branch. Excute basic test case with coverage over 80%.

##### Services
The library also supports services injection (for Unit Test) and some built-in services, especially navigation service, that helps us to navigate between our pages. Navigation service, by default, is injected to Page and ViewModel
By calling
```swift
DependencyManager.shared.registerDefaults()
```
to register for all built-in services (NavigationService, StorageService and AlertService) in the library
Or you can create your own navigation service and override the default injection. See examples for detail steps to setup services injection.

##### Page Transitions
The library also supports for page transitions, including pages inside a navigation page and pages that presents modally. See examples for how to implement page transitions



## License

MVVM is available under the MIT license. See the LICENSE file for more info.
