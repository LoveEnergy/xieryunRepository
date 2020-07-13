
//
//  CourseWareListViewModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/12/31.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CourseWareListViewModel: NSObject, ViewControllerBaseInfoProtocol {
    var title: String {
        return ""
    }
    
    var data: Variable<[CourseWareModel]> = Variable([])
    var liveUrl: Variable<String> = Variable("")
    let disposeBag = DisposeBag()
    var courseID: String
    var productID: String = ""
    var liveCourseID: Int = 0
    
    init(courseID: String) {
        self.courseID = courseID
        super.init()
        loadData()
    }
    
    init(productID: String) {
        self.courseID = ""
        self.productID = productID
        super.init()
        loadLiveData()
    }
    
    init(liveCourseID: Int){
        self.liveCourseID = liveCourseID
        self.courseID = ""
        super.init()
        loadPlayBackListData()
    }
    
    func loadData() {
        UserHelper.shared.getCourseWareList(courseID: self.courseID)
            .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                self.data.value = list.data
                }, onError: { (error) in
                    
            })
            .disposed(by: disposeBag)
    }
    
    func loadLiveData() {
        guard let productID = productID.emptyToNil() else {
            //            HUD.showText(text: "没有产品ID")
            return
        }
        RequestHelper.shared.getProuct(productID: productID)
            .asObservable()
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                guard let data = model.data else { return }
                self.liveUrl.value = data.playUrl
                }, onError: { (error) in
                    
            })
            .disposed(by: disposeBag)
    }
    
    func loadPlayBackListData(){
        UserHelper.shared.liveClassPlayBackList(liveCourseID: self.liveCourseID).asObservable().subscribe(onNext: {[weak self] (model) in
            guard let `self` = self else { return }
            self.data.value = model.data
            }, onError: { (error) in
                
        }).disposed(by: disposeBag)
    }
    
    func editAddress(model: AddressModel) {
        let vc = R.storyboard.my.addAddressViewController()!
        vc.model = model
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
    
    func deleteAddress(model: AddressModel) {
        UserHelper.shared.deleteAddress(id: model.addressID)
            .asObservable()
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                model.errorDeal(successBlock: {
                    HUD.showText(text: model.message ?? "删除成功")
                    self.loadData()
                })
                }, onError: { (error) in
                    
            })
            .disposed(by: disposeBag)
    }
    
}

import ObjectMapper

class CourseWareModel: NSObject, Mappable {
    var high: String = ""
    var period: Int = 0
    var width: String = ""
    var coursewareID: Int = 0
    var thumbnailUrl: String = ""
    var standardVideUrl: String = ""
    var teacherName: String = ""
    var key: String = ""
    var coursewareName: String = ""
    var courseID: Int = 0
    var videoID: Int = 0
    var duration: String = ""
    var smallPhotoUrl: String = ""
    
    var playbackCourseID: Int = 0
    var liveCourseID: Int = 0
    var playbackCourseName: String = ""
    var highVideUrl: String = ""
    var humbnailUrl: String = ""
    var size: String = ""
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        high <- map["high"]
        period <- map["period"]
        coursewareName <- map["coursewareName"]
        thumbnailUrl <- map["thumbnailUrl"]
        standardVideUrl <- map["standardVideUrl"]
        width <- map["width"]
        teacherName <- map["teacherName"]
        coursewareID <- map["coursewareID"]
        key <- map["key"]
        courseID <- map["courseID"]
        videoID <- map["videoID"]
        duration <- map["duration"]
        smallPhotoUrl <- map["smallPhotoUrl"]
        
        playbackCourseID <- map["playbackCourseID"]
        liveCourseID <- map["liveCourseID"]
        playbackCourseName <- map["playbackCourseName"]
        highVideUrl <- map["highVideUrl"]
        humbnailUrl <- map["humbnailUrl"]
        size <- map["size"]
    }
}
