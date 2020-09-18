//
//  TabbarModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 9/18/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import MVVM
import ObjectMapper
import SwiftyJSON

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
