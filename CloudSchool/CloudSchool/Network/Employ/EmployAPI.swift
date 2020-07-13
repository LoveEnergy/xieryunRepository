//
//  EmployAPI.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/18.
//  Copyright © 2020 CEI. All rights reserved.
//

//class EmployAPI: NSObject {
//
//}

import Foundation
import UIKit
import Foundation
import RxSwift
import Moya
import Alamofire
import SwifterSwift

enum EmployAPI {
    case allIndustryPositionPosition(parentID : Int)
    case allJobPositionPosition(parentID: Int)
}

extension EmployAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: Constant.serverBaseURL)!
    }
    
    var path: String {
        switch self {
        case .allIndustryPositionPosition:
            return "/cei/front/search_industry_category_list"
        case .allJobPositionPosition:
            return "/cei/front/search_job_category_list"
        }
    }
    
    var method: Moya.Method {
        switch self {
//        case .login:
//             .addReferrer:
//            return .post
        case .allIndustryPositionPosition:
            return .get
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        var dic:[String: Any] = [:]
        switch self {
        case .allIndustryPositionPosition(let parentID):
            dic["parentID"] = parentID
        case .allJobPositionPosition(let parentID):
            dic["parentID"] = parentID
        }
        return dic
    }
    
    var sampleData: Data {
        return "[{\"userId\": \"1\", \"Title\": \"Title String\", \"Body\": \"Body String\"}]".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self.method {
        case .post:
            return .requestParameters(parameters: self.parameters!, encoding: JSONEncoding.default)
        default:
            return .requestParameters(parameters: self.parameters!, encoding: URLEncoding.default)
        }
        
    }
    
    var headers: [String: String]? {
        var dic: [String: String] = [:]
        if let token = UserDefaults.User.string(forKey: .token)?.emptyToNil() {
            dic["token"] = token
        }
        switch self.method {
        case .post:
            dic["Content-type"] = "application/json"
        default:
            break
        }
        return dic
    }
}
