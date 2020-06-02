# MVVM 

[![CI Status](https://img.shields.io/travis/toandk/DTMvvm.svg?style=flat)](https://travis-ci.org/toandk/DTMvvm)
[![Version](https://img.shields.io/cocoapods/v/DTMvvm.svg?style=flat)](https://cocoapods.org/pods/DTMvvm)
[![License](https://img.shields.io/cocoapods/l/DTMvvm.svg?style=flat)](https://cocoapods.org/pods/DTMvvm)
[![Platform](https://img.shields.io/cocoapods/p/DTMvvm.svg?style=flat)](https://cocoapods.org/pods/DTMvvm)

MVVM is a library for who wants to start writing iOS application using MVVM (Model-View-ViewModel), written in Swift.

- [Features](#features)
- [Requirements](#requirements)
- [Dependencies](#dependencies)
- [Installation](#installation)
- [Example](#example)
- [Usage](#usage)

## Features

- [x] Base classes for UIViewController, UIView, UITableViewCell and UICollectionCell
- [x] Base classes for ViewModel, ListViewModel and CellViewModel
- [x] Services injection
- [x] Custom transitioning for UINavigationController and UIViewController

## Requirements
- iOS 10.0+
- Xcode 10.0+
- Swift 5.0+

## Dependencies
The library heavily depends on [RxSwift](https://github.com/ReactiveX/RxSwift) for data-binding and events. For who does not familiar with Reactive Programming, I suggest to start reading about it first. Beside that, here are the list of dependencies:
- [RxSwift](https://github.com/ReactiveX/RxSwift)
- [Action](https://github.com/RxSwiftCommunity/Action)
- [Alamofire](https://github.com/Alamofire/Alamofire)
- [AlamofireImage](https://github.com/Alamofire/AlamofireImage)
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
    pod 'MVVM'
end
```

Then, run the following command:

```bash
$ pod install
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

### At the glance
The library is mainly written using Generic, so please familiar yourself with Swift Generic, and very important point, we can’t use Generic UIViewController to associate with UIViewController on InterfaceBuilder or Storyboard. So programmatically is prefer, but we can still use XIBs to instantiate our view (check example for more details)

### Libray Components
##### Page, ListPage and CollectionPage
I prefer **Page** over **ViewController** in term of MVVM
* UIViewController
```swift
open class Page<VM: IViewModel>: UIViewController, IView, ITransionView 
```
None generic type
```swift
open class BasePage: UIViewController, ITransitionView
```
* UITableView
```swift
open class ListPage<VM: IListViewModel>: Page<VM>
```
None generic type
```swift
open class BaseListPage: BasePage, UITableViewDataSource, UITableViewDelegate
```
* UICollectionView
```swift
open class CollectionPage<VM: IListViewModel>: Page<VM>
```
None generic type
```swift
open class BaseCollectionPage: BasePage
```

The idea is that each **Page** will contain a **ViewModel** property with type to be determined by generic **VM**

##### View, TableCell and CollectionCell
Same as **Page**, View is all also a generic UIView, while **TableCell** and **CollectionCell** are generic cell that can be used in **ListPage** and **CollectionPage**
```swift
open class View<VM: IGenericViewModel>: UIView, IView
```
None generic type
```swift
open class BaseView: UIView, IView
```

```swift
open class CollectionCell<VM: IGenericViewModel>: UICollectionViewCell, IView
```
None generic type
```swift
open class BaseCollectionCell: UICollectionViewCell, IView
```

```swift
open class TableCell<VM: IGenericViewModel>: UITableViewCell, IView
```
None generic type
```swift
open class BaseTableCell: UITableViewCell, IView
```

They all have generic type **VM** to determine its own ViewModel

By inheriting **View** or **Page**, and implementing 2 main methods:
```swift
open func initialize() {}

open func bindViewAndViewModel() {}
```
Then we have a full set of a view that can bind with ViewModel

##### ViewModel, ListViewModel and CellViewModel
Base classes for our ViewModel
```swift
open class ViewModel<M: Model>: NSObject, IViewModel
```
```swift
open class ListViewModel<M: Model, CVM: IGenericViewModel>: ViewModel<M>, IListViewModel
```
```swift
open class CellViewModel<M: Model>: NSObject, IGenericViewModel
```
As we can see, **ViewModel** and **CellViewModel** use one generic type **M** (which is based type is Model). This generic type is for us to determine the model type for each ViewModel. The difference between **ViewModel** and **CellViewModel** is **ViewModel** contains navigation service that can help use to navigate between our pages in apllication, while **CellViewModel** does not.
**ListViewModel** is a bit different. It uses one more generic type **CVM**, which represented for ViewModel type of a cell in side a page. In the other hand, it contains an items source array that can be bind with a list page or collection page

Please check examples for details usages of these base classes.

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
