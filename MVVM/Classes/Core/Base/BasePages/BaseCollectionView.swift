//
//  BaseCollectionView.swift
//  MVVM
//
//  Created by pham.minh.tien on 11/30/20.
//

import UIKit

open class BaseCollectionView: BaseView {
    @IBOutlet public weak var collectionView: UICollectionView!
    open var allowLoadmoreData = false
    open var focusLeftCell = false
    open var state: ListState = .normal
    open var pageSize: Int = 10

    open override func initialize() {
        super.initialize()
        self.viewModel?.viewDidLoad = true
        setupCollectionView()
    }

    open func setupCollectionView() {
        if collectionView == nil {
            assert(false, "BaseCollectionPage: You must set outlet for collectionView")
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        registerNibWithColletion(collectionView)
    }

    open func registerNibWithColletion(_ collectionView: UICollectionView) {
        assert(false, "This is an abstract method and should be overridden.")
    }

    open func cellIdentifier(_ cellViewModel: Any, _ isClass: Bool = false) -> String {
        fatalError("This is an abstract method and should be overridden.")
    }

    open func headerIdentifier(_ headerViewModel: Any, _ returnClassName: Bool = false) -> String? {
        assert(true, "Subclasses have to implement this method.")
        return nil
    }

    open func footerIdentifier(_ footerViewModel: Any, _ returnClassName: Bool = false) -> String? {
        assert(true, "Subclasses have to implement this method.")
        return nil
    }

    open func getItemSource() -> RxCollection? {
        fatalError("Subclasses have to implement this method.")
    }

    /**
     Subclasses override this method to handle cell pressed action.
     */
    open func selectedItemDidChange(_ cellViewModel: Any, _ indexPath: IndexPath) { }

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

        if allowLoadmoreData {
            collectionView.rx.endReach(30).subscribe(onNext: {
                if self.state == .normal {
                    if let viewModel = self.viewModel as? BaseListViewModel {
                        viewModel.loadMoreContent()
                    }
                }
            }) => disposeBag
        }
        getItemSource()?.collectionChanged
            .observe(on: Scheduler.shared.mainScheduler)
            .subscribe(onNext: onDataSourceChanged) => disposeBag
    }
    // swiftlint:disable cyclomatic_complexity
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
                    for (index, fromIndexPath) in data.fromIndexPaths.enumerated() {
                        let toIndexPath = data.toIndexPaths[index]
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
        guard let itemsSource = getItemSource() else {
            return
        }
        if let cellViewModel = itemsSource.element(atIndexPath: indexPath) {
            DispatchQueue.main.async {
                self.selectedItemDidChange(cellViewModel, indexPath)
                if let viewModel = self.viewModel as? BaseListViewModel,
                   let cvm = cellViewModel as? BaseCellViewModel {
                    viewModel.selectedItemDidChange(cvm, indexPath)
                }
            }
        }
    }
}

extension BaseCollectionView: UICollectionViewDataSource {
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

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return dequeueReusableHeaderFooterView(kind: kind, indexPath: indexPath) ?? UICollectionReusableView()
    }
}

extension BaseCollectionView: UICollectionViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard focusLeftCell else {
            return
        }

        var indexes = self.collectionView.indexPathsForVisibleItems
        indexes.sort()
        var index = indexes.first!
        let cell = self.collectionView.cellForItem(at: index)!
        let position = self.collectionView.contentOffset.x - cell.frame.origin.x
        if position > cell.frame.size.width / 2 {
            index.row += 1
        }

        if index.row > 0 {
            self.collectionView.scrollToItem(at: index, at: .left, animated: true )
        }
    }
}

extension BaseCollectionView: UICollectionViewDelegateFlowLayout {
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

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               referenceSizeForHeaderInSection section: Int) -> CGSize {
        return heightForFooterInSection(isFooter: false, section: section)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return heightForFooterInSection(isFooter: true, section: section)
    }

    private func dequeueReusableHeaderFooterView(kind: String, isFooter: Bool = false, indexPath: IndexPath ) -> UICollectionReusableView? {
        guard let viewModel = viewModel as? BaseListViewModel,
              let cellViewModel = viewModel.itemsSource[indexPath.section].element as? BaseViewModel else {
            return nil
        }

        var identifier = headerIdentifier(cellViewModel)
        if isFooter {
            identifier = footerIdentifier(cellViewModel)
        }

        guard let identifier = identifier else {
            return nil
        }

        if let headerFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as? BaseHeaderCollectionView {
            headerFooterView.viewModel = cellViewModel
            headerFooterView.prepareForDisplay()
            return headerFooterView
        }

        return nil
    }

    private func heightForFooterInSection(isFooter: Bool = false, section: Int ) -> CGSize {
        guard let viewModel = viewModel as? BaseListViewModel,
              let headerViewModel = viewModel.itemsSource[section].element as? BaseViewModel else {
            return CGSize.zero
        }

        var headerFooterClassName = headerIdentifier(headerViewModel, true)
        if isFooter {
            headerFooterClassName = footerIdentifier(headerViewModel, true)
        }

        guard let headerFooterClassName = headerFooterClassName else {
            return CGSize.zero
        }

        if let headerFooterClass = NSClassFromString(headerFooterClassName) as? BaseHeaderCollectionView.Type {
            return headerFooterClass.headerSize(withItem: headerViewModel)
        }

        return CGSize.zero
    }
}
