//
//  MenuModel.swift
//  MVVM_Example
//

import Foundation
import MVVM
import ObjectMapper

class MenuModel: Model {
    var title = ""
    var desc = ""

    convenience init(withTitle title: String, desc: String) {
        self.init(JSON: ["title": title, "desc": desc])!
    }

    override func mapping(map: Map) {
        title <- map["title"]
        desc <- map["desc"]
    }
}
