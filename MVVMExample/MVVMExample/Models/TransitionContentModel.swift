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
    
    convenience init(withTitle title: String, desc: String, url: String) {
        self.init(JSON: ["title": title, "desc": desc, "url": url])!
    }
    
    override func mapping(map: Map) {
        title <- map["title"]
        desc <- map["desc"]
        url <- map["url"]
    }
}
