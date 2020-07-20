//
//  UserHelper.swift
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

class UserHelper: NSObject {
    static let shared = UserHelper()
    
    fileprivate var endpointClosure = { (target: UserNetworkAPI) -> Endpoint in
        return MoyaProvider.defaultEndpointMapping(for: target)
    }
    private lazy var provider = MoyaProvider<UserNetworkAPI>(endpointClosure: self.endpointClosure, plugins: plugins())
    
    let disposeBag = DisposeBag()
    
    override init() {
        super.init()
    }
    
    //MARK: 登录注册
    func login(name: String, password: String) -> Observable<BaseInfoModel<LoginModel>> {
        return provider.rx.request(UserNetworkAPI.login(name: name, password: password))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: BaseInfoModel<LoginModel>.self)
    }
    //MARK: 判断是否已经绑定手机号
    func thirdCheckCode(phone: String, code: String, type: Int, credential: String) -> Observable<BaseModel> {
        return provider.rx.request(UserNetworkAPI.thirdCheckCode(phone: phone, code: code, type: type, credential: credential))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: BaseModel.self)
       }
    //MARK: 第三方登录
    func thirdLogin(unionid: String, type: Int) -> Observable<LoginInfoModel>{
        return provider.rx.request(UserNetworkAPI.thirdLogin(unionid: unionid, type: type))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: LoginInfoModel.self)
    }
    
    func thirdBind(type: Int, credential: String) -> Observable<BaseModel>{
        return provider.rx.request(UserNetworkAPI.thirdBind(type: type, credential: credential)).filterSuccessfulStatusCodes().mapJSON().asObservable().mapObject(type: BaseModel.self)
    }
    
    func thirdUnbind(type: Int) -> Observable<BaseModel>{
        return provider.rx.request(UserNetworkAPI.thirdUnbind(type: type)).filterSuccessfulStatusCodes().mapJSON().asObservable().mapObject(type: BaseModel.self)
    }
    
    func thirdOldAccount(type: Int, credential: String, loginName: String, password: String, phone: String) -> Observable<BaseInfoModel<UserInfo>>{
        return provider.rx.request(UserNetworkAPI.thirdOldAccount(type: type, credential: credential, loginName: loginName, password: password, phone: phone)).filterSuccessfulStatusCodes().mapJSON().asObservable().mapObject(type: BaseInfoModel<UserInfo>.self)
    }
    
    func register(phone: String, password: String, code: String) -> Observable<BaseInfoModel<UserInfo>> {
        return provider.rx.request(UserNetworkAPI.register(phone: phone, password: password, code: code))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: BaseInfoModel<UserInfo>.self)
    }
    
    func thirdRegister(phone: String, password: String, code: String, nickName: String, headUrl: String, type: Int, credential: String) -> Observable<BaseInfoModel<UserInfo>> {
        return provider.rx.request(UserNetworkAPI.thirdRegister(phone: phone, password: password, code: code, nickName: nickName, headUrl: headUrl, type: type, credential: credential))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: BaseInfoModel<UserInfo>.self)
    }
    
    func resetPassword(phone: String, password: String, code: String) -> Observable<BaseInfoModel<LoginModel>> {
        return provider.rx.request(UserNetworkAPI.resetPassword(phone: phone, password: password, code: code))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: BaseInfoModel<LoginModel>.self)
    }
    
    func getCode(phone: String) -> Observable<BaseModel> {
        return provider.rx.request(UserNetworkAPI.getCode(phone: phone))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: BaseModel.self)
    }
    
    func verifyCode(phone: String, code: String) -> Observable<BaseModel> {
        return provider.rx.request(UserNetworkAPI.verifyCode(phone: phone, code: code))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: BaseModel.self)
    }
    
    func getCouponList(pageNo: Int, pageSize: Int, status: Int) -> Observable<BaseInfoModel<PagerListModel<GoodsCouponModel>>> {
        return provider.rx.request(UserNetworkAPI.couponList(pageNo: pageNo, pageSize: pageSize, status: status))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseInfoModel<PagerListModel<GoodsCouponModel>>.self)
    }
    
    func getNewCouponList(productID: Int, productType: Int) -> Observable<BaseListModel<NewCouponList>> {
           return provider.rx.request(UserNetworkAPI.productCouponNewList(productID: productID, productType: productType))
               .filterSuccessfulStatusCodes()
               .mapJSON()
               .asObservable().mapObject(type: BaseListModel<NewCouponList>.self)
       }
    
    func getProvinceList() -> Observable<BaseListModel<RegionModel>> {
        return provider.rx.request(UserNetworkAPI.provinceList())
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseListModel<RegionModel>.self)
    }
    
    func getCityList(regionID: String) -> Observable<BaseListModel<RegionModel>> {
        return provider.rx.request(UserNetworkAPI.city(regionID: regionID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseListModel<RegionModel>.self)
    }
    
    func getAddressList() -> Observable<BaseListModel<AddressModel>> {
        return provider.rx.request(UserNetworkAPI.addressList())
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseListModel<AddressModel>.self)
    }
    
    func getMonthProfitList(pageNo: Int, pageSize: Int) -> Observable<BaseListModel<MonthProfitModel>> {
        return provider.rx.request(UserNetworkAPI.profitHistory(pageNo: pageNo, pageSize: pageSize))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseListModel<MonthProfitModel>.self)
    }
    
    
    func saveAddress(model: AddressModel) -> Observable<BaseModel> {
        return provider.rx.request(UserNetworkAPI.addAddress(model: model))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: BaseModel.self)
    }
    
    func saveInvoice(invoiceType: Int, invoiceRise: Int, companyName: String, taxpayerNo: String, contentType: String, email: String) -> Observable<BaseInfoModel<InvoiceIDModel>> {
        return provider.rx.request(UserNetworkAPI.saveInvoice(invoiceType: invoiceType, invoiceRise: invoiceRise, companyName: companyName, taxpayerNo: taxpayerNo, contentType: contentType, email: email))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: BaseInfoModel<InvoiceIDModel>.self)
    }
    
    func updateInvoice(invoiceID: String, invoiceType: Int, invoiceRise: Int, companyName: String, taxpayerNo: String, contentType: String) -> Observable<BaseInfoModel<InvoiceIDModel>> {
        return provider.rx.request(UserNetworkAPI.updateInvoice(invoiceID: invoiceID, invoiceType: invoiceType, invoiceRise: invoiceRise, companyName: companyName, taxpayerNo: taxpayerNo, contentType: contentType))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: BaseInfoModel<InvoiceIDModel>.self)
    }
    
    func getInvoiceList() -> Observable<BaseListModel<InvoiceInfoModel>> {
        return provider.rx.request(UserNetworkAPI.invoiceList)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseListModel<InvoiceInfoModel>.self)
    }
    
    func getLogisticsData(status: Int, productType: Int, goodsStatus: Int, carrierID: Int, courierNumber: String) -> Observable<BaseInfoModel<LogisticsModel>>{
        return provider.rx.request(UserNetworkAPI.getLogisticsData(status: status, productType: productType, goodsStatus: goodsStatus, carrierID: carrierID, courierNumber: courierNumber))
        .filterSuccessfulStatusCodes()
        .mapJSON()
        .asObservable().mapObject(type: BaseInfoModel<LogisticsModel>.self)
    }
    
    func deleteInovice(invoiceID: String) -> Observable<BaseModel> {
        return provider.rx.request(UserNetworkAPI.deleteInvoice(invoiceID: invoiceID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: BaseModel.self)
    }
    
    //领取优惠券
    func getCoupon(promotionID: String, ruleID: String) -> Observable<BaseModel> {
        return provider.rx.request(UserNetworkAPI.getCoupon(promotionID: promotionID, ruleID: ruleID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: BaseModel.self)
    }
    
    func updateAddress(model: AddressModel) -> Observable<BaseModel> {
        return provider.rx.request(UserNetworkAPI.updateAddress(model: model))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: BaseModel.self)
    }
    
    func deleteAddress(id: Int) -> Observable<BaseModel> {
        return provider.rx.request(UserNetworkAPI.deleteAddress(id: id))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: BaseModel.self)
    }
    
    //MARK: 我的学习
    func getStudyList(type: String, isExpire: String) -> Observable<BaseListModel<StudyModel>> {
        return provider.rx.request(UserNetworkAPI.studyList(type: type, isExpire: isExpire))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseListModel<StudyModel>.self)
    }
    
    func getClassList(type: String, isExpire: String) -> Observable<BaseListModel<ClassModel>> {
        return provider.rx.request(UserNetworkAPI.classList(type: type, isExpire: isExpire))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseListModel<ClassModel>.self)
    }
    
    func getLiveList(type: String, isExpire: String) -> Observable<BaseListModel<ClassModel>> {
        return provider.rx.request(UserNetworkAPI.liveList(type: type, isExpire: isExpire))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseListModel<ClassModel>.self)
    }
    
    func getLivePlayBackFunc(liveCourseID: Int) -> Observable<PlayBackModel> {
        return provider.rx.request(UserNetworkAPI.getLivePlayBackFunc(liveCourseID: liveCourseID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: PlayBackModel.self)
    }
    
    //更新学习进度
    func updateCourseProgress(userStudyID: String, courseID: String, startTime: String, endTime: String) -> Observable<BaseModel> {
        return provider.rx.request(UserNetworkAPI.updateCourseProgress(userStudyID: userStudyID, courseID: courseID, startTime: startTime, endTime: endTime))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseModel.self)
    }
    
    //获取课件列表
    func getCourseWareList(courseID: String) -> Observable<BaseListModel<CourseWareModel>> {
        return provider.rx.request(UserNetworkAPI.courseWareList(courseID: courseID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseListModel<CourseWareModel>.self)
    }
    
    //班级课程列表
    func getClassCourseList(userStudyID: String) -> Observable<BaseListModel<ClassCourseModel>> {
        return provider.rx.request(UserNetworkAPI.classCourseList(userStudyID: userStudyID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseListModel<ClassCourseModel>.self)
    }
    
    //MARK: 我的购物车
    func getCartList() -> Observable<BaseListModel<CartListModel>> {
        return provider.rx.request(UserNetworkAPI.cartList)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseListModel<CartListModel>.self)
    }
    
    func deleteGoodsInCart(cardID: String, count: String) -> Observable<BaseModel> {
        return provider.rx.request(UserNetworkAPI.deleteGoodsInCart(cardID: cardID, count: count))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseModel.self)
    }
    
    func deleteGoods(ids: [String]) -> Observable<BaseModel> {
        return provider.rx.request(UserNetworkAPI.deleteGoods(ids: ids))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseModel.self)
    }
    
    func updateGoodsCountInCart(cardID: Int, count: Int) -> Observable<BaseModel> {
        return provider.rx.request(UserNetworkAPI.updateGoods(number: count, cardID: cardID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseModel.self)
    }
    
    func addGoodsToCart(productID: String, type: String, count: String) -> Observable<BaseModel> {
        return provider.rx.request(UserNetworkAPI.addGoodsToCart(productID: productID, type: type, count: count))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseModel.self)
    }
    //使用开课卡开课
    func useCourseCard(cardNo: String, code: String) -> Observable<BaseModel> {
        return provider.rx.request(UserNetworkAPI.useCourseCard(cardNo: cardNo, code: code))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseModel.self)
    }
    
    //远程课程使用开课卡开课
    func remoteClassUseCourseCard(cardNo: String, code: String, productID: String) -> Observable<BaseModel> {
        return provider.rx.request(UserNetworkAPI.remoteClassUseCourseCard(cardNo: cardNo, code: code, productID: productID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseModel.self)
    }
    
    //获取开课卡
    func getCourseCard(phone: String, password: String) -> Observable<BaseListModel<GetCourseCardModel>> {
        return provider.rx.request(UserNetworkAPI.getCourseCard(phone: phone, password: password))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseListModel<GetCourseCardModel>.self)
    }
    
    func getCourseCardList(pageNo: Int, pageSize: Int) -> Observable<BaseInfoModel<PagerListModel<CourseCardModel>>> {
        return provider.rx.request(UserNetworkAPI.courseCardList(pageNo: pageNo, pageSize: pageSize))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseInfoModel<PagerListModel<CourseCardModel>>.self)
    }
    
    func activeLearnCard(learnCardNo: String, password: String) -> Observable<BaseModel> {
        return provider.rx.request(UserNetworkAPI.activeLearnCard(learnCardNo: learnCardNo, password: password))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseModel.self)
    }
    
    func learnCardList(pageNo: Int, pageSize: Int) -> Observable<BaseInfoModel<StudyCardListModel>> {
        return provider.rx.request(UserNetworkAPI.learnCardList(pageNo: "\(pageNo)", pageSize: "\(pageSize)"))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseInfoModel<StudyCardListModel>.self)
    }
    
    func learnCardAmount() -> Observable<BaseInfoModel<LearnCardAmountModel>> {
        return provider.rx.request(UserNetworkAPI.learnCardAmount)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseInfoModel<LearnCardAmountModel>.self)
    }
    
    func getInviteCode(activityID: String, productID: String) -> Observable<BaseInfoModel<InviteCodeModel>> {
        return provider.rx.request(UserNetworkAPI.getInviteCode(activityID: activityID, productID: productID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseInfoModel<InviteCodeModel>.self)
    }
    
    //MARK: 学籍
    func saveSchoolRoll(eclassID: String, propertyJson: String) -> Observable<BaseModel> {
        return provider.rx.request(UserNetworkAPI.saveSchoolRoll(eclassID: eclassID, propertyJson: propertyJson))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseModel.self)
    }
    
    func getClassSchoolRoll(eclassID: String) -> Observable<BaseListModel<SchoolRollKeyValueModel>> {
        return provider.rx.request(UserNetworkAPI.getClassSchoolRoll(eclassID: eclassID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseListModel<SchoolRollKeyValueModel>.self)
    }

    func getLiveClassSchoolRoll(liveCourseID: String) -> Observable<BaseListModel<SchoolRollKeyValueModel>> {
        return provider.rx.request(UserNetworkAPI.getLiveClassSchoolRoll(liveCourseID: liveCourseID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseListModel<SchoolRollKeyValueModel>.self)
    }
    
    func getClassSchoolRollInfo(eclassID: String) -> Observable<BaseListModel<SchoolRollKeyValueModel>> {
        return provider.rx.request(UserNetworkAPI.getClassShoolRollInfo(eclassID: eclassID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseListModel<SchoolRollKeyValueModel>.self)
    }
    
    func getLiveClassSchoolRollInfo(liveCourseID: String) -> Observable<BaseListModel<SchoolRollKeyValueModel>> {
        return provider.rx.request(UserNetworkAPI.getLiveClassSchoolRollInfo(liveCourseID: liveCourseID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseListModel<SchoolRollKeyValueModel>.self)
    }
        
    //MARK: 订单
    func getOrderList(status: String, pageNo: Int, pageSize: Int) -> Observable<BaseOrderListModel> {
        return provider.rx.request(UserNetworkAPI.orderList(status: status, pageNo: pageNo, pageSize: pageSize))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseOrderListModel.self)
    }
    
    func getOrderDetail(orderID: Int) -> Observable<BaseInfoModel<OrderDetailModel>> {
        return provider.rx.request(UserNetworkAPI.orderDetail(orderId: orderID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseInfoModel<OrderDetailModel>.self)
    }
    
    func getOrderDataDetail(orderID: Int) -> Observable<BaseInfoModel<OrderDetailModel>> {
        return provider.rx.request(UserNetworkAPI.getOrderDetail(orderId: orderID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseInfoModel<OrderDetailModel>.self)
    }
    
    func deleteOrder(orderID: Int) -> Observable<BaseModel> {
        return provider.rx.request(UserNetworkAPI.deleteOrder(orderId: orderID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseModel.self)
    }
    
    func updateOrderStatus(orderID: Int, status: Int) -> Observable<BaseModel> {
        return provider.rx.request(UserNetworkAPI.updateOrderStatus(orderID: orderID, status: status))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseModel.self)
    }
    
    func saveOrder(totalPrice: CGFloat, discountPrice: String,payMode: String, addressID: Int, distributionMode: Int, couponIDs: String, ruleIDs: String, invoiceID: String?, productList: [SubmitOrderGoodsModel]) -> Observable<BaseInfoModel<SumitOrderBaseInfo>> {
        return provider.rx.request(UserNetworkAPI.saveOrder(totalPrice: totalPrice, discountPrice: discountPrice, payMode: payMode, addressID: addressID, distributionMode: distributionMode, couponIDs: couponIDs, ruleIDs: ruleIDs, invoiceID: invoiceID, productList: productList))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseInfoModel<SumitOrderBaseInfo>.self)
    }
    
    func saveGroupBuyInfo(groupBuyID: Int, productID: Int, orderID: Int) -> Observable<BaseModel>{
        return provider.rx.request(UserNetworkAPI.saveGroupSignal(groupBuyID: groupBuyID, productID: productID, orderID: orderID)).filterSuccessfulStatusCodes().mapJSON().asObservable().mapObject(type: BaseModel.self)
    }
    
    func addReferrerName(orderID : Int, referrerName : String) -> Observable<BaseModel>{
        return provider.rx.request(UserNetworkAPI.addReferrer(orderID: orderID, recommenderName: referrerName))
        .filterSuccessfulStatusCodes()
        .mapJSON()
        .asObservable().mapObject(type: BaseModel.self)
    }
    //判断订单是否提交过
    func selectOrderStatus(productID: Int) -> Observable<BaseModel>{
        return provider.rx.request(UserNetworkAPI.selectOrderStatus(productID: productID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type:BaseModel.self)
    }
    
    //支付
    func getPayInfo(orderID: String, type: String = "1") -> Observable<BaseInfoModel<PaySignModel>> {
        return provider.rx.request(UserNetworkAPI.payDetail(orderId: orderID, type: type))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseInfoModel<PaySignModel>.self)
    }
    
    func getPayResult(orderID: String) -> Observable<BaseInfoModel<PaySignModel>> {
        return provider.rx.request(UserNetworkAPI.payResult(orderID: orderID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseInfoModel<PaySignModel>.self)
    }
    
    func getPayOrderStatus(productIDs: String) -> Observable<BaseDataModel> {
        return provider.rx.request(UserNetworkAPI.getPayOrderStatus(productIDs: productIDs))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseDataModel.self)
    }
    
    func touristRegister() -> Observable<BaseInfoModel<UserInfo>>{
        return provider.rx.request(UserNetworkAPI.touristRegister)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: BaseInfoModel<UserInfo>.self)
    }
    
    func studyCardPay(orderID: Int) -> Observable<BaseDataModel>{
        return provider.rx.request(UserNetworkAPI.studyCardPay(orderID: orderID))
           .filterSuccessfulStatusCodes()
           .mapJSON()
           .asObservable()
           .mapObject(type: BaseDataModel.self)
    }
    
    func saveNewOrderWithVip(isGroup: Int, addressID: String?, discountPrice: String, distributionMode: Int, rulesIDs: String?, productType: Int, totalPrice: String, invitationCode: String?, payChannel: Int, productList: [SubmitOrderGoodsNewWithVIPModel], invoiceID: Int, trafficPay: String, couponIDs: String, payMode: String, recommenderName: String) -> Observable<BaseInfoModel<SumitOrderBaseInfo>> {
        return provider.rx.request(UserNetworkAPI.saveNewWithVipOrder(isGroup: isGroup, addressID: addressID, discountPrice: discountPrice, distributionMode: distributionMode, ruleIDs: rulesIDs, productType: productType, totalPrice: totalPrice, invitationCode: invitationCode, payChannel: payChannel, productList: productList, invoiceID: "\(invoiceID)", trafficPay: trafficPay, couponIDs: couponIDs, payMode: payMode, recommenderName: recommenderName))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseInfoModel<SumitOrderBaseInfo>.self)
    }
    
    func saveNewOrderWithoutVip(isGroup: Int, addressID: String?, discountPrice: String, distributionMode: Int, rulesIDs: String?, productType: Int, totalPrice: String, invitationCode: String?, payChannel: Int, productList: [SubmitOrderGoodsNewWithoutVIPModel], invoiceID: Int, trafficPay: String, couponIDs: String, payMode: String, recommenderName: String) -> Observable<BaseInfoModel<SumitOrderBaseInfo>> {
        return provider.rx.request(UserNetworkAPI.saveNewWithoutVipOrder(isGroup: isGroup, addressID: addressID, discountPrice: discountPrice, distributionMode: distributionMode, ruleIDs: rulesIDs, productType: productType, totalPrice: totalPrice, invitationCode: invitationCode, payChannel: payChannel, productList: productList, invoiceID: "\(invoiceID)", trafficPay: trafficPay, couponIDs: couponIDs, payMode: payMode, recommenderName: recommenderName))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseInfoModel<SumitOrderBaseInfo>.self)
    }
    //确认订单页打折券
    func getDiscountCoupon(productID: String, userCouponIDs: String) -> Observable<BaseListModel<DiscountCouponModel>>{
        return provider.rx.request(UserNetworkAPI.getDiscountCoupons(productID: productID, userCouponIDs: userCouponIDs)).filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: BaseListModel<DiscountCouponModel>.self)
    }
    //确认订单页，优惠券列表
    func getConfirmOrderCoupons(productIDs: String, vipProductIDs: String) -> Observable<BaseListModel<NewCouponList>>{
        return provider.rx.request(UserNetworkAPI.getConfirmOrderCoupons(productIDs: productIDs, vipProductIDs: vipProductIDs)).filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: BaseListModel<NewCouponList>.self)
       }
}

extension UserHelper {
    func getUserInfo() -> Observable<BaseInfoModel<UserInfo>> {
        return provider.rx.request(UserNetworkAPI.userInfo)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseInfoModel<UserInfo>.self)
    }
    
    func updateUserInfo(dic: [String: String]) -> Observable<BaseModel> {
        return provider.rx.request(UserNetworkAPI.updateUserInfo(dic: dic))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type:BaseModel.self)
    }
    
    func updateUserContactsInfo(dic: [String: String]) -> Observable<BaseModel> {
        return provider.rx.request(UserNetworkAPI.updateUserContacts(dic: dic))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type:BaseModel.self)
    }
    
    //我的考试
    func getMyExamList() -> Observable<BaseListModel<ExamBaseInfoModel>> {
        return provider.rx.request(UserNetworkAPI.myExamList)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseListModel<ExamBaseInfoModel>.self)
    }
    
    //课程考试
    func getCourseExamList() -> Observable<BaseListModel<ExamBaseInfoModel>>{
        return provider.rx.request(UserNetworkAPI.courseExam)
        .filterSuccessfulStatusCodes()
        .mapJSON()
        .asObservable().mapObject(type: BaseListModel<ExamBaseInfoModel>.self)
    }
    //班级随堂测验
    func withClassTestData(objectID: String) -> Observable<BaseListModel<ExamBaseInfoModel>>{
        return provider.rx.request(UserNetworkAPI.withClassTestData(eclassID: objectID))
        .filterSuccessfulStatusCodes()
        .mapJSON()
            .asObservable().mapObject(type: BaseListModel<ExamBaseInfoModel>.self)
    }
    
    func getExamQuestion(pagerID: String, examID: String) -> Observable<BaseInfoModel<QuestionListInfoModel>> {
        return provider.rx.request(UserNetworkAPI.getExamQuestion(pagerID: pagerID, examID: examID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseInfoModel<QuestionListInfoModel>.self)
    }
    
    
    func getExamResult(examID: String, paperID: String, paperNo: String, userPaperID: String) -> Observable<BaseInfoModel<QuestionListInfoModel>> {
        return provider.rx.request(UserNetworkAPI.examResult(examID: examID, paperID: paperID, paperNo: paperNo, userPaperID: userPaperID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseInfoModel<QuestionListInfoModel>.self)
    }
    
    func getExamRecord(examID: String) -> Observable<BaseListModel<ExamResultInfoModel>> {
        return provider.rx.request(UserNetworkAPI.examRecords(examID: examID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseListModel<ExamResultInfoModel>.self)
    }
    
    func submitExamAnswer(answers: [[String:String]]) -> Observable<BaseModel> {
        return provider.rx.request(UserNetworkAPI.submitExamAnswer(answers: answers))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseModel.self)
    }
    
    func getIOSOrderStatus(poNumber: String, receipt_data: [String: Any]) -> Observable<BaseModel>{
        return provider.rx.request(UserNetworkAPI.rechargeIAPOrder(poNumber: poNumber, receiptData: receipt_data))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseModel.self)
    }
    
    func getIOSOrderStatusString(poNumber: String, receipt_data: String) -> Observable<BaseModel>{
        return provider.rx.request(UserNetworkAPI.rechargeIAPOrderString(poNumber: poNumber, receiptData: receipt_data))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: BaseModel.self)
    }
    
    func getAPPVersionInfo() -> Observable<VersionModel>{
        return provider.rx.request(UserNetworkAPI.getAPPVersionInfo())
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: VersionModel.self)
    }
    
    func makeCourseDelay(userStudyID: Int) -> Observable<BaseModel>{
        return provider.rx.request(UserNetworkAPI.applyDelayCourse(userStudyID: userStudyID))
        .filterSuccessfulStatusCodes()
        .mapJSON()
        .asObservable().mapObject(type: BaseModel.self)
    }
    
    func liveClassPlayBackList(liveCourseID: Int) -> Observable<BaseListModel<CourseWareModel>> {
           return provider.rx.request(UserNetworkAPI.liveClassPlayBackList(liveCourseID: liveCourseID))
           .filterSuccessfulStatusCodes()
           .mapJSON()
           .asObservable().mapObject(type: BaseListModel<CourseWareModel>.self)
    }
    
    func bindPhone(phone: String) -> Observable<BaseModel> {
           return provider.rx.request(UserNetworkAPI.bindPhone(phone: phone))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: BaseModel.self)
    }
    
    func liveClassJoinRight(code: String, phoneNum: String, productID: Int) -> Observable<BaseModel> {
          return provider.rx.request(UserNetworkAPI.liveClassJoinRight(code: code, phoneNum: phoneNum, productID: productID))
           .filterSuccessfulStatusCodes()
           .mapJSON()
           .asObservable()
           .mapObject(type: BaseModel.self)
       }
    
    func logoutAccount() -> Observable<BaseModel> {
        return provider.rx.request(UserNetworkAPI.logoutAccount())
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: BaseModel.self)
    }
    
    func saveUserCoupon(promotionCouponDetialID: Int) -> Observable<BaseModel>{
        return provider.rx.request(UserNetworkAPI.saveUserCoupon(promotionCouponDetialID: promotionCouponDetialID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: BaseModel.self)
    }
    
    func searchUserCoupon(status: Int, pageNo: Int, pageSize: Int) -> Observable<MyCouponListModel>{
        return provider.rx.request(UserNetworkAPI.searchUserCoupons(status: status, pageNo: pageNo, pageSize: pageSize))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: MyCouponListModel.self)
    }
    
    func allDiscountProduct(promotionID: Int, productScope: Int, pageNo: Int, pageSize: Int) -> Observable<DiscountProductModel>{
           return provider.rx.request(UserNetworkAPI.allDiscountProduct(promotionID: promotionID, productScope: productScope, pageNo: pageNo, pageSize: pageSize))
           .filterSuccessfulStatusCodes()
           .mapJSON()
           .asObservable()
           .mapObject(type: DiscountProductModel.self)
       }
    
    func couponInstruction() -> Observable<CouponInstructionModel>{
        return provider.rx.request(UserNetworkAPI.couponInstruction)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: CouponInstructionModel.self)
    }
}

class BaseOrderListModel: NSObject, Mappable {
    var message: String?
    var code: Int = 0
    var data: BaseOrderDataModel?
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        data <- map["data"]
    }
}

class BaseOrderDataModel: NSObject, Mappable {
    var pageNo: Int = 0
    var rows: [OrderModel] = [OrderModel]()
    var totalRows: Int = 0
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        pageNo <- map["pageNo"]
        rows <- map["rows"]
        totalRows <- map["totalRows"]
    }
}

class BaseOrderRowsModel: NSObject, Mappable {
    var payChannel: Int = 0
    var orderID: Int = 0
    var isPublish: Int = 0
    var objectType: Int = 0
    var poNumber: String = ""
    var detailList: [BaseOrderRowsDetailListModel] = [BaseOrderRowsDetailListModel]()
    var isPay: Int = 0
    var createTime: String = ""
    var paymentAmount: CGFloat = 0.0
    var price: CGFloat = 0.0
    var status: Int = 0
    required init?(map: Map) {

    }
    func mapping(map: Map) {
        payChannel <- map["payChannel"]
        orderID <- map["orderID"]
        isPublish <- map["isPublish"]
        objectType <- map["objectType"]
        poNumber <- map["poNumber"]
        isPay <- map["isPay"]
        createTime <- map["createTime"]
        paymentAmount <- map["paymentAmount"]
        price <- map["price"]
        status <- map["status"]
        detailList <- map["detailList"]
    }
}

class BaseOrderRowsDetailListModel: NSObject, Mappable {
    var previewImgUrl: String = ""
    var productType: Int = 0
    var thumbnailUrl: String = ""
    var price: CGFloat = 0.0
    var count: Int = 0
    var productName: String = ""
    var productID: Int = 0
    var refundStatus: Int = 0
    required init?(map: Map) {

    }
    func mapping(map: Map) {
        previewImgUrl <- map["previewImgUrl"]
        productType <- map["productType"]
        thumbnailUrl <- map["thumbnailUrl"]
        price <- map["price"]
        count <- map["count"]
        productName <- map["productName"]
        productID <- map["productID"]
        refundStatus <- map["refundStatus"]
    }
}



class BaseDataModel: NSObject, Mappable{
    var data: String = ""
    var message: String = ""
    var code: Int = 0
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        data <- map["data"]
        message <- map["message"]
        code <- map["code"]
    }
}

class RegionModel: NSObject, Mappable {
    
    var regionName: String = ""
    var regionID: Int = 0
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        regionName <- map["regionName"]
        regionID <- map["regionID"]
    }
    
}

/*
 "phone": "123",
 "address": "123",
 "cityName": "北京市",
 "cityID": 110100,
 "postCode": "123",
 "userName": "123",
 "streetName": "东华门街道",
 "provinceName": "北京",
 "label": "123",
 "addressID": 1,
 "countyID": 110101
 */

class AddressModel: NSObject, Mappable, AddressInfo {
    var isDefault: Bool = false
    
    var countryName: String = ""
    var provinceID: Int = 0
    var phone: String = ""
    var address: String = ""
    var cityName: String = ""
    var cityID: Int = 0
    var postCode: String = ""
    var userName: String = ""
    var streetName: String = ""
    var streetID: Int = 0
    var provinceName: String = ""
    var label: String = ""
    var addressID: Int = 0
    var countyID: Int = 0
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        countryName <- map["countyName"]
        provinceID <- map["provinceID"]
        
        phone <- map["phone"]
        address <- map["address"]
        cityName <- map["cityName"]
        cityID <- map["cityID"]
        postCode <- map["postCode"]
        userName <- map["userName"]
        streetName <- map["streetName"]
        streetID <- map["streetID"]
        provinceName <- map["provinceName"]
        label <- map["label"]
        addressID <- map["addressID"]
        countyID <- map["countyID"]
    }
    
    
    
}

class PlayBackModel: NSObject, Mappable {
    var code: Int = 0
    var data: [PlayBackDetailModel]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        data <- map["data"]
    }
}

class PlayBackDetailModel: NSObject, Mappable {
    var playbackCourseID: Int = 0
    var liveCourseID: Int = 0
    var playbackCourseName: Int = 0
    var duration: String = ""
    var highVideUrl: String = ""
    var humbnailUrl: String = ""
    var size: String = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        playbackCourseID <- map["playbackCourseID"]
        liveCourseID <- map["liveCourseID"]
        playbackCourseName <- map["playbackCourseName"]
        duration <- map["duration"]
        highVideUrl <- map["highVideUrl"]
        humbnailUrl <- map["humbnailUrl"]
        size <- map["size"]
    }
}

class NewCouponList: NSObject, Mappable{
    var userCouponID: Int = 0//优惠券ID
    var promotionCouponDetialID: Int = 0//优惠券活动详细ID
    var promotionID: Int = 0//促销活动ID
    var receiveStartTime: String = ""//活动开始时间
    var receiveEndTime: String = ""//活动结束时间
    var productScope: Int = 0//产品适用范围(0.全部品类 1.课程 2.书籍 3.班级 5.直播 6.指定产品)
    var couponType: Int = 0//优惠券类型（1.满减券 2.代金券 3.折扣券 4.包邮券）
    var totalPrice: CGFloat = 0.0//总价
    var reductionPrice: CGFloat = 0.0//减免
    var discountRate: CGFloat = 0.0//折扣率
    var crowdScope: Int = 0//人群适用范围(0.全部用户 1.新用户 2.VIP用户 3.指定用户)
    var validDate: Int = 0
    var productID: Int = 0
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        userCouponID <- map["userCouponID"]
        promotionCouponDetialID <- map["promotionCouponDetialID"]
        promotionID <- map["promotionID"]
        receiveStartTime <- map["receiveStartTime"]
        receiveEndTime <- map["receiveEndTime"]
        productScope <- map["productScope"]
        couponType <- map["couponType"]
        totalPrice <- map["totalPrice"]
        reductionPrice <- map["reductionPrice"]
        discountRate <- map["discountRate"]
        crowdScope <- map["crowdScope"]
        validDate <- map["validDate"]
        productID <- map["productID"]
    }
}

class MyCouponListModel: NSObject, Mappable {
    var message: String = ""
    var code: Int = 0
    var data: MyCouponListRowModel?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        message <- map["message"]
        code <- map["code"]
        data <- map["data"]
    }
}

class MyCouponListRowModel: NSObject, Mappable {
    var totalRows: Int = 0
    var rows: [NewCouponList]?
    var pageNo: Int = 0
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        totalRows <- map["totalRows"]
        rows <- map["rows"]
        pageNo <- map["pageNo"]
    }
}

class DiscountProductModel: NSObject, Mappable {
    var message: String = ""
    var code: Int = 0
    var data: DiscountProductRowModel?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        message <- map["message"]
        code <- map["code"]
        data <- map["data"]
    }
}

class DiscountProductRowModel: NSObject, Mappable{
    var totalRows: Int = 0
    var pageNo: Int = 0
    var rows: [DiscountProductDetailModel]?
    
    required init?(map: Map) {
    }

    func mapping(map: Map) {
        totalRows <- map["totalRows"]
        pageNo <- map["pageNo"]
        rows <- map["rows"]
    }
}

class DiscountProductDetailModel: NSObject, Mappable{
    var productID: Int = 0
    var productName: String = ""
    var basicPrice: CGFloat = 0
    var previewImgUrl: String = ""
    var thumbnailUrl: String = ""
    var productType: Int = 0
    var courseType: Int = 0
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        productID <- map["productID"]
        productName <- map["productName"]
        basicPrice <- map["basicPrice"]
        previewImgUrl <- map["previewImgUrl"]
        thumbnailUrl <- map["thumbnailUrl"]
        productType <- map["productType"]
        courseType <- map["courseType"]
    }
}

class CouponInstructionModel: NSObject, Mappable{
    var message: String = ""
    var code: Int = 0
    var data: CouponInstructionStringModel?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        message <- map["message"]
        code <- map["code"]
        data <- map["data"]
    }
}

class CouponInstructionStringModel: NSObject, Mappable{
    var instructions: String = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        instructions <- map["instructions"]
    }
}

class DiscountCouponModel: NSObject, Mappable{
    var discountRate: CGFloat = 0.0
    var userCouponID: Int = 0
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        userCouponID <- map["userCouponID"]
        discountRate <- map["discountRate"]
    }
}


