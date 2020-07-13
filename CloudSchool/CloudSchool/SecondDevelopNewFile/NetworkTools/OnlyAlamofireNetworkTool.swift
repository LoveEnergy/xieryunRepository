//
//  OnlyAlamofireNetworkTool.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/1/10.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case GET
    case POST
}

class HttpNetworkTools{
    class func requestData(type : MethodType, parameter : [String : NSString]? = nil, urlString : String,  finishCallBack : @escaping (_ result : AnyObject) -> ()){
        var netType = HTTPMethod.get
        if type == .GET {
            netType = HTTPMethod.get
        }else{
            netType = HTTPMethod.post
        }
//        let reachable = NetworkReachabilityManager()?.isReachable
        Alamofire.request("\(Constant.serverBaseURL)\(urlString)", method: netType, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard let resultData = response.result.value else{
                print(response.result.error)
                return
            }
            finishCallBack(resultData as AnyObject)
        }
    }
}
