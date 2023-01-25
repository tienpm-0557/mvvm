//
//  SectionList.swift
//  MVVM
//

import UIKit
import RxSwift
import RxCocoa

public protocol RxCollection {
    var collectionChanged: Observable<ChangeSet> { get }
    var count: Int { get }

    func removeAll(animated: Bool)
    func element(atIndexPath: IndexPath) -> Any?
    func element(atSection: Int, row: Int) -> Any?
    func countElements(at section: Int) -> Int
}

public enum ModificationType {
    case reload, delete, insert, move
}

public protocol ChangeSet {
    var type: ModificationType { get }
    var animated: Bool { get }
}

struct ModifySection: ChangeSet {
    let type: ModificationType
    let section: Int
    let animated: Bool
}

struct ModifyElements: ChangeSet {
    let type: ModificationType
    let indexPaths: [IndexPath]
    let animated: Bool
}

struct MoveElements: ChangeSet {
    let type: ModificationType = .move
    let fromIndexPaths: [IndexPath]
    let toIndexPaths: [IndexPath]
    let animated: Bool
}

/// Section list data sources
public class SectionList<T> where T: Equatable {
    public let element: Any
    
    private var innerSources = [T]()
    
    public subscript(index: Int) -> T {
        get { return innerSources[index] }
        set(newValue) { insert(newValue, at: index) }
    }

    public var count: Int {
        return innerSources.count
    }

    public var first: T? {
        return innerSources.first
    }

    public var last: T? {
        return innerSources.last
    }

    public var allElements: [T] {
        return innerSources
    }

    public init(_ key: Any, initialElements: [T] = []) {
        self.element = key
        innerSources.append(contentsOf: initialElements)
    }

    public func forEach(_ body: ((Int, T) -> Void)) {
        for (index, element) in innerSources.enumerated() {
            body(index, element)
        }
    }
    
    fileprivate func insert(_ element: T, at index: Int) {
        innerSources.insert(element, at: index)
    }

    fileprivate func insert(_ elements: [T], at index: Int) {
        innerSources.insert(contentsOf: elements, at: index)
    }

    fileprivate func append(_ element: T) {
        innerSources.append(element)
    }
    
    fileprivate func append(_ elements: [T]) {
        innerSources.append(contentsOf: elements)
    }

    @discardableResult
    fileprivate func remove(at index: Int) -> T? {
        guard index < innerSources.count, index >= 0 else {
            return nil
        }
        return innerSources.remove(at: index)
    }

    fileprivate func remove(at indice: [Int]) {
        let newSources = innerSources.enumerated().compactMap { indice.contains($0.offset) ? nil : $0.element }
        innerSources = newSources
    }
    
    fileprivate func removeAll() {
        innerSources.removeAll()
    }

    fileprivate func sort(by predicate: (T, T) throws -> Bool) rethrows {
        try innerSources.sort(by: predicate)
    }

    @discardableResult
    fileprivate func firstIndex(of element: T) -> Int? {
        return innerSources.firstIndex(of: element)
    }

    @discardableResult
    fileprivate func lastIndex(of element: T) -> Int? {
        return innerSources.lastIndex(of: element)
    }

    @discardableResult
    fileprivate func firstIndex(where predicate: (T) throws -> Bool) rethrows -> Int? {
        return try innerSources.firstIndex(where: predicate)
    }

    @discardableResult
    fileprivate func lastIndex(where predicate: (T) throws -> Bool) rethrows -> Int? {
        return try innerSources.lastIndex(where: predicate)
    }

    fileprivate func map<U>(_ transform: (T) throws -> U) rethrows -> [U] {
        return try innerSources.map(transform)
    }

    fileprivate func compactMap<U>(_ transform: (T) throws -> U?) rethrows -> [U] {
        return try innerSources.compactMap(transform)
    }
}

public class ReactiveCollection<T>: RxCollection where T: Equatable {
    public func element(atIndexPath: IndexPath) -> Any? {
        return self[atIndexPath.row, atIndexPath.section]
    }
    
    public func element(atSection: Int, row: Int) -> Any? {
        return self[row, atSection]
    }

    private var innerSources: [SectionList<T>] = []

    private let publisher = PublishSubject<ChangeSet>()
    private let rxInnerSources = BehaviorRelay<[SectionList<T>]>(value: [])

    public var collectionChanged: Observable<ChangeSet> {
        return publisher.asObservable()
    }

    public subscript(index: Int, section: Int) -> T {
        get { return innerSources[section][index] }
        set(newValue) { insert(newValue, at: index, of: section) }
    }

    public subscript(index: Int) -> SectionList<T> {
        get { return innerSources[index] }
        set(newValue) { insertSection(newValue, at: index) }
    }

    public var count: Int {
        return innerSources.count
    }

    public var first: SectionList<T>? {
        return innerSources.first
    }

    public var last: SectionList<T>? {
        return innerSources.last
    }

    public func forEach(_ body: ((Int, SectionList<T>) -> Void)) {
        for (index, section) in innerSources.enumerated() {
            body(index, section)
        }
    }
    
    public func countElements(at section: Int = 0) -> Int {
        guard section >= 0 && section < innerSources.count else {
            return 0
        }
        return innerSources[section].count
    }
    // MARK: - section manipulations
    public func reload(at section: Int = -1,
                       animated: Bool = true) {
        if innerSources.count > 0 && section < innerSources.count {
            rxInnerSources.accept(innerSources)
            publisher.onNext(ModifySection(type: .reload, section: section, animated: animated))
        }
    }

    public func reset(_ elements: [T], of section: Int = 0, animated: Bool = true) {
        if section < innerSources.count {
            innerSources[section].removeAll()
            innerSources[section].append(elements)
            rxInnerSources.accept(innerSources)
            publisher.onNext(ModifySection(type: .reload, section: section, animated: animated))
        }
    }

    public func reset(_ sources: [[T]], animated: Bool = true) {
        reset(sources.map { SectionList("", initialElements: $0) }, animated: animated)
    }

    public func reset(_ sources: [SectionList<T>], animated: Bool = true) {
        innerSources.removeAll()
        innerSources.append(contentsOf: sources)
        reload(animated: animated)
    }

    public func insertSection(_ key: Any, elements: [T], at index: Int, animated: Bool = true) {
        insertSection(SectionList<T>(key, initialElements: elements), at: index, animated: animated)
    }

    public func insertSection(_ sectionList: SectionList<T>, at index: Int, animated: Bool = true) {
        if innerSources.count == 0 {
            innerSources.append(sectionList)
        } else {
            innerSources.insert(sectionList, at: index)
        }
        rxInnerSources.accept(innerSources)
        publisher.onNext(ModifySection(type: .insert, section: index, animated: animated))
    }

    public func insertSection(_ sectionList: BaseViewModel, at index: Int, animated: Bool = true) {
        if innerSources.count == 0 {
            innerSources.append(SectionList<T>(sectionList))
        } else {
            innerSources.insert(SectionList<T>(sectionList), at: index)
        }
        rxInnerSources.accept(innerSources)
        publisher.onNext(ModifySection(type: .insert, section: index, animated: animated))
    }

    public func appendSections(_ sectionLists: [SectionList<T>], animated: Bool = true) {
        for sectionList in sectionLists {
            appendSection(sectionList, animated: animated)
        }
    }

    public func appendSection(_ key: Any, elements: [T], animated: Bool = true) {
        appendSection(SectionList<T>(key, initialElements: elements), animated: animated)
    }

    public func appendSectionViewModel(_ viewModel: BaseViewModel, animated: Bool = true) {
        appendSection(SectionList<T>(viewModel), animated: animated)
    }

    public func appendSection(_ sectionList: [BaseViewModel], animated: Bool = true) {
        let section = innerSources.count == 0 ? 0 : innerSources.count
        let appendSection = sectionList.map {
            SectionList<T>($0)
        }
        innerSources.append(contentsOf: appendSection)
        rxInnerSources.accept(innerSources)
        publisher.onNext(ModifySection(type: .insert, section: section, animated: animated))
    }

    public func appendSection(_ sectionList: SectionList<T>, animated: Bool = true) {
        let section = innerSources.count == 0 ? 0 : innerSources.count
        innerSources.append(sectionList)
        rxInnerSources.accept(innerSources)
        publisher.onNext(ModifySection(type: .insert, section: section, animated: animated))
    }

    @discardableResult
    public func removeSection(at index: Int, animated: Bool = true) -> SectionList<T>? {
        guard index < innerSources.count, index >= 0 else {
            return nil
        }
        let element = innerSources.remove(at: index)
        rxInnerSources.accept(innerSources)
        publisher.onNext(ModifySection(type: .delete, section: index, animated: animated))
        return element
    }

    @discardableResult
    public func removeAllItemsOfSection(at index: Int) -> SectionList<T>? {
        guard index < innerSources.count, index >= 0 else {
            return nil
        }
        innerSources[index].removeAll()
        rxInnerSources.accept(innerSources)
        publisher.onNext(ModifySection(type: .delete, section: index, animated: false))
        return innerSources[index]
    }

    public func removeAll(animated: Bool = true) {
        innerSources.removeAll()
        rxInnerSources.accept(innerSources)
        publisher.onNext(ModifySection(type: .delete, section: -1, animated: animated))
    }
    // MARK: - section elements manipulations
    public func insert(_ element: T, at indexPath: IndexPath, animated: Bool = true) {
        insert(element, at: indexPath.row, of: indexPath.section, animated: animated)
    }

    public func insert(_ element: T, at index: Int, of section: Int = 0, animated: Bool = true) {
        insert([element], at: index, of: section, animated: animated)
    }

    public func insert(_ elements: [T], at indexPath: IndexPath, animated: Bool = true) {
        insert(elements, at: indexPath.row, of: indexPath.section, animated: animated)
    }

    public func insert(_ elements: [T], at index: Int, of section: Int = 0, animated: Bool = true) {
        if section >= innerSources.count {
            appendSection("", elements: elements, animated: animated)
            return
        }
        if innerSources[section].count == 0 {
            innerSources[section].append(elements)
        } else if index < innerSources[section].count {
            innerSources[section].insert(elements, at: index)
        }
        let indexPaths = Array(index..<index + elements.count).map { IndexPath(row: $0, section: section) }
        rxInnerSources.accept(innerSources)
        publisher.onNext(ModifyElements(type: .insert, indexPaths: indexPaths, animated: animated))
    }

    public func append(_ element: T, to section: Int = 0, animated: Bool = true) {
        append([element], to: section, animated: animated)
    }

    public func append(_ elements: [T], to section: Int = 0, animated: Bool = true) {
        if section >= innerSources.count {
            appendSection("", elements: elements, animated: animated)
            return
        }
        let indexPaths: [IndexPath]
        if elements.count == 0 {
            indexPaths = []
        } else {
            let startIndex = innerSources[section].count == 0 ? 0 : innerSources[section].count
            indexPaths = Array(startIndex..<startIndex + elements.count).map { IndexPath(row: $0, section: section) }
        }
        innerSources[section].append(elements)
        rxInnerSources.accept(innerSources)
        publisher.onNext(ModifyElements(type: .insert, indexPaths: indexPaths, animated: animated))
    }

    @discardableResult
    public func remove(at indexPath: IndexPath, animated: Bool = true) -> T? {
        return remove(at: indexPath.row, of: indexPath.section, animated: animated)
    }

    @discardableResult
    public func remove(at index: Int, of section: Int = 0, animated: Bool = true) -> T? {
        if let element = innerSources[section].remove(at: index) {
            rxInnerSources.accept(innerSources)
            publisher.onNext(ModifyElements(type: .delete, indexPaths: [IndexPath(row: index, section: section)], animated: animated))
            return element
        }
        return nil
    }

    @discardableResult
    public func remove(at indice: [Int], of section: Int = 0, animated: Bool = true) -> [T] {
        return remove(at: indice.map { IndexPath(row: $0, section: section) })
    }

    @discardableResult
    public func remove(at indexPaths: [IndexPath], animated: Bool = true) -> [T] {
        let removedElements = indexPaths.compactMap { innerSources[$0.section].remove(at: $0.row) }
        rxInnerSources.accept(innerSources)
        publisher.onNext(ModifyElements(type: .delete, indexPaths: indexPaths, animated: animated))
        return removedElements
    }

    public func sort(by predicate: (T, T) throws -> Bool, at section: Int = 0, animated: Bool = true) rethrows {
        let oldElements = innerSources[section].allElements
        try innerSources[section].sort(by: predicate)
        let newElements = innerSources[section].allElements
        var fromIndexPaths: [IndexPath] = []
        var toIndexPaths: [IndexPath] = []
        oldElements.enumerated().forEach { index, element in
            if let newIndex = newElements.firstIndex(of: element) {
                toIndexPaths.append(IndexPath(row: newIndex, section: section))
                fromIndexPaths.append(IndexPath(row: index, section: section))
            }
        }

        if fromIndexPaths.count == toIndexPaths.count {
            rxInnerSources.accept(innerSources)
            publisher.onNext(MoveElements(fromIndexPaths: fromIndexPaths, toIndexPaths: toIndexPaths, animated: animated))
        }
    }

    public func move(from fromIndexPaths: [IndexPath], to toIndexPaths: [IndexPath], animated: Bool = true) {
        guard fromIndexPaths.count == toIndexPaths.count else {
            return
        }

        var validIndice: [Int] = []
        for (index, fromIndexPath) in fromIndexPaths.enumerated() {
            let toIndexPath = toIndexPaths[index]
            if fromIndexPath.section != toIndexPath.section {
                if let element = innerSources[fromIndexPath.section].remove(at: fromIndexPath.row) {
                    innerSources[toIndexPath.section].insert(element, at: toIndexPath.row)
                    validIndice.append(index)
                }
            } else {
                let element = innerSources[fromIndexPath.section][fromIndexPath.row]
                innerSources[toIndexPath.section].insert(element, at: toIndexPath.row)
                if fromIndexPath.row < toIndexPath.row {
                    innerSources[fromIndexPath.section].remove(at: fromIndexPath.row)
                    validIndice.append(index)
                } else if fromIndexPath.row > toIndexPath.row {
                    innerSources[fromIndexPath.section].remove(at: fromIndexPath.row + 1)
                    validIndice.append(index)
                }
            }
        }

        if validIndice.count > 0 {
            rxInnerSources.accept(innerSources)
            publisher.onNext(MoveElements(fromIndexPaths: validIndice.map { fromIndexPaths[$0] }, toIndexPaths: validIndice.map { toIndexPaths[$0] }, animated: animated))
        }
    }

    public func asObservable() -> Observable<[SectionList<T>]> {
        return rxInnerSources.asObservable()
    }

    public func indexForSection(withKey key: AnyObject) -> Int? {
        return innerSources.firstIndex(where: { key.isEqual($0.element) })
    }

    @discardableResult
    public func firstIndex(of element: T, at section: Int = 0) -> Int? {
        return innerSources[section].firstIndex(of: element)
    }

    @discardableResult
    public func lastIndex(of element: T, at section: Int) -> Int? {
        return innerSources[section].lastIndex(of: element)
    }

    @discardableResult
    public func firstIndex(where predicate: (T) throws -> Bool, at section: Int) rethrows -> Int? {
        return try innerSources[section].firstIndex(where: predicate)
    }

    @discardableResult
    public func lastIndex(where predicate: (T) throws -> Bool, at section: Int) rethrows -> Int? {
        return try innerSources[0].lastIndex(where: predicate)
    }
}
