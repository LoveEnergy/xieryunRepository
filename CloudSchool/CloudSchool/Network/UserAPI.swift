//
//  UserAPI.swift
//  KuTing
//
//  Created by Maynard on 2018/3/26.
//  Copyright © 2018年 Pengxianhe. All rights reserved.
//

import Foundation
import UIKit
import Foundation
import RxSwift
import Moya
import Alamofire

enum UserAPI {
    case getUserInfo()
    //我的车牌
    case myCarNumber()
    case addCarNumber(name: String, phone: String, license: String, isDefault: Int)
    case editCarNumber(name: String, phone: String, license: String, licenseID: String, isDefault: Int)
    //意见反馈
    case feedback(content: String)
    //设置用户信息
    case modifyUserInfo(name: String?, sex: Int?, image: Int?)
    //手机号是否已经注册
    case isRegister(telephone: String)
    
    case deleteCarNumber(license_id: String)
    
    //上传图片
    case uploadImage(image: UIImage)
    
}

extension UserAPI: TargetType {
    var headers: [String : String]? {
        return [:]
    }
    
    var baseURL: URL {
        switch self {
        case .uploadImage:
            return URL(string: "http://ycapp.zkhj618.com/index.php?r=default/homepage/pictures")!
        default:
            return URL(string: Constant.serverBaseURL)!
        }
        
    }
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserInfo(), .myCarNumber(), .feedback(_), .isRegister(_):
            return .get
        case .modifyUserInfo(_, _, _):
            return .get
        case .addCarNumber:
            return .get
        case .deleteCarNumber(_):
            return .get
        case .editCarNumber:
            return .get
        case .uploadImage:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        var dic:[String: Any] = [:]
        if let user = LoginHelper.shared.currentUser.value {
            dic["userID"] = user.userID ?? ""
//            dic["token"] = user.token ?? ""
        }
        switch self {
        case .getUserInfo():
            dic["r"] = "default/center/userdetail"
        case .myCarNumber():
            dic["r"] = "default/kt/carid"
        case .feedback(let content):
            dic["r"] = "default/center/feedback"
            dic["content"] = content
            
        case .modifyUserInfo(let name, let sex, let image):
            dic["r"] = "default/center/seting"
            if let name = name {
                dic["name"] = name
            }
            if let sex = sex {
                dic["sex"] = sex
            }
            if let img = image {
                dic["img"] = img
            }
            
            
        case .isRegister(let telephone):
            dic["r"] = "default/myCarNumber/checkinfo"
            dic["telephone"] = telephone

        
        case .addCarNumber(let name, let phone, let license, let isDefault):
            dic["r"] = "default/kt/binding"
            dic["license_telephone"] = phone
            dic["license_name"] = name
            dic["is_default"] = isDefault
            dic["license"] = license
            
        case .editCarNumber(let name, let phone, let license, let licenseID, let isDefault):
            dic["r"] = "default/kt/caridedit"
            dic["license_telephone"] = phone
            dic["license_name"] = name
            dic["is_default"] = isDefault
            dic["license"] = license
            dic["license_id"] = licenseID
            
        case .deleteCarNumber(let license_id):
            dic["r"] = "default/kt/delcarnum"
            dic["license_id"] = license_id
            
        case .uploadImage(let url):
            dic["r"] = "default/homepage/pictures"
            dic["file"] = url
        }
        return dic
    }
    
    var sampleData: Data {
        switch self {
        case .uploadImage,.getUserInfo, .myCarNumber:
            return "[{\"userId\": \"1\", \"Title\": \"Title String\", \"Body\": \"Body String\"}]".data(using: String.Encoding.utf8)!
        case .feedback(_):
            return "[{\"userId\": \"1\", \"Title\": \"Title String\", \"Body\": \"Body String\"}]".data(using: String.Encoding.utf8)!
        case .editCarNumber, .addCarNumber, .modifyUserInfo(_, _, _), .isRegister(_), .deleteCarNumber(_):
            return "[{\"userId\": \"1\", \"Title\": \"Title String\", \"Body\": \"Body String\"}]".data(using: String.Encoding.utf8)!
            
        }
    }
    
    var task: Task {
        switch self {
        case .uploadImage(let image):
            var name = "icon-.png"
//            if let phone = LoginHelper.shared.currentUser.value?.telephone {
//                name = "\(phone)-\(name)"
//            }
            let data = image.pngData()!
            let file = MultipartFormData(provider: .data(data), name: "file", fileName: name, mimeType: "image/png")
            return Task.uploadMultipart([file])
        default:
            return .requestParameters(parameters: self.parameters!, encoding: URLEncoding.default)
        }
    }
}
