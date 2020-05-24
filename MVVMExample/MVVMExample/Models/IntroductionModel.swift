//
//  IntroductionModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/24/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import Foundation
import MVVM
import ObjectMapper

class IntroductionModel: Model {
    
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
