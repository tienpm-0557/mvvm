//
//  ArrayExtensions.swift
//  MVVM
//

import Foundation

public extension Array {
    
    /// Chunk array into smaller parts
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}

public extension Array where Element: Model {
    
    /// Transform array of models into array of viewmodels
    func toCellViewModels<T: IGenericViewModel>() -> [T] where T.ModelElement == Element {
        return compactMap { T(model: $0) }
    }
    
    func toBaseCellViewModels<T: BaseCellViewModel>() -> [T]  {
        return compactMap { T(model: $0)}
    }
}
