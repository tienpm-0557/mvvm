//
//  FlickrSearchModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/24/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import Foundation
import ObjectMapper
import MVVM
import SwiftyJSON

enum FlickrStatus: String {
    case ok = "success"
    case fail = "failed"
}

class FlickrSearchResponse: Model {
    
    var stat: FlickrStatus = .ok
    var page = 1
    var pages = 1
    var photos = [FlickrPhotoModel]()
    var message = ""
    var response_description: JSON?
    
    convenience init() {
        self.init(JSON: [String: Any]())!
    }
    
    override func mapping(map: Map) {
        stat <- (map["stat"], FlickrStatusTransform())
        page <- map["photos.page"]
        pages <- map["photos.pages"]
        photos <- map["photos.photo"]
        message <- map["message"]
    }
}

class FlickrPhotoModel: Model {
    
    var imageUrl: URL {
        let url = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_q.jpg"
        return URL(string: url)!
    }
    
    var id = ""
    var owner = ""
    var secret = ""
    var server = ""
    var farm = 0
    var title = ""
    
    /*
     if you don't want to use these properties, just remove them, I just want
     to show how to deserialize from json using ObjectMapper
     */
    var isPublic = true
    var isFriend = false
    var isFamily = false
    
    override func mapping(map: Map) {
        id <- map["id"]
        owner <- map["owner"]
        secret <- map["secret"]
        server <- map["server"]
        farm <- map["farm"]
        title <- map["title"]
        isPublic <- (map["ispublic"], IntToBoolTransform())
        isFriend <- (map["isfriend"], IntToBoolTransform())
        isFamily <- (map["isfamily"], IntToBoolTransform())
    }
}

class IntToBoolTransform: TransformType {
    typealias Object = Bool
    typealias JSON = Int
    
    func transformFromJSON(_ value: Any?) -> Object? {
        if let type = value as? Int {
            return type != 0
        }
        return nil
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        if let value = value {
            return value ? 1 : 0
        }
        return nil
    }
}

class FlickrStatusTransform: TransformType {
    typealias Object = FlickrStatus
    typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> Object? {
        if let type = value as? String {
            return FlickrStatus(rawValue: type)
        }
        return nil
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        return value?.rawValue
    }
}




