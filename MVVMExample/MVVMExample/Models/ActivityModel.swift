//
//  ActivityModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 9/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import MVVM
import ObjectMapper
import SwiftyJSON

class ActivityModel: Model {
    
    var title = ""
    var tweets: Int = 0
    var following: Int = 0
    var follower: Int = 0
    var likes: Int = 0
    
    override func mapping(map: Map) {
        title <- map["title"]
        tweets <- map["tweets"]
        following <- map["following"]
        follower <- map["follower"]
        likes <- map["likes"]
    }
}
