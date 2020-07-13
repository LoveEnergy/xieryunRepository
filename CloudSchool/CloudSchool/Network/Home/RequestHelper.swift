//
//  HomeHelper.swift
//  KuTing
//
//  Created by Maynard on 2018/3/26.
//  Copyright © 2018年 Pengxianhe. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import ObjectMapper
import UIKit
import Alamofire

class RequestHelper: NSObject {
    static let shared = RequestHelper()
    
    fileprivate var endpointClosure = { (target: RequestAPI) -> Endpoint in
        return MoyaProvider.defaultEndpointMapping(for: target)
    }
    private lazy var provider = MoyaProvider<RequestAPI>(endpointClosure: self.endpointClosure, plugins: plugins())
    
    let disposeBag = DisposeBag()
    
    override init() {
        super.init()
    }
    
    func getBanner() -> Observable<BannerList> {
        return provider.rx.request(RequestAPI.banner())
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BannerList.self)
    }
    
    func getCourses() -> Observable<HomeCourseList> {
        return provider.rx.request(RequestAPI.courses())
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: HomeCourseList.self)
    }
    
    func getProuct(productID: String) -> Observable<BaseInfoModel<ProductDetailModel>> {
        return provider.rx.request(RequestAPI.productDetail(productID: productID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseInfoModel<ProductDetailModel>.self)
    }
    
    func getCoursesProductList(id: String, type: String, classType: String, seriesID: String, pageNo: String, pageSize: String) -> Observable<BaseInfoModel<PagerListModel<CourseModel>>> {
        return provider.rx.request(RequestAPI.courseProductList(id: id, type: type, classType: classType, seriesID: seriesID, pageNo: pageNo, pageSize: pageSize))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseInfoModel<PagerListModel<CourseModel>>.self)
    }
    
    func getThirdLevelProductList(parentID: String, seriesID: String, pageNo: String, pageSize: String) -> Observable<BaseInfoModel<PagerListModel<CourseModel>>> {
        return provider.rx.request(RequestAPI.thirdLevelProductList(parentID: parentID, seriesID: seriesID, pageNo: pageNo, pageSize: pageSize))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseInfoModel<PagerListModel<CourseModel>>.self)
    }
    
    func getSubSeriesList(parentID: String, type: String) -> Observable<BaseListModel<CourseSeriesModel>> {
        return provider.rx.request(RequestAPI.subSeries(parentID: parentID, type: type))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseListModel<CourseSeriesModel>.self)
    }
    
    func getNaviList(parentID: String, type: String) -> Observable<HomeNavigationList> {
        return provider.rx.request(RequestAPI.navigation(type: type, parentID: parentID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: HomeNavigationList.self)
    }
    
    func getCourseSeriesList() -> Observable<HomeNavigationList> {
        return provider.rx.request(RequestAPI.courseSeriesList)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: HomeNavigationList.self)
    }
    
    func getTrainList(pageNo: String, pageSize: String) -> Observable<BaseInfoModel< PagerListModel<TrainModel>>> {
        return provider.rx.request(RequestAPI.trainList(pageNo: pageNo, pageSize: pageSize))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseInfoModel<PagerListModel<TrainModel>>.self)
    }
    
    func getBookList(pageNo: String, pageSize: String) -> Observable<BaseInfoModel< PagerListModel<BookModel>>> {
        return provider.rx.request(RequestAPI.bookList(pageNo: pageNo, pageSize: pageSize))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseInfoModel<PagerListModel<BookModel>>.self)
    }
    
    func search(name: String, pageNo: Int, pageSize: Int) -> Observable<BaseInfoModel<PagerListModel<CourseModel>>> {
        return provider.rx.request(RequestAPI.search(name: name, pageNo: pageNo, pageSize: pageSize))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseInfoModel<PagerListModel<CourseModel>>.self)
    }
    
    func getPageList(type: Int, pageNo: Int, pageSize: Int) -> Observable<BaseInfoModel<PagerListModel<PageModel>>> {
        return provider.rx.request(RequestAPI.pageList(type: type, pageNo: pageNo, pageSize: pageSize))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseInfoModel<PagerListModel<PageModel>>.self)
    }
    
    func getNewsDetailList(informationID: String) -> Observable<BaseInfoModel<PageModel>> {
        return provider.rx.request(RequestAPI.newsDetail(id: informationID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseInfoModel<PageModel>.self)
    }
    
    
    
    func getRecommendList(viewPageID: Int, pageNo: Int, pageSize: Int) -> Observable<BaseInfoModel<PagerListModel<RecommonModel>>> {
        return provider.rx.request(RequestAPI.recommendList(pageNo: pageNo, pageSize: pageSize, viewPageID: viewPageID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseInfoModel<PagerListModel<RecommonModel>>.self)
    }
    
    func uploadImage(image: UIImage, type: Int) -> Observable<BaseInfoModel<AvatorImageModel>> {
        return provider.rx.request(RequestAPI.uploadImage(image, type: type))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: BaseInfoModel<AvatorImageModel>.self)
    }
    
    func hotSearch() -> Observable<[String]> {
        return Observable.of(["环境保护", "环境监察", "领导力", "碳资源"])
    }
    
    func getOrderCoupons(productIDs: [String]) -> Observable<BaseListModel<GoodsCouponModel>> {
        return provider.rx.request(RequestAPI.orderCoupons(productIDs: productIDs))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseListModel<GoodsCouponModel>.self)
    }
    
    func getIAPOrder(money: String, orderID: Int) -> Observable<IOSOrderModel> {
        return provider.rx.request(.getIAPOrder(money: money, orderID: orderID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: IOSOrderModel.self)
    }
    
    func getOrderSuccessDetail(orderID: String) -> Observable<paySuccessModel> {
        return provider.rx.request(RequestAPI.orderSuccess(orderID: orderID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: paySuccessModel.self)
    }
    
    func getIOSOrderStatus(poNumber: String, receipt_data: [String: Any]) -> Observable<BaseModel>{
        return provider.rx.request(RequestAPI.rechargeIAPOrder(poNumber: poNumber, receiptData: receipt_data))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseModel.self)
    }
    
//    func getIOSOrderStatusString(poNumber: String, receipt_data: String) -> Observable<BaseModel>{
//        return provider.rx.request(RequestAPI.rechargeIAPOrderString(poNumber: poNumber, receiptData: receipt_data))
//            .filterSuccessfulStatusCodes()
//            .mapJSON()
//            .asObservable().mapObject(type: BaseModel.self)
//    }
    
    func remoteClassData(pageNo: Int, pageSize: Int) -> Observable<RemoteClassModel>{
        return provider.rx.request(RequestAPI.remoteClass(pageNo: pageNo, pageSize: pageSize))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: RemoteClassModel.self)
    }
    
    func postInfoData() -> Observable<BaseInfoModel<PostDataModel>> {
        return provider.rx.request(RequestAPI.postInfoData)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseInfoModel<PostDataModel>.self)
    }
    
    func welcomeInfo() -> Observable<BaseInfoModel<WelcomeInfoModel>> {
        return provider.rx.request(RequestAPI.welcomeInfo)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseInfoModel<WelcomeInfoModel>.self)
    }
//    func uploadImage(image: UIImage, type: Int) -> Observable<BaseInfoModel<AvatorImageModel>> {
//        return provider.rx.request(RequestAPI.uploadImage(image, type: type))
//            .filterSuccessfulStatusCodes()
//            .mapJSON()
//            .asObservable()
//            .mapObject(type: BaseInfoModel<AvatorImageModel>.self)
//    }
    func moreImageUpLoad(images: [UIImage], kind: Int) -> Observable<BaseInfoModel<AvatorImageModel>>{
        return provider.rx.request(RequestAPI.moreImageUpLoad(images: images, kind: kind))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: BaseInfoModel<AvatorImageModel>.self)
    }
    
    func iosRechargeOrder(money: String) -> Observable<IOSOrderModel>{
           return provider.rx.request(RequestAPI.iosRechargeOrder(money: money))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: IOSOrderModel.self)
    }
}

class RemoteClassModel: NSObject, NetworkResultProtocol, Mappable{
    var message: String?
    var code: Int = 0
    var data: RemoteClassInfoModel?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        data <- map["data"]
    }
}

class RemoteClassInfoModel: NSObject, Mappable{
    var pageNo: Int = 0
    var rows: [RemoteClassDetailModel] = []
    var totalRows: Int = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        pageNo <- map["pageNo"]
        rows <- map["rows"]
        totalRows <- map["totalRows"]
    }
}

class RemoteClassDetailModel: NSObject, Mappable{
    var productName: String = ""
    var cityName: String = ""
    var productID: Int = 0
    var buyCount: Int = 0
    var time: String = ""
    var likeCount: Int = 0
    var isGroup: Int = 0
    var isPay: Int = 0
    var streetName: String = ""
    var previewImgUrl: String = ""
    var address: String = ""
    var provinceName: String = ""
    var closeTime: String = ""
    var thumbnailUrl: String = ""
    var trySeeVideoUrl: String = ""
    var startTime: String = ""
    var basicPrice: CGFloat = 0.0
    var eclassID: Int = 0
    var objectType: Int = 0
    var courseType: Int = 0
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        productName <- map["productName"]
        cityName <- map["cityName"]
        productID <- map["productID"]
        
        buyCount <- map["buyCount"]
        time <- map["time"]
        likeCount <- map["likeCount"]
        
        isGroup <- map["isGroup"]
        isPay <- map["isPay"]
        streetName <- map["streetName"]
        
        previewImgUrl <- map["previewImgUrl"]
        address <- map["address"]
        provinceName <- map["provinceName"]
        
        closeTime <- map["closeTime"]
        thumbnailUrl <- map["thumbnailUrl"]
        trySeeVideoUrl <- map["trySeeVideoUrl"]
        
        startTime <- map["startTime"]
        basicPrice <- map["basicPrice"]
        eclassID <- map["eclassID"]
        objectType <- map["objectType"]
        courseType <- map["courseType"]
    }
}

class IOSOrderModel: NSObject, NetworkResultProtocol, Mappable{
    var message: String?
    var code: Int = 0
    var data: IOSOrderDetailModel?
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        data <- map["data"]
    }
}

class IOSOrderDetailModel: NSObject, Mappable {
    var poNumber: String = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        poNumber <- map["poNumber"]
    }
}

class paySuccessModel: NSObject, NetworkResultProtocol, Mappable{
    var message: String?
    var code: Int = 0
    var data: paySuccessDetailModel?
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        data <- map["data"]
    }
}
class paySuccessDetailModel: NSObject, Mappable {
    var payMode: Int = 0
    var price: String = ""
    var poNumber: String = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        payMode <- map["payMode"]
        price <- map["price"]
        poNumber <- map["poNumber"]
    }
    
}
class BannerList: NSObject, NetworkResultProtocol, Mappable {
    
    var message: String?
    var code: Int = 0
    var data: [BannerModel] = []
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        data <- map["data"]
    }
}

class SubSeriesModel: NSObject, Mappable {
    
    var seriesName: String = ""
    var seriesID: Int = 0
    var courseList: [SubSeriesCourseModel] = []
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        seriesName <- map["seriesName"]
        seriesID <- map["seriesID"]
        courseList <- map["courseList"]
    }
    
}

class SubSeriesCourseModel: NSObject, Mappable {
    
    var productName: String = ""
    var productID: Int = 0
    var courseID: Int = 0
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        productName <- map["productName"]
        productID <- map["productID"]
        courseID <- map["courseID"]
    }
    
}

class BannerModel: NSObject, Mappable {
    
    var imageUrl: String = ""
    var rotationID: Int = 0
    var sequence: Int = 0
    var pageID: Int = 0
    var linkUrl: String = ""
    var productID: Int = 0
    var linkType: Int = 0//类型（1、产品2、网页3、写作）
    var appImageUrl: String = ""
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        imageUrl <- map["imageUrl"]
        rotationID <- map["rotationID"]
        sequence <- map["sequence"]
        pageID <- map["pageID"]
        linkUrl <- map["linkUrl"]
        linkType <- map["linkType"]
        productID <- map["productID"]
        appImageUrl <- map["appImageUrl"]
    }
    
}

class BaseListModel<T: Mappable>: NSObject, NetworkResultProtocol, Mappable {
    var message: String?
    var code: Int = 0
    var data: [T] = []
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        data <- map["data"]
    }
}

class BaseInfoModel<T: Mappable>: NSObject, NetworkResultProtocol, Mappable {
    var message: String?
    var code: Int = 0
    var data: T?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        data <- map["data"]
    }
}

class AvatorImageModel: NSObject, Mappable {
    var headerUrl: String = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        headerUrl <- map["headerUrl"]
    }
}

class PagerListModel<T: Mappable>: NSObject, Mappable {
    var pageNo: NSNumber = 0
    var totalRows: NSNumber = 0
    var rows: [T] = []
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        totalRows <- map["pager.totalRows"]
        pageNo <- map["pager.pageNo"]
        rows <- map["rows"]
    }
}


class HomeCourseList: NSObject, NetworkResultProtocol, Mappable {
    
    var message: String?
    var code: Int = 0
    var data: [HomeListSection] = []
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        data <- map["data"]
    }
}

class HomeListSection: NSObject, Mappable, SeriesInfo {
    var seriesName: String {
        return floorName
    }
    
    
    var floorName: String = ""
    var linkUrl: String = ""
    var floorNo: Int = 0
    var courseList: [CourseModel] = []
    var seriesID: Int {
        return floorNo
    }
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        floorName <- map["floorName"]
        linkUrl <- map["linkUrl"]
        floorNo <- map["floorNo"]
        courseList <- map["courseList"]
    }
    
    func openMore() {
        let vc = BaseListViewController<ClassifyMoreCourseListViewModel>.init(viewModel: ClassifyMoreCourseListViewModel(model: self))
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
}
class CourseModel: NSObject, Mappable, CourseProtocol {
    var addressString: String? {
        return self.address
    }
    
    var priceValue: CGFloat {
        return basicPrice
    }
    
    var price: String {
        return "¥\(basicPrice)"
    }
    
    var buyNumber: Int {
        return buyCount
    }
    
    var imageURL: String {
        return thumbnailUrl
    }
    
    var name: String {
        return productName
    }
    var productType: Int = 0
    
    var cityName: String = ""
    var countyName: String = ""
    var buyCount: Int = 0
    var likeCount: Int = 0
    var streetName: String = ""
    var thumbnailUrl: String = ""
    
    var teacherName: String = ""
    var classCategoryName: String = ""
    var previewImgUrl: String = ""
    var productName: String = ""
    var classCategoryID: Int = 0
    var productID: Int = 0
    var classType: Int = 0
    var provinceName: String = ""
    
    var teacherID: String = ""
    var closeTime: String = ""
    var address: String = ""
    var startTime: String = ""
    var status: String = ""
    var basicPrice: CGFloat = 0.0
    var activityMap: ShareActivityModel?
    var applePayID: String = ""
    var applePrice: Int = 0
    var objectType: Int = 0
    var courseType: Int = 0
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        activityMap <- map["activityMap"]
        productType <- map["productType"]
        cityName <- map["cityName"]
        productID <- map["productID"]
        countyName <- map["countyName"]
        buyCount <- map["buyCount"]
        thumbnailUrl <- map["thumbnailUrl"]
        likeCount <- map["likeCount"]
        productName <- map["productName"]
        streetName <- map["streetName"]
        teacherName <- map["teacherName"]
        previewImgUrl <- map["previewImgUrl"]
        classType <- map["classType"]
        provinceName <- map["provinceName"]
        teacherID <- map["teacherID"]
        
        closeTime <- map["closeTime"]
        address <- map["address"]
        startTime <- map["startTime"]
        status <- map["status"]
        basicPrice <- map["basicPrice"]
        applePayID <- map["applePayID"]
        applePrice <- map["applePrice"]
        objectType <- map["objectType"]
        courseType <- map["courseType"]
    }
    
}


class HomeNavigationList: NSObject, NetworkResultProtocol, Mappable {
    
    var message: String?
    var code: Int = 0
    var data: [HomeNavigationModel] = []
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        data <- map["data"]
    }
}

class HomeNavigationModel: NSObject, Mappable {
    
    var navigationName: String = ""
    var seriesName: String = ""
    var seriesID: Int = 0
    var navigationID: Int = 0
    var childrenList: [SubSeriesModel] = []
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        navigationName <- map["navigationName"]
        seriesID <- map["seriesID"]
        seriesName <- map["seriesName"]
        navigationID <- map["navigationID"]
        childrenList <- map["childrenList"]
    }
    
}


class PageModel: NSObject, Mappable {

    var thumbnailUrl: String = ""
    var mobileContent: String = ""
    var pageName: String = ""
    var webRaw: String = ""
    var isVisible: String = ""
    var webContent: String = ""
    var mobileRaw: String = ""
    var pageID: Int = 0
    var informationID: Int = 0
    var type: Int = 0
    var createTime: String = ""
    var updateTime: String = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        webRaw <- map["webRaw"]
        isVisible <- map["isVisible"]
        webContent <- map["webContent"]
        mobileRaw <- map["mobileRaw"]
        mobileContent <- map["mobileContent"]
        thumbnailUrl <- map["thumbnailUrl"]
        pageName <- map["pageName"]
        pageID <- map["pageID"]
        informationID <- map["informationID"]
        type <- map["type"]
        createTime <- map["createTime"]
        updateTime <- map["updateTime"]
    }
    
}

class RecommonModel: NSObject, Mappable {
    var pageName: String = ""
    var productType: Int = 0
    var productID: Int = 0
    var productName: String = ""
    var buyCount: Int = 0
    var thumbnailUrl: String = ""
    var likeCount: Int = 0
    var viewPageID: Int = 0
    var previewImgUrl: String = ""
    var recommendID: Int = 0
    var sequence: Int = 0
    var basicPrice: Int = 0
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        pageName <- map["pageName"]
        productType <- map["productType"]
        productID <- map["productID"]
        productName <- map["productName"]
        buyCount <- map["buyCount"]
        likeCount <- map["likeCount"]
        thumbnailUrl <- map["thumbnailUrl"]
        
        viewPageID <- map["viewPageID"]
        recommendID <- map["recommendID"]
        previewImgUrl <- map["previewImgUrl"]
        basicPrice <- map["basicPrice"]
    }
}

class PostDataModel: NSObject, Mappable {
    var regionFreightList: [PostProvinceModel]?
    var freeShippingPrice: CGFloat = 0.0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        regionFreightList <- map["regionFreightList"]
        freeShippingPrice <- map["freeShippingPrice"]
    }
}

class PostProvinceModel: NSObject, Mappable {
    var regionName: String = ""
    var freightPrice: CGFloat = 0.0
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        regionName <- map["regionName"]
        freightPrice <- map["freightPrice"]
    }
}

class WelcomeInfoModel: NSObject, Mappable {
    var path: String = ""
    var advertisingName: String = ""
    var imageUrl: String = ""
    var type: Int = 0
    var productID: Int = 0
    var productType: Int = 0
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        path <- map["path"]
        advertisingName <- map["advertisingName"]
        imageUrl <- map["imageUrl"]
        type <- map["type"]
        productID <- map["productID"]
        productType <- map["productType"]
    }
}
