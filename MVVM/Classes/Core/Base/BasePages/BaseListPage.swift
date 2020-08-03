//
//  BaseListPage.swift
//  Action
//

import Foundation
import RxSwift
import RxCocoa

public enum ListState: Int {
    case normal = 0
    case loadingData = 1
    case loadingMore = 2
    case noLoadMore = 3
    case isEditting = 4
}

public extension ReactiveCollection {
    func toBaseViewModelCollection() -> ReactiveCollection<BaseViewModel>? {
        let newItems = ReactiveCollection<BaseViewModel>()
        self.forEach { (sectionIndex, section) in
            var newSection: [BaseViewModel] = []
            section.forEach({ (index, element) in
                if let vm = element as? BaseViewModel {
                    newSection.append(vm)
                }
            })
            newItems.append(newSection)
        }
        return newItems
    }
}

public extension Reactive where Base: BaseListPage {
    var state: Binder<ListState> {
        return Binder(base) { view, newState in
            view.state = newState
        }
    }
}

open class BaseListPage: BasePage, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet public weak var tableView: UITableView!
    open var autoEstimateRowHeight = true
    open var allowLoadmoreData: Bool = false
    open var state: ListState = .normal
    
    open var pageSize: Int = 10
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    open override func initialize() {    
        setupTableView(tableView)
    }
    
    open override func destroy() {
        super.destroy()
    }
    
    open func setupTableView(_ tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
    }
    
    open func getItemSource() -> RxCollection? {
        fatalError("Subclasses have to implement this method.")
    }
    
    open override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        tableView.reloadData()
        
        tableView.rx.itemSelected
            .asObservable()
            .subscribe(onNext:{ [weak self] indexPath in
                self?.onItemSelected(indexPath)
            }) => disposeBag
        
        getItemSource()?.collectionChanged
            .observeOn(Scheduler.shared.mainScheduler)
            .subscribe(onNext: { [weak self] indexPath in
                self?.onDataSourceChanged(indexPath)
            }) => disposeBag
    }
    
    open override func localHudToggled(_ value: Bool) {
        tableView.isHidden = value
    }
    
    private func onItemSelected(_ indexPath: IndexPath) {
        guard let itemsSource = getItemSource() else { return }
        if let cellViewModel = itemsSource.element(atIndexPath: indexPath) as? BaseCellViewModel {
            selectedItemDidChange(cellViewModel)
            guard let viewModel = self.viewModel as? BaseListViewModel else { return }
            viewModel.rxSelectedItem.accept(cellViewModel)
            viewModel.rxSelectedIndex.accept(indexPath)
            viewModel.selectedItemDidChange(cellViewModel)
        }
    }
    
    private func onDataSourceChanged(_ changeSet: ChangeSet) {
        if changeSet.animated {
            switch changeSet {
            case let data as ModifySection:
                switch data.type {
                case .insert:
                    tableView.insertSections([data.section], with: .top)
                    
                case .delete:
                    if data.section < 0 {
                        if tableView.numberOfSections > 0 {
                            let sections = IndexSet(0...tableView.numberOfSections - 1)
                            tableView.deleteSections(sections, with: .bottom)
                        } else {
                            tableView.reloadData()
                        }
                    } else {
                        tableView.deleteSections([data.section], with: .bottom)
                    }
                    
                default:
                    if data.section < 0 {
                        if tableView.numberOfSections > 0 {
                            let sections = IndexSet(0...tableView.numberOfSections - 1)
                            tableView.reloadSections(sections, with: .automatic)
                        } else {
                            tableView.reloadData()
                        }
                    } else {
                        tableView.reloadSections(IndexSet([data.section]), with: .automatic)
                    }
                }
            case let data as ModifyElements:
                switch data.type {
                case .insert:
                    tableView.insertRows(at: data.indexPaths, with: .top)
                    
                case .delete:
                    tableView.deleteRows(at: data.indexPaths, with: .bottom)
                    
                default:
                    tableView.reloadRows(at: data.indexPaths, with: .automatic)
                }
                
            case let data as MoveElements:
                tableView.beginUpdates()
                
                for (i, fromIndexPath) in data.fromIndexPaths.enumerated() {
                    let toIndexPath = data.toIndexPaths[i]
                    tableView.moveRow(at: fromIndexPath, to: toIndexPath)
                }
                
                tableView.endUpdates()
                
            default:
                tableView.reloadData()
            }
        } else {
            tableView.reloadData()
        }
    }
    
    // MARK: - Abstract for subclasses
    
    /**
     Subclasses have to override this method to return correct cell identifier based `CVM` type.
     */
    open func cellIdentifier(_ cellViewModel: Any,_ returnClassName: Bool = false) -> String {
        fatalError("Subclasses have to implement this method.")
    }
    
    open func headerIdentifier(_ headerViewModel: Any, _ returnClassName: Bool = false) -> String? {
        assert(true, "Subclasses have to implement this method.")
        return nil
    }
    
    open func footerIdentifier(_ footerViewModel: Any, _ returnClassName: Bool = false) -> String? {
        assert(true, "Subclasses have to implement this method.")
        return nil
    }
    /**
     Subclasses override this method to handle cell pressed action.
     */
    open func selectedItemDidChange(_ cellViewModel: Any) { }
    
    // MARK: - Table view datasources
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        let count = getItemSource()?.count ?? 0
        print("sections: \(count)")
        return count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = getItemSource()?.countElements(at: section) ?? 0
        print("rows: \(count)")
        return count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemsSource = getItemSource(), let cellViewModel = itemsSource.element(atIndexPath: indexPath) else {
            return UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        
        // set index for each cell
        (cellViewModel as? IIndexable)?.indexPath = indexPath
        
        let identifier = cellIdentifier(cellViewModel)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        if let cell = cell as? IAnyView {
            cell.anyViewModel = cellViewModel
        }
        
        /// Load more data if need
        if allowLoadmoreData,
            indexPath.row >= pageSize - 1,
            indexPath.row > tableView.numberOfRows(inSection: indexPath.section)  - 2
        {
            if state == .normal {
                if let viewModel = self.viewModel as? BaseListViewModel {
                    viewModel.loadMoreContent()
                }
            }
        }
        
        return cell
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { }
    
    open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) { }
    
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: - Table view delegates
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return dequeueReusableHeaderFooterView(section: section)
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForFooterInSection(section: section)
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return dequeueReusableHeaderFooterView(isFooter: true, section: section)
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightForFooterInSection(isFooter: true, section: section)
    }
    
    private func dequeueReusableHeaderFooterView(isFooter:Bool = false, section: Int ) -> UIView? {
        guard let viewModel = viewModel as? BaseListViewModel, let cellViewModel = viewModel.itemsSource[section].key as? BaseViewModel else { return nil }
        
        var identifier = headerIdentifier(cellViewModel)
        if isFooter {
            identifier = footerIdentifier(cellViewModel)
        }
        
        guard let _identifier = identifier else { return nil }
        
        if let headerFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: _identifier) as? BaseHeaderTableView {
            headerFooterView.viewModel = cellViewModel
            return headerFooterView
        }
        
        return nil
    }
    
    private func heightForFooterInSection(isFooter:Bool = false, section: Int ) -> CGFloat {
        guard let viewModel = viewModel as? BaseListViewModel, let headerViewModel = viewModel.itemsSource[section].key as? BaseViewModel else { return 0.0 }
        
        var headerFooterClassName = headerIdentifier(headerViewModel, true)
        if isFooter {
            headerFooterClassName = footerIdentifier(headerViewModel, true)
        }
        
        guard let _headerFooterClassName = headerFooterClassName else { return 0.0 }
        
        if let headerFooterClass = NSClassFromString(_headerFooterClassName) as? BaseHeaderTableView.Type {
            return headerFooterClass.height(withItem: headerViewModel)
        }
        
        return 0.0
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /// In case auto estimate cell height.
        if self.autoEstimateRowHeight {
            return UITableView.automaticDimension
        }
        /// Get cell view model
        guard let itemsSource = getItemSource(), let cellViewModel = itemsSource.element(atIndexPath: indexPath) as? BaseViewModel else {
            return UITableView.automaticDimension
        }
        /// get cell class with identifier
        guard let cell =  NSClassFromString(self.cellIdentifier(cellViewModel, true)) as? BaseTableCell.Type else {
            return UITableView.automaticDimension
        }
        /// return cell height
        return cell.height(withItem: cellViewModel)
    }
    
    open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return nil
    }
}
