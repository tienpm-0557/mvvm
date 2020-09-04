//
//  ListPageModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/14/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import Foundation
import ObjectMapper
import MVVM

class SimpleModel: Model {
    
    var title = ""
    
    convenience init?(withTitle title: String) {
        self.init(JSON:["title":title])
    }
    
    override func mapping(map: Map) {
        title <- map["title"]
    }
}

class NumberModel: Model {
    
    var number = Int.random(in: 0..<200000)
}

class SectionTextModel: NumberModel {
    
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

class SectionImageModel: NumberModel {
    
    var imageUrl: URL?
    
    convenience init?(withUrl url: String) {
        self.init(JSON: ["url": url])
    }
    
    override func mapping(map: Map) {
        imageUrl <- (map["url"], URLTransform())
    }
}

class HeaderFooterModel: Model {
    
    var title = ""
    var footer = ""
    var desc = ""
    
    convenience init(withTitle title: String, desc: String, footer: String) {
        self.init(JSON: ["title": title, "desc": desc, "footer": footer])!
    }
    
    override func mapping(map: Map) {
        title <- map["title"]
        desc <- map["desc"]
        footer <- map["footer"]
    }
}

class TabbarModel: Model {
    
    private(set) var title = ""
    private(set) var index = 0
    
    convenience init?(withTitle title: String) {
        self.init(JSON:["title":title])
    }
    
    override func mapping(map: Map) {
        title <- map["title"]
        index <- map["index"]
    }
}
