//
//  ModifySchollRollViewModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/3/6.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ModifySchollRollViewModel: NSObject {
    public var showLoadBlock:(()->())?
    public var hideLoadBlock:(()->())?
    var eclassID: String
    let disposeBag: DisposeBag = DisposeBag()
    var title: String {
        return "修改学籍信息"
    }
    
    var data: Variable<[SchoolRollKeyValueModel]> = Variable([])
    
    init(eclassID: String) {
        self.eclassID = eclassID
        super.init()
        self.loadData()
    }
    
    init(liveCourseID: String) {
        self.eclassID = liveCourseID
        super.init()
        self.loadLiveClassData()
    }
    
    func loadData() {
        UserHelper.shared.getClassSchoolRoll(eclassID: self.eclassID)
            .asObservable()
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                self.data.value = model.data
                }, onError: { (error) in
                    HUD.showError(error: error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadLiveClassData() {
        UserHelper.shared.getLiveClassSchoolRoll(liveCourseID: self.eclassID)
            .asObservable()
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                self.data.value = model.data
                }, onError: { (error) in
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
                let dataDic = self.dataToDictionary(data: data!)
                if let code = dataDic!["code"]{
                    if code is Int, let y = code as? Int{
                        if y == 200{
                            CurrentControllerHelper.currentViewController().navigationController?.popViewController(animated: true)
                        }else{
                            HUD.showText(text: "修改失败")
                        }
                    }else{
                        HUD.showError(error: error!.localizedDescription)
                    }
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
                let dataDic = self.dataToDictionary(data: data!)
                if let code = dataDic!["code"]{
                    if code is Int, let y = code as? Int{
                        if y == 200{
                            CurrentControllerHelper.currentViewController().navigationController?.popViewController(animated: true)
                        }else{
                            HUD.showText(text: "修改失败")
                        }
                    }else{
                        HUD.showError(error: error!.localizedDescription)
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
