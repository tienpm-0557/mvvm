//
//  TimelineResponseModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 9/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import MVVM
import ObjectMapper
import SwiftyJSON
import RxSwift

class TimelineResponseModel: Model {
    var stat: HttpStatusCode = .badRequest
    var timelines: [BaseCellViewModel] = []
    var message = ""
    var response: JSON?

    override func mapping(map: Map) {
        stat <- (map["code"], HttpStatusCodeTransform())
        message <- map["message"]
        timelines <- (map["data"], DataTransform())
    }
}

class HttpStatusCodeTransform: TransformType {
    typealias Object = HttpStatusCode
    typealias JSONString = String

    func transformFromJSON(_ value: Any?) -> Object? {
        if let type = value as? String, let code = Int(type) {
            return HttpStatusCode(rawValue: code)
        }
        return nil
    }

    func transformToJSON(_ value: Object?) -> JSONString? {
        return "\(value?.rawValue ?? 0)"
    }
}

class DataTransform: TransformType {
    typealias Object = [BaseCellViewModel]
    typealias JSON = String

    func transformFromJSON(_ value: Any?) -> Object? {
        if let items = value as? [[String: Any]] {
            var result: [AnyObject] = []
            items.forEach { item in
                if let type = item["type"] as? String, type == "activity" {
                    if let timeline = ActivityModel(JSON: item) {
                        let cellViewModel = ActivityCellViewModel(model: timeline)
                        result.append(cellViewModel)
                    }
                } else {
                    if let timeline = TimelineModel(JSON: item) {
                        let cellViewModel = TimelineCellViewModel(model: timeline)
                        result.append(cellViewModel)
                    }
                }
            }
            return result as? [BaseCellViewModel]
        }
        return nil
    }

    func transformToJSON(_ value: Object?) -> JSON? {
        return nil
    }
}
