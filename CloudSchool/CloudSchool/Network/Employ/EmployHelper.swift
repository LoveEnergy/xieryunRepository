//
//  EmployHelper.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/18.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import ObjectMapper
import UIKit
import Alamofire

class EmployHelper: NSObject {
    static let shared = EmployHelper()
    
    fileprivate var endpointClosure = { (target: EmployAPI) -> Endpoint in
        return MoyaProvider.defaultEndpointMapping(for: target)
    }
    private lazy var provider = MoyaProvider<EmployAPI>(endpointClosure: self.endpointClosure, plugins: plugins())
    
    let disposeBag = DisposeBag()
    
    override init() {
        super.init()
    }
    
    
    func allIndustryPosition(parentID: Int) -> Observable<AllIndustryPositionPositionModel> {
        return provider.rx.request(EmployAPI.allIndustryPositionPosition(parentID: parentID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: AllIndustryPositionPositionModel.self)
    }
    
    func allJobPosition(parentID: Int) -> Observable<AllJobPositionPositionModel> {
        return provider.rx.request(EmployAPI.allJobPositionPosition(parentID: parentID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: AllJobPositionPositionModel.self)
    }
}


class AllIndustryPositionPositionModel: NSObject, NetworkResultProtocol, Mappable{
    var message: String?
    var code: Int = 0
    var data: [IndustryPositionDetailModel]?
    required init?(map: Map) {
    }

    func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        data <- map["data"]
    }
}
class IndustryPositionDetailModel: NSObject, Mappable {
    var parentID: Int = 0
    var industryName: String = ""
    var industryID: Int = 0

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        parentID <- map["parentID"]
        industryName <- map["industryName"]
        industryID <- map["industryID"]
    }
}

class AllJobPositionPositionModel: NSObject, NetworkResultProtocol, Mappable{
    var message: String?
    var code: Int = 0
    var data: [JobPositionDetailModel]?
    required init?(map: Map) {
    }

    func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        data <- map["data"]
    }
}
class JobPositionDetailModel: NSObject, Mappable {
    var parentID: Int = 0
    var jobName: String = ""
    var jobID: Int = 0

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        parentID <- map["parentID"]
        jobName <- map["jobName"]
        jobID <- map["jobID"]
    }
}
//class BannerList: NSObject, NetworkResultProtocol, Mappable {
//
//    var message: String?
//    var code: Int = 0
//    var data: [BannerModel] = []
//
//    required init?(map: Map) {
//    }
//
//    func mapping(map: Map) {
//        code <- map["code"]
//        message <- map["message"]
//        data <- map["data"]
//    }
//}
//
//class SubSeriesModel: NSObject, Mappable {
//
//    var seriesName: String = ""
//    var seriesID: Int = 0
//    var courseList: [SubSeriesCourseModel] = []
//
//    required init?(map: Map) {
//    }
//
//    func mapping(map: Map) {
//        seriesName <- map["seriesName"]
//        seriesID <- map["seriesID"]
//        courseList <- map["courseList"]
//    }
//
//}
//
//class SubSeriesCourseModel: NSObject, Mappable {
//
//    var productName: String = ""
//    var productID: Int = 0
//    var courseID: Int = 0
//
//    required init?(map: Map) {
//    }
//
//    func mapping(map: Map) {
//        productName <- map["productName"]
//        productID <- map["productID"]
//        courseID <- map["courseID"]
//    }
//
//}
//
//class BannerModel: NSObject, Mappable {
//
//    var imageUrl: String = ""
//    var rotationID: Int = 0
//    var sequence: Int = 0
//    var pageID: Int = 0
//    var linkUrl: String = ""
//    var productID: Int = 0
//    var linkType: Int = 0//类型（1、产品2、网页3、写作）
//
//    required init?(map: Map) {
//    }
//
//    func mapping(map: Map) {
//        imageUrl <- map["imageUrl"]
//        rotationID <- map["rotationID"]
//        sequence <- map["sequence"]
//        pageID <- map["pageID"]
//        linkUrl <- map["linkUrl"]
//        linkType <- map["linkType"]
//        productID <- map["productID"]
//    }
//
//}
//
//class BaseListModel<T: Mappable>: NSObject, NetworkResultProtocol, Mappable {
//    var message: String?
//    var code: Int = 0
//    var data: [T] = []
//
//    required init?(map: Map) {
//
//    }
//
//    func mapping(map: Map) {
//        code <- map["code"]
//        message <- map["message"]
//        data <- map["data"]
//    }
//}
//
//class BaseInfoModel<T: Mappable>: NSObject, NetworkResultProtocol, Mappable {
//    var message: String?
//    var code: Int = 0
//    var data: T?
//
//    required init?(map: Map) {
//    }
//
//    func mapping(map: Map) {
//        code <- map["code"]
//        message <- map["message"]
//        data <- map["data"]
//    }
//}
//
//class AvatorImageModel: NSObject, Mappable {
//    var headerUrl: String = ""
//
//    required init?(map: Map) {
//    }
//
//    func mapping(map: Map) {
//        headerUrl <- map["headerUrl"]
//    }
//}
//
//class PagerListModel<T: Mappable>: NSObject, Mappable {
//    var pageNo: NSNumber = 0
//    var totalRows: NSNumber = 0
//    var rows: [T] = []
//
//    required init?(map: Map) {
//    }
//
//    func mapping(map: Map) {
//        totalRows <- map["pager.totalRows"]
//        pageNo <- map["pager.pageNo"]
//        rows <- map["rows"]
//    }
//}
//
//
//class HomeCourseList: NSObject, NetworkResultProtocol, Mappable {
//
//    var message: String?
//    var code: Int = 0
//    var data: [HomeListSection] = []
//
//    required init?(map: Map) {
//    }
//
//    func mapping(map: Map) {
//        code <- map["code"]
//        message <- map["message"]
//        data <- map["data"]
//    }
//}
//
//class HomeListSection: NSObject, Mappable, SeriesInfo {
//    var seriesName: String {
//        return floorName
//    }
//
//
//    var floorName: String = ""
//    var linkUrl: String = ""
//    var floorNo: Int = 0
//    var courseList: [CourseModel] = []
//    var seriesID: Int {
//        return floorNo
//    }
//
//
//    required init?(map: Map) {
//    }
//
//    func mapping(map: Map) {
//        floorName <- map["floorName"]
//        linkUrl <- map["linkUrl"]
//        floorNo <- map["floorNo"]
//        courseList <- map["courseList"]
//    }
//
//    func openMore() {
//        let vc = BaseListViewController<ClassifyMoreCourseListViewModel>.init(viewModel: ClassifyMoreCourseListViewModel(model: self))
//        CurrentControllerHelper.pushViewController(viewController: vc)
//    }
//}
//class CourseModel: NSObject, Mappable, CourseProtocol {
//    var addressString: String? {
//        return self.address
//    }
//
//    var priceValue: CGFloat {
//        return basicPrice
//    }
//
//    var price: String {
//        return "¥\(basicPrice)"
//    }
//
//    var buyNumber: Int {
//        return buyCount
//    }
//
//    var imageURL: String {
//        return thumbnailUrl
//    }
//
//    var name: String {
//        return productName
//    }
//    var productType: Int = 0
//
//    var cityName: String = ""
//    var countyName: String = ""
//    var buyCount: Int = 0
//    var likeCount: Int = 0
//    var streetName: String = ""
//    var thumbnailUrl: String = ""
//
//    var teacherName: String = ""
//    var classCategoryName: String = ""
//    var previewImgUrl: String = ""
//    var productName: String = ""
//    var classCategoryID: Int = 0
//    var productID: Int = 0
//    var classType: Int = 0
//    var provinceName: String = ""
//
//    var teacherID: String = ""
//    var closeTime: String = ""
//    var address: String = ""
//    var startTime: String = ""
//    var status: String = ""
//    var basicPrice: CGFloat = 0.0
//    var activityMap: ShareActivityModel?
//    var applePayID: String = ""
//    var applePrice: Int = 0
//    required init?(map: Map) {
//    }
//
//    func mapping(map: Map) {
//        activityMap <- map["activityMap"]
//        productType <- map["productType"]
//        cityName <- map["cityName"]
//        productID <- map["productID"]
//        countyName <- map["countyName"]
//        buyCount <- map["buyCount"]
//        thumbnailUrl <- map["thumbnailUrl"]
//        likeCount <- map["likeCount"]
//        productName <- map["productName"]
//        streetName <- map["streetName"]
//        teacherName <- map["teacherName"]
//        previewImgUrl <- map["previewImgUrl"]
//        classType <- map["classType"]
//        provinceName <- map["provinceName"]
//        teacherID <- map["teacherID"]
//
//        closeTime <- map["closeTime"]
//        address <- map["address"]
//        startTime <- map["startTime"]
//        status <- map["status"]
//        basicPrice <- map["basicPrice"]
//        applePayID <- map["applePayID"]
//        applePrice <- map["applePrice"]
//    }
//
//}
//
//
//class HomeNavigationList: NSObject, NetworkResultProtocol, Mappable {
//
//    var message: String?
//    var code: Int = 0
//    var data: [HomeNavigationModel] = []
//
//    required init?(map: Map) {
//    }
//
//    func mapping(map: Map) {
//        code <- map["code"]
//        message <- map["message"]
//        data <- map["data"]
//    }
//}
//
//class HomeNavigationModel: NSObject, Mappable {
//
//    var navigationName: String = ""
//    var seriesName: String = ""
//    var seriesID: Int = 0
//    var navigationID: Int = 0
//    var childrenList: [SubSeriesModel] = []
//
//    required init?(map: Map) {
//    }
//
//    func mapping(map: Map) {
//        navigationName <- map["navigationName"]
//        seriesID <- map["seriesID"]
//        seriesName <- map["seriesName"]
//        navigationID <- map["navigationID"]
//        childrenList <- map["childrenList"]
//    }
//
//}
//
//
//class PageModel: NSObject, Mappable {
//
//    var thumbnailUrl: String = ""
//    var mobileContent: String = ""
//    var pageName: String = ""
//    var webRaw: String = ""
//    var isVisible: String = ""
//    var webContent: String = ""
//    var mobileRaw: String = ""
//    var pageID: Int = 0
//    var informationID: Int = 0
//    var type: Int = 0
//    var createTime: String = ""
//    var updateTime: String = ""
//
//    required init?(map: Map) {
//    }
//
//    func mapping(map: Map) {
//        webRaw <- map["webRaw"]
//        isVisible <- map["isVisible"]
//        webContent <- map["webContent"]
//        mobileRaw <- map["mobileRaw"]
//        mobileContent <- map["mobileContent"]
//        thumbnailUrl <- map["thumbnailUrl"]
//        pageName <- map["pageName"]
//        pageID <- map["pageID"]
//        informationID <- map["informationID"]
//        type <- map["type"]
//        createTime <- map["createTime"]
//        updateTime <- map["updateTime"]
//    }
//
//}
//
//class RecommonModel: NSObject, Mappable {
//    var pageName: String = ""
//    var productType: Int = 0
//    var productID: Int = 0
//    var productName: String = ""
//    var buyCount: Int = 0
//    var thumbnailUrl: String = ""
//    var likeCount: Int = 0
//    var viewPageID: Int = 0
//    var previewImgUrl: String = ""
//    var recommendID: Int = 0
//    var sequence: Int = 0
//    var basicPrice: Int = 0
//
//    required init?(map: Map) {
//    }
//
//    func mapping(map: Map) {
//        pageName <- map["pageName"]
//        productType <- map["productType"]
//        productID <- map["productID"]
//        productName <- map["productName"]
//        buyCount <- map["buyCount"]
//        likeCount <- map["likeCount"]
//        thumbnailUrl <- map["thumbnailUrl"]
//
//        viewPageID <- map["viewPageID"]
//        recommendID <- map["recommendID"]
//        previewImgUrl <- map["previewImgUrl"]
//        basicPrice <- map["basicPrice"]
//    }
//
//}

