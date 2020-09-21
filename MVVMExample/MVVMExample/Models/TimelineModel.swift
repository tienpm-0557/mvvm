//
//  TimelineModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 9/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import MVVM
import ObjectMapper
import SwiftyJSON

class TimelineModel: Model {
    
    var title = ""
    var desc = ""
    var thumbnail = ""
    var createDate = ""
    var reaction:Int = 0
    
    var user: UserInfoModel?
    
    var type: TimelineModelType = .normal
    var json: JSON = []
    
    override func mapping(map: Map) {
        title <- map["title"]
        desc <- map["description"]
        thumbnail <- map["thumbnail"]
        createDate <- map["createDate"]
        reaction <- map["reaction"]
        type <- (map["type"], TimelineModelTypeTransform())
        user <- (map["user"], UserInfoTransform())
    }

}


class UserInfoTransform: TransformType {
    typealias Object = UserInfoModel
    typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> Object? {
        if let userInfo = value as? [String: Any] {
            return UserInfoModel(JSON: userInfo)
        }
        return nil
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        if let user = value {
            return "{id:\"\(user.user_id)\", username: \"\(user.username)\", avatar: \"\(user.avatar)\", displayName:\"\(user.displayName)\"}"
        }
        return nil
    }
}

class TimelineModelTypeTransform: TransformType {
    typealias Object = TimelineModelType
    typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> Object? {
        if let type = value as? String, let code = Int(type) {
            return TimelineModelType(rawValue: code)
        }
        return nil
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        return "\(value?.rawValue ?? 0)"
    }
}

public enum TimelineModelType: Int {
    case normal = 0
    case activity = 1
    
    init?(statusCode: Int?) {
        if let _statusCode = statusCode {
            self.init(rawValue: _statusCode)
        }
        return nil
    }
    
    var message: String {
        switch self {
        case .normal:
            return "Normal post"
        case .activity:
            return "Activity view"
        }
    }
}
