//
//  Config.swift
//  SwiftTest
//
//  Created by ENERGY on 2019/7/31.
//  Copyright © 2019 ENERGY. All rights reserved.
//

import Foundation
import UIKit
////屏幕宽高
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
//判断机型
let Is_Iphone = (UI_USER_INTERFACE_IDIOM() == .phone)
let Is_Iphone_X = (Is_Iphone && SCREEN_HEIGHT >= 812.0)
let NAVI_HEIGHT = (Is_Iphone_X ? 88 : 64)
let TABBAR_HEIGHT =  (Is_Iphone_X ? 83 : 49)
let BOTTOM_HEIGHT = (Is_Iphone_X ? 34 : 0)
//5S宽高比例
let ScreenBounds = UIScreen.main.bounds
let WIDTH_5S_SCALE = 320.0 / UIScreen.main.bounds.size.width
let HEIGHT_5S_SCALE = 568.0 / UIScreen.main.bounds.size.height
//let WIDTH_6_SCALE = 375.0 / UIScreen.main.bounds.size.width
let WIDTH_6_SCALE = Is_Iphone_X ? 414 / UIScreen.main.bounds.size.width : 375 / UIScreen.main.bounds.size.width
let HEIGHT_6_SCALE = 667.0 / UIScreen.main.bounds.size.height
//通用字号
let DEF_FontSize_26 = UIFont.systemFont(ofSize: 26)
let DEF_FontSize_24 = UIFont.systemFont(ofSize: 24)
let DEF_FontSize_18 = UIFont.systemFont(ofSize: 18)
let DEF_FontSize_17 = UIFont.systemFont(ofSize: 17)
let DEF_FontSize_16 = UIFont.systemFont(ofSize: 16)
let DEF_FontSize_15 = UIFont.systemFont(ofSize: 15)
let DEF_FontSize_14 = UIFont.systemFont(ofSize: 14)
let DEF_FontSize_13 = UIFont.systemFont(ofSize: 13)
let DEF_FontSize_12 = UIFont.systemFont(ofSize: 12)
let DEF_FontSize_11 = UIFont.systemFont(ofSize: 11)
let DEF_FontSize_10 = UIFont.systemFont(ofSize: 10)
let DEF_FontSize_9 = UIFont.systemFont(ofSize: 9)
let DEF_FontSize_8 = UIFont.systemFont(ofSize: 8)

let WeChatReturnSucceedPayNotification : String = "WeChatReturnSucceedPayNotification"
let WXAuthorizationSuccess : String = "wxLoginSuccess"

let postMoneyDic : [[String : String]] = [["key":"北京", "value":"8"], ["key":"河北省", "value":"10"], ["key":"河南省", "value":"10"], ["key":"天津", "value":"10"], ["key":"山东省", "value":"10"], ["key":"山西省", "value":"10"], ["key":"江苏省", "value":"10"], ["key":"浙江省", "value":"10"], ["key":"上海", "value":"10"], ["key":"安徽省", "value":"10"], ["key":"黑龙江省", "value":"10"], ["key":"吉林省", "value":"10"], ["key":"辽宁省", "value":"10"], ["key":"陕西省", "value":"10"], ["key":"湖北省", "value":"10"], ["key":"湖南省", "value":"10"], ["key":"江西省", "value":"10"], ["key":"福建省", "value":"10"], ["key":"四川省", "value":"10"], ["key":"重庆", "value":"10"], ["key":"海南省", "value":"12"], ["key":"云南省", "value":"12"], ["key":"广东省", "value":"12"], ["key":"广西壮族自治区", "value":"12"], ["key":"甘肃省", "value":"12"], ["key":"宁夏回族自治区", "value":"12"], ["key":"贵州省", "value":"12"], ["key":"鄂尔多斯", "value":"12"], ["key":"海拉尔", "value":"12"], ["key":"内蒙古自治区", "value":"12"], ["key":"台湾省", "value":"12"], ["key":"新疆维吾尔自治区", "value":"22"], ["key":"西藏自治区", "value":"12"], ["key":"香港特别行政区", "value":"12"], ["key":"澳门特别行政区", "value":"12"], ["key":"青海省", "value":"12"]]
//
////城市选择用
//let ScreenWidth: CGFloat = UIScreen.main.bounds.size.width
//let ScreenHeight: CGFloat = UIScreen.main.bounds.size.height
//let btnHighlightColor = UIColor.ColorHex("efeff4")
///// btn 高亮图片
//let btnHighlightImage = UIColor.creatImageWithColor(color: btnHighlightColor)
///// section间距
//let sectionMargin: CGFloat = 28/WIDTH_6_SCALE
//
///// 热门城市btn
//let btnMargin: CGFloat = 15/WIDTH_6_SCALE
//let btnWidth: CGFloat = (ScreenWidth - 73/WIDTH_6_SCALE - 42/WIDTH_6_SCALE) / 4
//let btnHeight: CGFloat = 30/WIDTH_6_SCALE

//IM
//聊天
let CHAT_PUSHVIEWCONTROLLER = "EMPushChatViewController"
let CHAT_CLEANMESSAGES = "EMChatCleanMessages"
//消息动图
let MSG_EXT_GIF_ID = "em_expression_id"
let MSG_EXT_GIF = "em_is_big_expression"
//消息撤回
let MSG_EXT_RECALL = "em_recall"

let MSG_EXT_READ_RECEIPT = "em_read_receipt"
let MSG_EXT_UN_READ_RECEIPT = "em_read_unreceipt"
//多人会议邀请
let MSG_EXT_CALLID = "em_conference_id"
