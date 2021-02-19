//
//  UserInfoModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 9/18/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import ObjectMapper

class UserInfoModel: Model {
    var displayName: String = ""
    var user_id: Int = 0
    var avatar: String = ""
    var username: Int = 0

    override func mapping(map: Map) {
        username <- map["username"]
        user_id <- map["id"]
        displayName <- map["displayName"]
        avatar <- map["avatar"]
    }
}
