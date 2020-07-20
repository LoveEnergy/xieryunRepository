//
//  UserNetworkAPI.swift
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

enum UserNetworkAPI {
    //登录
    case thirdLogin(unionid: String, type: Int)
    case thirdBind(type: Int, credential: String)
    case thirdUnbind(type: Int)
    case thirdOldAccount(type: Int, credential: String, loginName: String, password: String, phone: String)
    case login(name: String, password: String)
    case thirdCheckCode(phone: String, code: String, type: Int, credential: String)
    case register(phone: String, password: String, code: String)
    case thirdRegister(phone: String, password: String, code: String, nickName: String, headUrl: String, type: Int, credential: String)//第三方类型（1、QQ2、微信）
    case getCode(phone: String)
    case verifyCode(phone: String, code: String)
    case resetPassword(phone: String, password: String, code: String)
    
    //MARK: 用户信息
    case userInfo
    case updateUserInfo(dic:[String: String])
    case updateUserContacts(dic: [String: String])
    case provinceList()
    case city(regionID: String)
    case addressList()
    case addAddress(model: AddressModel)
    case updateAddress(model: AddressModel)
    case deleteAddress(id: Int)
    case getCoupon(promotionID: String, ruleID: String)
    case couponList(pageNo: Int, pageSize: Int, status: Int)
    case productCouponNewList(productID: Int, productType: Int)
    //获取邀请码
    case getInviteCode(activityID: String, productID: String)
    
    case navigation
    
    //MARK: 学习
    case studyList(type: String, isExpire: String) //     类型（1、班级2、课程3、直播）
    case classList(type: String, isExpire: String) //  与studylist 一样，参数不一样   类型（1、班级2、课程）; isExpire  0 学习中 1 已过期
    case liveList(type: String, isExpire: String)
    case courseWareList(courseID: String)
    case getLivePlayBackFunc(liveCourseID: Int)
    //班级课程列表
    case classCourseList(userStudyID: String)
    case updateCourseProgress(userStudyID: String, courseID: String, startTime: String, endTime: String)
    
    //开课卡
    case useCourseCard(cardNo: String, code: String)
    case remoteClassUseCourseCard(cardNo: String, code: String, productID: String)
    case getCourseCard(phone: String, password: String)
    case courseCardList(pageNo: Int, pageSize: Int)
    //学习卡
    case activeLearnCard(learnCardNo: String, password: String)
    case learnCardList(pageNo: String, pageSize: String)
    //学籍
    case saveSchoolRoll(eclassID: String, propertyJson: String)
    //团购提交接口
    case saveGroupSignal(groupBuyID: Int, productID: Int, orderID: Int)
    //获取用户班级学籍信息
    case getClassSchoolRoll(eclassID: String)
    //获取用户直播课程学籍信息
    case getLiveClassSchoolRoll(liveCourseID: String)
    //获取班级学籍列表接口，学习填写所需信息
    case getClassShoolRollInfo(eclassID: String)
    
    //获取直播课程学籍列表接口
    case getLiveClassSchoolRollInfo(liveCourseID: String)
    //MARK: 购物车
    case cartList
    case addGoodsToCart(productID: String, type: String, count: String)
    case deleteGoodsInCart(cardID: String, count: String)
    case learnCardAmount
    //删除多个商品
    case deleteGoods(ids: [String])
    case updateGoods(number: Int, cardID: Int)
    
    //MARK: 订单
    case orderList(status: String, pageNo: Int, pageSize: Int)
    case orderDetail(orderId: Int)
    case deleteOrder(orderId: Int)
    case updateOrderStatus(orderID: Int, status: Int)
    case saveOrder(totalPrice: CGFloat, discountPrice: String, payMode: String, addressID: Int, distributionMode: Int, couponIDs: String, ruleIDs: String, invoiceID: String?, productList: [SubmitOrderGoodsModel])
    case saveNewWithoutVipOrder(isGroup: Int, addressID: String?, discountPrice: String, distributionMode: Int, ruleIDs: String?, productType: Int, totalPrice: String, invitationCode: String?, payChannel: Int, productList: [SubmitOrderGoodsNewWithoutVIPModel], invoiceID: String, trafficPay: String, couponIDs: String, payMode: String, recommenderName: String)
    case saveNewWithVipOrder(isGroup: Int, addressID: String?, discountPrice: String, distributionMode: Int, ruleIDs: String?, productType: Int, totalPrice: String, invitationCode: String?, payChannel: Int, productList: [SubmitOrderGoodsNewWithVIPModel], invoiceID: String, trafficPay: String, couponIDs: String, payMode: String, recommenderName: String)
    case selectOrderStatus(productID: Int)
//    case
    case addReferrer(orderID : Int, recommenderName : String)
    
    //MARK: 支付
    case payDetail(orderId: String, type: String)
    case payResult(orderID: String)
    
    //MARK: 考试
    case myExamList
    case courseExam//课程考试
    case withClassTestData(eclassID: String)//班级下随堂测验
    case getExamQuestion(pagerID: String, examID: String)
    case submitExamAnswer(answers: [[String: String]])
    case examResult(examID: String, paperID: String, paperNo: String, userPaperID: String)
    case examRecords(examID: String)
    
    //MARK: 发票
    /*
     invoiceType     是     int     发票类型（1、电子发票）
     invoiceRise     是     int     发票抬头（1、个人2公司）
     companyName     否     string     单位名称
     taxpayerNo     否     string     纳税人识别号
     contentType     是     int     发票内容类型 （1、商品明细2、商品类别）
     email     是     string     电子邮箱
     */
    case saveInvoice(invoiceType: Int, invoiceRise: Int, companyName: String, taxpayerNo: String, contentType: String, email: String)
    case invoiceList
    case deleteInvoice(invoiceID: String)
    case updateInvoice(invoiceID: String, invoiceType: Int, invoiceRise: Int, companyName: String, taxpayerNo: String, contentType: String)
    
    case profitHistory(pageNo: Int, pageSize: Int)
    case getLogisticsData(status: Int, productType: Int, goodsStatus: Int, carrierID: Int, courierNumber: String)
    
    case rechargeIAPOrder(poNumber: String, receiptData: [String: Any])
    case rechargeIAPOrderString(poNumber: String, receiptData: String)
    case getAPPVersionInfo()//APP版本信息
    case getPayOrderStatus(productIDs: String)
    case getOrderDetail(orderId: Int)
    case touristRegister
    case applyDelayCourse(userStudyID: Int)
    case liveClassPlayBackList(liveCourseID: Int)
    case bindPhone(phone: String)
    case liveClassJoinRight(code: String, phoneNum: String, productID: Int)
    case logoutAccount()
    case studyCardPay(orderID: Int)
    case saveUserCoupon(promotionCouponDetialID: Int)//保存用户优惠券
    case searchUserCoupons(status: Int, pageNo: Int, pageSize: Int)
    case allDiscountProduct(promotionID: Int, productScope: Int, pageNo: Int, pageSize: Int)
    case couponInstruction
    case getDiscountCoupons(productID: String, userCouponIDs: String)//确认订单页，获取打折券
    case getConfirmOrderCoupons(productIDs: String, vipProductIDs: String)//确认订单页，优惠券列表
}

extension UserNetworkAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: Constant.serverBaseURL)!
    }
    
    var path: String {
        switch self {
        case .provinceList:
            return "/cei/front/get_province_list"
        case .city:
            return "/cei/front/get_next_level_list"
        case .addressList:
            return "/cei/get_user_address_list"
        case .navigation:
            return "/cei/front/get_navigation_list"
        case .login:
            return "/cei/login"
        case .thirdLogin:
            return "/cei/third_login"
        case .thirdBind:
            return "/cei/third_bind"
        case .thirdUnbind:
            return "/cei/third_unbind"
        case .thirdOldAccount:
            return "/cei/bind_old_account"
        case .register:
            return "/cei/register"
        case .thirdRegister:
            return "/cei/third_register"
        case .thirdCheckCode:
            return "/cei/third_check_code"
        case .getCode:
            return "/cei/get_check_code"
        case .verifyCode:
            return "/cei/validity_check_code"
        case .resetPassword:
            return "/cei/reset_password"
            
        case .studyList, .classList, .liveList:
            return "/cei/get_user_study_list"
        case .cartList:
            return "/cei/get_card_list"
        case .addGoodsToCart:
            return "/cei/save_card"
        case .userInfo:
            return "/cei/get_user_info"
        case .updateUserInfo:
            return "/cei/update_user_info"
        case .addAddress:
            return "/cei/add_user_address"
        case .deleteAddress:
            return "/cei/delete_address"
        case .deleteGoodsInCart:
            return "/cei/delete_card_product"
        case .updateGoods:
            return "/cei/update_card_num"
        case .updateUserContacts:
            return "/cei/update_user_contact"
        case .updateAddress:
            return "/cei/update_user_address"
        case .orderList:
            return "/cei/get_new_order_list"
        case .courseWareList:
            return "/cei/get_courseware_list"
        case .classCourseList:
            return "/cei/get_user_eclass_course_list"
        case .orderDetail:
            return "/cei/get_order_detail"
        case .getOrderDetail:
            return "/cei/get_order_detail"
        case .saveOrder:
            return "/cei/save_order"
        case .selectOrderStatus:
            return "/cei/select_order_status"
        case .addReferrer:
            return "cei/add_order_recommenderName"
        case .deleteGoods(let ids):
            return "/cei/delete_card"
        case .getCoupon(let promotionID, let ruleID)://弃用
            return "/cei/save_user_coupon"
        case .couponList:
            return "/cei/get_user_coupon_list"
        case .productCouponNewList:
            return "/cei/front/get_product_coupon_list"
        case .saveUserCoupon(let promotionCouponDetialID):
            return "/cei/save_user_coupon"
        case .myExamList:
            return "/cei/get_user_paper_list"
        case .courseExam:
            return "/cei/get_course_user_paper_list"
        case .withClassTestData:
            return "/cei/get_course_of_eclass_paper"
        case .getExamQuestion:
            return "/cei/get_paper_question"
        case .useCourseCard:
            return "/cei/save_user_course_card"
        case .remoteClassUseCourseCard:
            return "/cei/save_user_course_card"
        case .getCourseCard:
            return "/cei/get_course_card"
        case .submitExamAnswer:
            return "/cei/save_user_paper_answer"
        case .updateCourseProgress:
            return "/cei/update_study_schedule"
        case .examResult:
            return "/cei/get_user_paper_answer"
        case .examRecords:
            return "/cei/get_user_paper_record_list"
        case .activeLearnCard:
            return "/cei/activate_learn_card"
        case .saveSchoolRoll:
            return "/cei/save_user_class_school_roll"
        case .saveGroupSignal:
            return "/cei/save_user_single"
        case .getClassSchoolRoll:
            return "/cei/get_user_class_school_roll"
        case .getLiveClassSchoolRoll:
            return "/cei/get_user_live_course_school_roll"
        case .getClassShoolRollInfo:
            return "/cei/get_class_school_roll"
        case .getLiveClassSchoolRollInfo:
            return "/cei/get_live_course_school_roll"
        case .payDetail(let orderId):
            return "/cei/pay"
        case .deleteOrder(let orderId):
            return "/cei/delete_order"
        case .updateOrderStatus(let orderID, let status):
            return "/cei/update_order_status"
        case .payResult(let orderID):
            return "/cei/get_pay_result"
        case .courseCardList(let pageNo, let pageSize):
            return "/cei/get_user_course_card_list"
        case .learnCardList:
            return "/cei/get_new_user_learn_card_list"
        case .learnCardAmount:
            return "/cei/get_user_learn_card_amount"
        case .saveInvoice:
            return "/cei/save_user_invoice"
        case .getInviteCode:
            return "/cei/get_invitation_code"
        case .profitHistory:
            return "/cei/search_cash_withdrawal_amount_history_list"
        case .invoiceList:
            return "/cei/get_user_invoice_list"
        case .updateInvoice:
            return "/cei/update_user_invoice"
        case .deleteInvoice:
            return "/cei/delete_user_invoice"
        case .getLogisticsData:
            return "/cei/get_carrier_detail"
        case .rechargeIAPOrder:
            return "/cei/ios_recharge"
        case .rechargeIAPOrderString:
            return "/cei/ios_recharge_learning_points"
        case .getAPPVersionInfo:
            return "/cei/front/get_new_ios_version"
        case .getPayOrderStatus:
            return "/cei/get_pay_order_status"
        case .touristRegister:
            return "/cei/tourist_register"
        case .applyDelayCourse:
            return "/cei/save_user_study_apply_extension"
        case .liveClassPlayBackList:
            return "/cei/search_playback_course_list"
        case .bindPhone:
            return "/cei/bind_phone"
        case .liveClassJoinRight:
            return "/cei/save_user_use_live_activation"
        case .getLivePlayBackFunc:
            return "/cei/search_playback_course_list"
        case .logoutAccount:
            return "/cei/logout"
        case .studyCardPay:
            return "/cei/user_learning_points_pay"
        case .searchUserCoupons(let status, let pageNo, let pageSize):
            return "/cei/search_user_coupons"
        case .allDiscountProduct:
            return "/cei/search_coupon_product_list"
        case .couponInstruction:
            return "/cei/search_coupons_instructions"
        case .saveNewWithVipOrder:
            return "/cei/save_order"
        case .saveNewWithoutVipOrder:
            return "/cei/save_order"
        case .getDiscountCoupons:
            return "/cei/search_product_user_discount_coupons"
        case .getConfirmOrderCoupons:
            return "/cei/search_order_user_coupons"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login,
             .thirdLogin,
             .thirdCheckCode,
             .addAddress,
             .deleteAddress,
             .addGoodsToCart,
             .deleteGoodsInCart,
             .updateUserInfo,
             .updateUserContacts,
             .updateAddress,
             .getCode,
             .verifyCode,
             .register,
             .thirdRegister,
             .resetPassword,
             .saveOrder,
             .saveNewWithVipOrder,
             .saveNewWithoutVipOrder,
             .deleteGoods,
             .getCoupon,
             .updateGoods,
             .submitExamAnswer,
             .updateCourseProgress,
             .activeLearnCard,
             .saveSchoolRoll,
             .deleteOrder,
             .updateOrderStatus,
             .useCourseCard,
             .remoteClassUseCourseCard,
             .saveInvoice,
             .deleteInvoice,
             .updateInvoice,
             .thirdBind,
             .addReferrer,
             .rechargeIAPOrderString,
             .rechargeIAPOrder,
             .touristRegister,
             .applyDelayCourse,
             .thirdOldAccount,
             .bindPhone,
             .liveClassJoinRight,
             .studyCardPay,
             .saveUserCoupon:
            return .post
        case .selectOrderStatus, .getPayOrderStatus:
            return .get
        case .saveGroupSignal:
            return .get
        case .thirdUnbind:
            return .get
        case .getLogisticsData, .getAPPVersionInfo:
            return .get
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        var dic:[String: Any] = [:]
        switch self {
        case .getLogisticsData(let status, let productType, let goodsStatus, let carrierID, let courierNumber):
            dic["status"] = status
            dic["productType"] = productType
            dic["goodsStatus"] = goodsStatus
            dic["carrierID"] = carrierID
            dic["courierNumber"] = courierNumber
            break
        case .thirdLogin(let unionid, let type):
            dic["credential"] = unionid
            dic["type"] = type
            break
        case .thirdBind(let type, let credential):
            dic["type"] = type
            dic["credential"] = credential
            dic["userID"] = LoginHelper.shared.currentUser.value?.userID.string ?? ""
            break
        case .thirdUnbind(let type):
            dic["type"] = type
        case .thirdOldAccount(let type, let credential, let loginName, let password, let phone):
            dic["type"] = type
            dic["credential"] = credential
            dic["loginName"] = loginName
            dic["password"] = password
            dic["phone"] = phone
            break
        case .thirdCheckCode(let phone, let code, let type, let credential):
            dic["phone"] = phone
            dic["code"] = code
            dic["type"] = type
            dic["credential"] = credential
            break
        case .provinceList:
            break
        case .city(let regionID):
            dic["regionID"] = regionID
        case .addressList:
            break
        case .navigation:
            break
        case .login(let name, let password):
            dic["loginName"] = name
            dic["password"] = password.kf.md5.uppercased()
        case .register(let phone, let password, let code):
            dic["phone"] = phone
            dic["password"] = password.md5.uppercased()
            dic["code"] = code
        case .thirdRegister(let phone, let password, let code, let nickName, let headUrl, let type, let credential):
            dic["phone"] = phone
            dic["password"] = password.md5.uppercased()
            dic["code"] = code
            dic["nickName"] = nickName
            dic["headUrl"] = headUrl
            dic["type"] = type
            dic["credential"] = credential
            dic["loginIsAPP"] = 1
        case .resetPassword(let phone, let password, let code):
            dic["phone"] = phone
            dic["password"] = password.md5.uppercased()
            dic["code"] = code
        case .getCode(let phone):
            dic["phone"] = phone
        case .verifyCode(let phone, let code):
            dic["phone"] = phone
            dic["code"] = code
        case .studyList(let type, let isExpire):
            dic["type"] = type
            dic["isExpire"] = isExpire
        case .classList(let type, let isExpire):
            dic["type"] = type
            dic["isExpire"] = isExpire
        case .liveList(let type, let isExpire):
            dic["type"] = type
            dic["isExpire"] = isExpire
        case .cartList:
            break
        case .userInfo:
            break
        case .addAddress(let model):
            dic["userName"] = model.userName
            dic["phone"] = model.phone
            dic["provinceID"] = model.provinceID
            dic["cityID"] = model.cityID
            dic["countyID"] = model.countyID
            dic["streetID"] = model.streetID
            dic["address"] = model.address
            dic["streetName"] = model.streetName
            dic["postCode"] = model.postCode
            dic["label"] = model.label
        case .updateAddress(let model):
            dic["userName"] = model.userName
            dic["phone"] = model.phone
            dic["provinceID"] = model.provinceID
            dic["cityID"] = model.cityID
            dic["countyID"] = model.countyID
//            dic["streetID"] = model.streetID
            dic["address"] = model.address
            dic["postCode"] = model.postCode
            dic["label"] = model.label
            dic["addressID"] = model.addressID
        case .deleteAddress(let id):
            dic["addressID"] = id
        case .addGoodsToCart(let productID, let type, let count):
            dic["productID"] = productID
            dic["type"] = type
            dic["count"] = count
        case .deleteGoodsInCart(let cartID, let count):
            dic["cardID"] = cartID
            dic["count"] = count
        case .updateGoods(let number, let cardID):
            dic["cardID"] = cardID
            dic["count"] = number
        case .updateUserInfo(let para):
            for key in para.keys {
                dic[key] = para[key]
            }
        case .updateUserContacts(let para):
            for key in para.keys {
                dic[key] = para[key]
            }
        
        case .orderList(let status, let pageNo, let pageSize):
//            if let string = status.emptyToNil() {
                dic["status"] = status
                dic["pageNo"] = pageNo
                dic["pageSize"] = pageSize
//            }
        case .courseWareList(let courseID):
            dic["courseID"] = courseID
        case .classCourseList(let userStudyID):
            dic["userStudyID"] = userStudyID
        case .orderDetail(let orderId):
            dic["orderID"] = orderId
        
        case .getOrderDetail(let orderId):
            dic["orderID"] = orderId
            
        case .saveOrder(let totalPrice, let discountPrice, let payMode, let addressID, let distributionMode, let couponIDs, let ruleIDs, let invoiceID, let productList):
            dic["totalPrice"] = totalPrice
            dic["addressID"] = addressID
            dic["discountPrice"] = discountPrice
            dic["payMode"] = payMode
            dic["couponIDs"] = couponIDs
            dic["ruleIDs"] = ruleIDs
            
            dic["distributionMode"] = distributionMode
            dic["invoiceID"] = invoiceID ?? ""
            dic["productList"] = productList.toJSONString() ?? ""
            dic["payChannel"] = 3
        case .saveNewWithVipOrder(let isGroup, let addressID, let discountPrice, let distributionMode, let ruleIDs, let productType, let totalPrice, let invitationCode, let payChannel, let productList, let invoiceID, let trafficPay, let couponIDs, let payMode, let recommenderName):
            dic["isGroup"] = isGroup
            dic["addressID"] = addressID
            dic["discountPrice"] = discountPrice
            dic["distributionMode"] = distributionMode
            dic["ruleIDs"] = ruleIDs
            dic["productType"] = productType
            dic["totalPrice"] = totalPrice
            dic["invitationCode"] = invitationCode
            dic["payChannel"] = payChannel
            dic["productList"] = productList.toJSONString() ?? ""
            dic["trafficPay"] = trafficPay
            dic["invoiceID"] = invoiceID
            dic["couponIDs"] = couponIDs
            dic["payMode"] = payMode
            dic["recommenderName"] = recommenderName
        case .saveNewWithoutVipOrder(let isGroup, let addressID, let discountPrice, let distributionMode, let ruleIDs, let productType, let totalPrice, let invitationCode, let payChannel, let productList, let invoiceID, let trafficPay, let couponIDs, let payMode, let recommenderName):
            dic["isGroup"] = isGroup
            dic["addressID"] = addressID
            dic["discountPrice"] = discountPrice
            dic["distributionMode"] = distributionMode
            dic["ruleIDs"] = ruleIDs
            dic["productType"] = productType
            dic["totalPrice"] = totalPrice
            dic["invitationCode"] = invitationCode
            dic["payChannel"] = payChannel
            dic["productList"] = productList.toJSONString() ?? ""
            dic["trafficPay"] = trafficPay
            dic["invoiceID"] = invoiceID
            dic["couponIDs"] = couponIDs
            dic["payMode"] = payMode
            dic["recommenderName"] = recommenderName
            
        case .selectOrderStatus(let productID):
            dic["productID"] = productID
        case .deleteGoods(let ids):
            dic["cardIDs"] = ids.joined(separator: ",")
        case .getCoupon(let promotionID, let ruleID):
            dic["promotionID"] = promotionID
            dic["ruleID"] = ruleID
        case .couponList(let pageNo, let pageSize, let status):
            dic["status"] = status
            dic["pageNo"] = pageNo
            dic["pageSize"] = pageSize
        case .productCouponNewList(let productID, let productType):
            dic["productID"] = productID
            dic["productType"] = productType
        case .saveUserCoupon(let promotionCouponDetialID):
            dic["promotionCouponDetialID"] = promotionCouponDetialID
        case .myExamList:
            break
        case .courseExam:
            break
        case .withClassTestData(let eclassID):
            dic["eclassID"] = eclassID
        case .getExamQuestion(let pagerID, let examID):
            dic["paperID"] = pagerID
            dic["examID"] = examID
        case .useCourseCard(let cardNo, let code):
            dic["cardNo"] = cardNo
            dic["code"] = code
        case .remoteClassUseCourseCard(let cardNo, let code, let productID):
            dic["cardNo"] = cardNo
            dic["code"] = code
            dic["productID"] = productID
        case .getCourseCard(let phone, let password):
            dic["phone"] = phone
            dic["password"] = password
        case .submitExamAnswer(let answers):
            dic["answers"] = answers
        case .updateCourseProgress(let userStudyID, let courseID, let startTime, let endTime):
            dic["userStudyID"] = userStudyID
            dic["courseID"] = courseID
            dic["startTime"] = startTime
            dic["endTime"] = endTime
        case .examResult(let examID, let paperID, let paperNo, let userPaperID):
            dic["examID"] = examID
            dic["paperID"] = paperID
            dic["paperNo"] = paperNo
            dic["userPaperID"] = userPaperID
        case .examRecords(let examID):
            dic["examID"] = examID
        case .activeLearnCard(let learnCardNo, let password):
            dic["learnCardNo"] = learnCardNo
            dic["password"] = password
        case .saveSchoolRoll(let eclassID, let propertyJson):
            dic["eclassID"] = eclassID
//            dic["propertyJson"] = "[{ value: \"222\", property: \"name\", displayName: \"姓名\"}]"
            dic["propertyJson"] = propertyJson
//            dic["jsonStr"] = "{eclassID: \(eclassID),propertyJson:\(propertyJson)}"
        case .getClassSchoolRoll(let eclassID):
            dic["eclassID"] = eclassID
        case .getLiveClassSchoolRoll(let liveCourseID):
            dic["liveCourseID"] = liveCourseID
        case .saveGroupSignal(let groupBuyID, let productID, let orderID):
            dic["groupBuyID"] = groupBuyID
            dic["productID"] = productID
            dic["orderID"] = orderID
        case .getClassShoolRollInfo(let eclassID):
            dic["eclassID"] = eclassID
        case .getLiveClassSchoolRollInfo(let liveCourseID):
            dic["liveCourseID"] = liveCourseID
        case .payDetail(let orderId, let type):
            dic["orderID"] = orderId
            dic["source"] = type //1 为移动端, 4 为支付宝
        case .deleteOrder(let orderId):
            dic["orderID"] = orderId
        case .updateOrderStatus(let orderID, let status):
            dic["orderID"] = orderID
            dic["status"] = status
        case .payResult(let orderID):
            dic["orderID"] = orderID
        case .courseCardList(let pageNo, let pageSize):
            dic["pageNo"] = pageNo
            dic["pageSize"] = pageSize
        case .learnCardList(let pageNo, let pageSize):
            dic["pageNo"] = pageNo
            dic["pageSize"] = pageSize
        case .learnCardAmount:
            break
        case .saveInvoice(let invoiceType, let invoiceRise, let companyName, let taxpayerNo, let contentType, let email):
            dic["invoiceType"] = invoiceType
            dic["invoiceRise"] = invoiceRise
            dic["companyName"] = companyName
            dic["taxpayerNo"] = taxpayerNo
            dic["contentType"] = contentType
            dic["email"] = email
        case .getInviteCode(let activityID , let productID):
            dic["activityID"] = activityID
            dic["productID"] = productID
        case .profitHistory(let pageNo, let pageSize):
            dic["userID"] = LoginHelper.shared.currentUser.value?.userID.string ?? ""
        case .invoiceList:
            break
        case .updateInvoice(let invoiceID, let invoiceType, let invoiceRise, let companyName, let taxpayerNo, let contentType):
            dic["invoiceID"] = invoiceID
            dic["invoiceType"] = invoiceType
            dic["invoiceRise"] = invoiceRise
            dic["companyName"] = companyName
            dic["taxpayerNo"] = taxpayerNo
            dic["contentType"] = contentType
        case .deleteInvoice(let invoiceID):
            dic["invoiceIDs"] = invoiceID
        case .addReferrer(let orderID, let recommenderName):
            dic["orderID"] = orderID
            dic["recommenderName"] = recommenderName
        case .rechargeIAPOrder(let poNumber, let receipt_data):
            dic["poNumber"] = poNumber
            dic["receipt_data"] = receipt_data
        case .rechargeIAPOrderString(let poNumber, let receiptData):
            dic["poNumber"] = poNumber
            dic["receipt_data"] = receiptData
        case .getPayOrderStatus(let productIDs):
            dic["productIDs"] = productIDs
        case .getAPPVersionInfo:
            break
        case .touristRegister:
            break
        case .applyDelayCourse(let userStudyID):
            dic["userStudyID"] = userStudyID
        case .liveClassPlayBackList(let liveCourseID):
            dic["liveCourseID"] = liveCourseID
        case .bindPhone(let phone):
            dic["phone"] = phone
        case .liveClassJoinRight(let code, let phoneNum, let productID):
            dic["code"] = code
            dic["phoneNum"] = phoneNum
            dic["productID"] = productID
        case .getLivePlayBackFunc(let liveCourseID):
            dic["liveCourseID"] = liveCourseID
        case .studyCardPay(let orderID):
            dic["orderID"] = orderID
        case .searchUserCoupons(let status, let pageNo, let pageSize):
            dic["status"] = status
            dic["pageNo"] = pageNo
            dic["pageSize"] = pageSize
        case .allDiscountProduct(let promotionID, let productScope, let pageNo, let pageSize):
            dic["promotionID"] = promotionID
            dic["productScope"] = productScope
            dic["pageNo"] = pageNo
            dic["pagiSize"] = pageSize
        case .couponInstruction:
            break
        case .logoutAccount:
            break
        case .getDiscountCoupons(let productID, let userCouponIDs):
            dic["productID"] = productID
            dic["userCouponIDs"] = userCouponIDs
        case .getConfirmOrderCoupons(let productIDs, let vipProductIDs):
            dic["productIDs"] = productIDs
            dic["vipProductIDs"] = vipProductIDs
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
