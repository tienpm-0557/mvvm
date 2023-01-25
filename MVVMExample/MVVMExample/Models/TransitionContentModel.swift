//
//  TransitionContentModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 8/3/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import ObjectMapper

class TransitionContentModel: Model {
    var title = ""
    var desc = ""
    var url = ""
    var background = ""

    convenience init(withTitle title: String, desc: String, url: String, withBGColor hexColor: String = "#FFFFFF") {
        self.init(JSON: ["title": title, "desc": desc, "url": url, "background": hexColor])!
    }

    override func mapping(map: Map) {
        title <- map["title"]
        desc <- map["desc"]
        url <- map["url"]
        background <- map["background"]
    }
}
