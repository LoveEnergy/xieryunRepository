//
//  AddSchoolRollViewModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/3/5.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddSchoolRollViewModel: NSObject {
    public var fillCompleteBlock:(()->())?//完成学籍填写
    public var showLoadBlock:(()->())?
    public var hideLoadBlock:(()->())?
    var eclassID: String
//    var isLiveClass: Bool = false
    let disposeBag: DisposeBag = DisposeBag()
    var title: String {
        return "填写学籍信息"
    }
    
    var data: Variable<[SchoolRollKeyValueModel]> = Variable([])
    
    init(eclassID: String) {
        self.eclassID = eclassID
        super.init()
        self.loadData()
    }
    
    init(liveClassID: String) {
        self.eclassID = liveClassID
        super.init()
        self.loadLiveData()
    }
    
    func loadData() {
        self.showLoadBlock?()
        UserHelper.shared.getClassSchoolRollInfo(eclassID: self.eclassID)
        .asObservable()
            .subscribe(onNext: {[weak self] (model) in
                self?.hideLoadBlock?()
                guard let `self` = self else { return }
                self.data.value = model.data
            }, onError: { (error) in
                self.hideLoadBlock?()
                HUD.showError(error: error.localizedDescription)
            })
        .disposed(by: disposeBag)
    }
    
    func loadLiveData(){
        self.showLoadBlock?()
        UserHelper.shared.getLiveClassSchoolRollInfo(liveCourseID: self.eclassID).asObservable()
            .subscribe(onNext: {[weak self] (model) in
                self?.hideLoadBlock?()
                guard let `self` = self else { return }
                self.data.value = model.data
            }, onError: { (error) in
                self.hideLoadBlock?()
                HUD.showError(error: error.localizedDescription)
            })
        .disposed(by: disposeBag)
    }
    
    func submitInfo(dic: [[String: Any]]) {
        let url = NSURL.init(string: "\(Constant.serverBaseURL)/cei/save_user_class_school_roll")
        let request = NSMutableURLRequest.init(url: url! as URL)
        request.httpMethod = "post"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UserDefaults.User.string(forKey: .token), forHTTPHeaderField: "token")
        if let jsonString = dic.jsonString(){
            let submitString = "{eclassID:\(self.eclassID), propertyJson:\(jsonString)}"
            request.httpBody = submitString.data(using: String.Encoding.utf8)
            request.timeoutInterval = 10.0
            let queue = OperationQueue.main
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: queue) { (response, data, error) in
                let dict = self.dataToDictionary(data: data!)
                if let code = dict!["code"]{
                    if code is Int, let y = code as? Int{
                        if y == 200{
                            self.fillCompleteBlock?()
                        }else{
                            HUD.showText(text: "保存失败")
                        }
                    }else{
                        HUD.showText(text: "保存失败")
                    }
                }else{
                    HUD.showText(text: "保存失败")
                }
            }
        }
    }
    //直播课填写学籍情况
    func submitLiveClassSchoolRollInfo(dic: [[String: Any]]) {
        let url = NSURL.init(string: "\(Constant.serverBaseURL)/cei/save_user_live_course_school_roll")
        let request = NSMutableURLRequest.init(url: url! as URL)
        request.httpMethod = "post"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UserDefaults.User.string(forKey: .token), forHTTPHeaderField: "token")
        if let jsonString = dic.jsonString(){
            let submitString = "{liveCourseID:\(self.eclassID), propertyJson:\(jsonString)}"
            request.httpBody = submitString.data(using: String.Encoding.utf8)
            request.timeoutInterval = 10.0
            let queue = OperationQueue.main
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: queue) { (response, data, error) in
                if data != nil{
                    let dict = self.dataToDictionary(data: data!)
                        if let code = dict!["code"]{
                            if code is Int, let y = code as? Int{
                                if y == 200{
                                    self.fillCompleteBlock?()
                                }else{
                                    HUD.showText(text: "保存失败")
                                }
                            }else{
                                HUD.showText(text: "保存失败")
                            }
                        }else{
                            HUD.showText(text: "保存失败")
                        }
                    }
                }
        }
    }
    
    //data转dic
    func dataToDictionary(data:Data) ->Dictionary<String, Any>?{
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let dic = json as! Dictionary<String, Any>
            return dic
        }catch _ {
            print("失败")
            return nil
        }
    }

}
