//
//  ContactModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/24/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import Foundation
import ObjectMapper
import MVVM

class ContactModel: Model {
    
    var name = ""
    var phone = ""
    
    convenience init() {
        self.init(JSON: [String: Any]())!
    }
    
    override func mapping(map: Map) {
        name <- map["name"]
        phone <- map["phone"]
    }
}

