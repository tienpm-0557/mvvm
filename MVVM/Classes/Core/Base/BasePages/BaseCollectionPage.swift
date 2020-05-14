//
//  BaseCollectionPage.swift
//  Action
//
//  Created by pham.minh.tien on 4/29/20.
//

import Foundation
import RxSwift
import RxCocoa

open class BaseCollectionPage: BasePage {
    @IBOutlet public weak var collectionView: UICollectionView!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
    }
       
    open override func initialize() {
        super.initialize()
        setupCollectionView()
    }
    
    open func getItemSource() -> RxCollection? {
        fatalError("Subclasses have to implement this method.")
    }
    
    private func setupCollectionView()  {
        if collectionView == nil {
            assert(false, "BaseCollectionPage: You must set outlet for collectionView")
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        registerNibWithColletion(collectionView)
    }
    
    // MARK: - Abstract for subclasses
    /**
    Subclasses have to override this method to return correct cell identifier based `CVM` type.
    */
    open func registerNibWithColletion(_ collectionView: UICollectionView) {
        assert(false, "This is an abstract method and should be overridden.")
    }
    
    open func cellIdentifier(_ cellViewModel: Any,_ isClass: Bool = false) -> String {
        fatalError("This is an abstract method and should be overridden.")
    }
    
    func getHeaderSection(item: AnyObject?,_isClassName: Bool,withSection section:Int) -> String? { return nil }
    
    /**
    Subclasses override this method to handle cell pressed action.
    */
    open func selectedItemDidChange(_ cellViewModel: Any) { }
    
    open func itemAtIndexPath(_ indexPath: IndexPath) -> Any? {
        if let itemsSource = getItemSource(),
            let cellViewModel = itemsSource.element(atSection: indexPath.section, row: indexPath.row) {
            return cellViewModel
        }
        return nil
    }
    
    open override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        collectionView.rx.itemSelected.asObservable().subscribe(onNext: onItemSelected) => disposeBag
        getItemSource()?.collectionChanged
            .observeOn(Scheduler.shared.mainScheduler)
            .subscribe(onNext: onDataSourceChanged) => disposeBag
    }
    
    
    private func onDataSourceChanged(_ changeSet: ChangeSet) {
        if !changeSet.animated || (changeSet.type == .reload && collectionView.numberOfSections == 0) {
            collectionView.reloadData()
        } else {
            collectionView.performBatchUpdates({
                switch changeSet {
                case let data as ModifySection:
                    switch data.type {
                    case .insert:
                        collectionView.insertSections(IndexSet([data.section]))
                    
                    case .delete:
                        if data.section < 0 {
                            let sections = Array(0...collectionView.numberOfSections - 1)
                            collectionView.deleteSections(IndexSet(sections))
                        } else {
                            collectionView.deleteSections(IndexSet([data.section]))
                        }
                        
                    default:
                        if data.section < 0 {
                            let sections = Array(0...collectionView.numberOfSections - 1)
                            collectionView.reloadSections(IndexSet(sections))
                        } else {
                            collectionView.reloadSections(IndexSet([data.section]))
                        }
                    }
                    
                case let data as ModifyElements:
                    switch data.type {
                    case .insert:
                        collectionView.insertItems(at: data.indexPaths)
                        
                    case .delete:
                        collectionView.deleteItems(at: data.indexPaths)
                        
                    default:
                        collectionView.reloadItems(at: data.indexPaths)
                    }
                    
                case let data as MoveElements:
                    for (i, fromIndexPath) in data.fromIndexPaths.enumerated() {
                        let toIndexPath = data.toIndexPaths[i]
                        collectionView.moveItem(at: fromIndexPath, to: toIndexPath)
                    }
                    
                default:
                    collectionView.reloadData()
                }
                
                // update counter
            }, completion: nil)
        }
        
    }
    
    
    private func onItemSelected(_ indexPath: IndexPath) {
        guard let itemsSource = getItemSource() else { return }
        if let cellViewModel = itemsSource.element(atIndexPath: indexPath) {
            selectedItemDidChange(cellViewModel)
        }
    }
}

extension BaseCollectionPage: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return getItemSource()?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getItemSource()?.countElements(at: section) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellViewModel = itemAtIndexPath(indexPath) else {
            return UICollectionViewCell(frame: .zero)
        }
        
        let identifier = cellIdentifier(cellViewModel)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        // set index for each cell
        (cellViewModel as? IIndexable)?.indexPath = indexPath
        if indexPath.item == collectionView.numberOfItems(inSection: indexPath.section) {
            (cellViewModel as? IIndexable)?.isLastRow = true
        } else {
            (cellViewModel as? IIndexable)?.isLastRow = false
        }
        
        if let cell = cell as? IAnyView {
            cell.anyViewModel = cellViewModel
        }
        return cell
    }
//
//    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if (kind == UICollectionView.elementKindSectionHeader) {
//            let headerclass = self.getHeaderClassAtIndex(indexPath.section)
//            let collectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: (headerclass?.nibName())!, for: indexPath)
//            return getBaseHeaderView(at: indexPath, withUICollectionReusableView: collectionHeader)
//        } else if (kind == UICollectionView.elementKindSectionFooter) {
//            let headerclass = self.getFooterClassAtIndex(indexPath.section)
//            let collectionFooter = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: (headerclass?.nibName())!, for: indexPath)
//            return getBaseHeaderView(at: indexPath, withUICollectionReusableView: collectionFooter)
//        }
//        return BaseHeaderCollectionView()
//    }
}

extension BaseCollectionPage: UICollectionViewDelegate {
    
}


extension BaseCollectionPage: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cellViewModel = itemAtIndexPath(indexPath) else {
            return CGSize.zero
        }
        
        let cellClassString = cellIdentifier(cellViewModel, true)
        let cellClass = NSClassFromString(cellClassString) as? BaseCollectionCell.Type
        
        if let size = cellClass?.getSize(withItem: cellViewModel) {
            return size
        }
        return CGSize.zero
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if self.getListItem(sectionIndex: section).count > 0 {
//            if let header = self.getHeaderClassAtIndex(section) {
//                if header.getSize(withItem: nil) != nil {
//                    var item:AnyObject!
//                    if sections.count > section {
//                        item = sections[section]
//                    }
//                    return header.getSize(withItem: item) ?? header.getSize() ?? CGSize.zero
//                }
//                return header.getSize() ?? CGSize.zero
//            }
//        }
//        return CGSize.zero
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        if let header = self.getFooterClassAtIndex(section) {
//            if collectionView.numberOfItems(inSection: 0) == 0 {
//                return CGSize.zero
//            }
//            return header.getSize() ?? CGSize.zero
//        }
//        return CGSize.zero
//    }
}
