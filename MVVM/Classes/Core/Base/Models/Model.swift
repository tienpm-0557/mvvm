//
//  Model.swift
//  MVVM
//

import Foundation
import ObjectMapper

open class Model: NSObject, Mappable {
    required public init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    open func mapping(map: Map) {}
}

open class HeaderFooterModel: Model {
    open var title = ""
    open var footer = ""
    open var desc = ""

    public convenience init(withTitle title: String, desc: String, footer: String) {
        self.init(JSON: ["title": title, "desc": desc, "footer": footer])!
    }

    open override func mapping(map: Map) {
        title <- map["title"]
        desc <- map["desc"]
        footer <- map["footer"]
    }
}

public extension Model {
    static func fromJSON<T: Mappable>(_ JSON: Any?) -> T? {
        return Mapper<T>().map(JSONObject: JSON)
    }

    static func fromJSON<T: Mappable>(_ JSONString: String) -> T? {
        return Mapper<T>().map(JSONString: JSONString)
    }

    static func fromJSON<T: Mappable>(_ data: Data) -> T? {
        if let JSONString = String(data: data, encoding: .utf8) {
            return Mapper<T>().map(JSONString: JSONString)
        }
        return nil
    }

    /*
     JSON to model array
     */

    static func fromJSONArray<T: Mappable>(_ JSON: Any?) -> [T] {
        return Mapper<T>().mapArray(JSONObject: JSON) ?? []
    }

    static func fromJSONArray<T: Mappable>(_ JSONString: String) -> [T] {
        return Mapper<T>().mapArray(JSONString: JSONString) ?? []
    }

    static func fromJSONArray<T: Mappable>(_ data: Data) -> [T] {
        if let JSONString = String(data: data, encoding: .utf8) {
            return Mapper<T>().mapArray(JSONString: JSONString) ?? []
        }
        return []
    }
}
