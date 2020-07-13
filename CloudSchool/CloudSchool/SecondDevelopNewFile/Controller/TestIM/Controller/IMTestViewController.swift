//
//  TestIMViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/2/11.
//  Copyright © 2020 CEI. All rights reserved.
// 

import UIKit
import HyphenateLite
import LFLiveKit
import IQKeyboardManagerSwift
import RxSwift
import RxCocoa
class IMTestPageViewController: UIViewController, UINavigationControllerDelegate {
    var liveClassArray: [SelectLiveClassDataModel] = [SelectLiveClassDataModel]()
    var msgQueue : DispatchQueue!
    var conversationModel: IMConversationModel!
    var dataArray: [IMMessageModel] = [IMMessageModel]()
    let disposeBag = DisposeBag()
    var chatRoomUserName = ""
    var chatRoomNickName = ""
    var IMPassword = ""
    var heightArray: [CGFloat] = [CGFloat]()
    var isRoomOwner: Bool = false
    var isScrollUp: Bool = false//是否认为向上查找聊天记录
    var oldOffset: CGFloat = 0//偏移量
    var noTalkUserID: String = ""
    var roomID: Int = 0
    var objectID: Int = 0
    var productName: String = ""
    var chatRoomID: String = ""
    let tableViewW = SCREEN_WIDTH - 50/WIDTH_6_SCALE
    lazy var stream: LFLiveStreamInfo = {
        var stream = LFLiveStreamInfo()
        stream.url = ""
        return stream
    }()
    lazy var liveStopAlertView : LiveStopAlertView = {
        var liveStopAlertView = LiveStopAlertView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        liveStopAlertView.dismissViewBlock = {
            UIView.animate(withDuration: 0.15, animations: {
                self.liveStopAlertView.alpha = 0
            }) { (Bool) in
                self.liveStopAlertView.removeFromSuperview()
            }
        }
        liveStopAlertView.backPageBlock = {
            UIView.animate(withDuration: 0.15, animations: {
                self.liveStopAlertView.alpha = 0
            }) { (Bool) in
                self.liveStopAlertView.removeFromSuperview()
                self.navigationController?.popViewController()
                self.session.running = false
                self.session.stopLive()
            }
        }
        return liveStopAlertView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self as UINavigationControllerDelegate
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        IQKeyboardManager.shared.enable = false
        
        IMHelper.shared.getLiveClassListData().asObservable().subscribe(onNext: {[weak self] (model) in
            guard let `self` = self else { return }
            if model.code == 200{
                self.liveClassArray.removeAll()
                self.selectLiveClassView.classArray.removeAll()
                self.liveClassArray = model.data!
                self.selectLiveClassView.classArray = self.liveClassArray
                self.selectLiveClassView.tableView.reloadData()
            }else{
                
            }
        }).disposed(by: disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        IQKeyboardManager.shared.enable = true
        NotificationCenter.default.removeObserver(self)
        self.session.running = false
        self.session.stopLive()
        self.liveStopAlertView.dismissView()
        self.selectLiveClassView.dismissView()
        self.session.delegate = nil
        if self.conversationModel != nil{
            if self.conversationModel.emModel.conversationId != nil{
                EMClient.shared()?.roomManager.leaveChatroom(self.conversationModel.emModel.conversationId, completion: { (error) in
                    if error == nil{
    //                    let str = "\(self.chatRoomUserName)离开聊天室"
    //                    self.showHint(str)
                    }
                })
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.msgQueue = DispatchQueue.init(label: "emmessage.com")
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.backBtn)
        self.view.addSubview(self.replyView)
        self.view.addSubview(self.switchCamerabtn)
        self.view.addSubview(self.activityView)
        self.view.addSubview(self.numLab)
        self.selectLiveClassView.showView()
    }
    deinit {
        EMClient.shared()?.chatManager.remove(self)
        EMClient.shared()?.roomManager.remove(self)
    }
    lazy var selectLiveClassView : SelectLiveClassView = {
        var selectLiveClassView = SelectLiveClassView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        selectLiveClassView.cancelBtnBlock = {
            self.navigationController?.popViewController()
        }
        selectLiveClassView.selectLiveClassBlock = { (liveClassData) in
            self.stream.url = liveClassData.pushUrl
            self.activityView.startAnimating()
            self.session.startLive(self.stream)
            IMHelper.shared.getChatRoomInfo(objectID: "\(self.objectID)").asObservable().subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                if model.code == 200{
                    let info : IMModel = model.data!
                    self.chatRoomUserName = info.username
                    self.chatRoomNickName = info.nickname
                    self.IMPassword = info.password
                    self.roomID = info.roomID
                    self.chatRoomID = "\(info.roomID)"
                    //顺序执行
                    let workGroup = DispatchGroup.init()
                    let workingQueue = DispatchQueue(label: "loginRoom")
                    workGroup.enter()
                    workingQueue.async {
                        let error = EMClient.shared()?.login(withUsername: self.chatRoomUserName, password: self.IMPassword)
                        if error != nil{
                            HUD.showText(text: "注册失败")
                            return
                        }
                        workGroup.leave()
                    }
                    workGroup.enter()
                    workingQueue.async {
                        EMClient.shared()?.roomManager.joinChatroom("\(info.roomID)", completion: { (chatRoom, emerror) in
                            if emerror != nil{
                                self.showAlert(title: "进房失败", message: "")
                                return
                            }else{
                                HUD.showText(text: "成功进入房间")
                            }
                        })
                        workGroup.leave()
                    }
                    // 调度组里的任务都执行完毕
                    workGroup.notify(queue: workingQueue) {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                    let conversation = EMClient.shared()?.chatManager.getConversation("\(info.roomID)", type: EMConversationTypeChatRoom, createIfNotExist: true)
                    self.conversationModel = IMConversationModel.init(aModel: conversation!)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }else if model.code == 5001{
                    self.replyView.removeFromSuperview()
                }
                self.selectLiveClassView.dismissView()
            }).disposed(by: self.disposeBag)
        }
        return selectLiveClassView
    }()
    lazy var switchCamerabtn : UIButton = {
        var switchCamerabtn = UIButton.init(frame: CGRect(x: SCREEN_WIDTH - self.backBtn.left - self.backBtn.width, y: self.backBtn.top, width: 30/WIDTH_6_SCALE, height: 30/WIDTH_6_SCALE))
        switchCamerabtn.setBackgroundColor(UIColor.clear, forState: .normal)
        switchCamerabtn.addTarget(self, action: #selector(switchCamerabtnClick(button:)), for: .touchUpInside)
        switchCamerabtn.setImage(UIImage.init(named: "live_switch"), for: .normal)
        return switchCamerabtn
    }()
    @objc func backBtnClick(){
        self.navigationController?.popViewController()
        self.session.running = false
        self.session.stopLive()
    }
    
    lazy var backBtn : UIButton = {
        var backBtn = UIButton.init(frame: CGRect(x: 30/WIDTH_6_SCALE, y: 40/WIDTH_6_SCALE, width: 30/WIDTH_6_SCALE, height: 30/WIDTH_6_SCALE))
        backBtn.setImage(UIImage.init(named: "live_close"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        backBtn.backgroundColor = .clear
        return backBtn
    }()
    
    lazy var tableView : UITableView = {
        let viewH = 350/WIDTH_6_SCALE
        var tableView = UITableView.init(frame: CGRect(x: 0, y: SCREEN_HEIGHT - viewH - CGFloat(BOTTOM_HEIGHT) - CGFloat(10/WIDTH_6_SCALE) - CGFloat(NAVI_HEIGHT), width: tableViewW, height: viewH))
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(IMLiveMessageTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(IMLiveMessageTableViewCell.self))
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        // 设置预估行高 --> 先让 tableView 能滚动，在滚动的时候再去计算显示的 cell 的真正的行高，并且调整 tabelView 的滚动范围
        tableView.estimatedRowHeight = 300
        return tableView
    }()
    lazy var replyView: ReplyView = {
        var replyView = ReplyView.init(frame: CGRect(x: 0, y: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT) - 51/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 51/WIDTH_6_SCALE))
        replyView.replyViewBlock = {(sendString, sendView) in
            if sendString!.count > 40{
                HUD.showText(text: "请输入少于四十个字")
                return
            }
            let body = EMTextMessageBody.init(text: sendString!)
            self.sendMessageWithBody(aBody: body!)
        }
        return replyView
    }()
    lazy var customOptionView : IMCustomOptionView = {
        weak var weakSelf = self
        var customOptionView = IMCustomOptionView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        customOptionView.IMCustomOptionViewDismissBlock = {
            UIView.animate(withDuration: 0.15, animations: {
                self.customOptionView.alpha = 0
            }) { (Bool) in
                self.customOptionView.removeFromSuperview()
            }
        }
        customOptionView.noTalkBlock = {
            EMClient.shared()?.roomManager.muteMembers([self.noTalkUserID], muteMilliseconds: -1, fromChatroom: "\(self.roomID)", completion: { (aChatroom, aError) in
                if aError == nil{
                    self.showHint("禁言成功")
                }else{
                    self.showHint("禁言失败")
                }
                weakSelf?.customOptionView.dismissView()
            })
        }
        return customOptionView
    }()
    lazy var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.default()
        let videoConfiguration = LFLiveVideoConfiguration.default()
        let session = LFLiveSession.init(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        session!.delegate = self
        session?.preView = self.view
        session?.captureDevicePosition = .back
        session?.beautyFace = true
        session?.captureDevicePosition = .front
        session?.running = true
        session?.beautyFace = true
        return session!
    }()
    
    lazy var activityView: UIActivityIndicatorView = {
        var activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityView.frame = CGRect(x: 100, y: 100, width: 50, height: 50)
        activityView.center = self.view.center
        activityView.backgroundColor = UIColor.white
        return activityView
    }()
    
    lazy var numLab : UILabel = {
        weak var weakSelf = self
        let labelW = 150/WIDTH_6_SCALE
        var titleLab = UILabel.init(frame: CGRect(x: (weakSelf?.switchCamerabtn.left)! - labelW - 10/WIDTH_6_SCALE, y: 0, width: labelW, height: 15/WIDTH_6_SCALE))
        titleLab.centerY = weakSelf?.switchCamerabtn.centerY as! CGFloat
        titleLab.font = DEF_FontSize_12
        titleLab.backgroundColor = .clear
        titleLab.textColor = .black
        titleLab.textAlignment = .right
        return titleLab
    }()
    
//    func networkData(){
//        IMHelper.shared.getLiveClassInfo(pushUrl: self.stream.url).asObservable().subscribe(onNext: {[weak self] (model) in
//            guard let `self` = self else { return }
//            if model.code == 200{
//                let classInfo: LiveClassModel = model.data!
//                self.objectID = classInfo.objectID
//                self.productName = classInfo.productName
//                self.classInfoAlertView.showView()
//            }
//        }).disposed(by: disposeBag)
//    }
}

//action
extension IMTestPageViewController{
    @objc func switchCamerabtnClick(button: UIButton){
        button.isSelected = !button.isSelected
        if button.isSelected {
            self.session.captureDevicePosition = .back
        }else{
            self.session.captureDevicePosition = .front
        }
    }
}
//拉流
extension IMTestPageViewController: LFLiveSessionDelegate{
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        activityView.stopAnimating()
        if state == .pending {
//            showHint("连接中")
        }else if state == .start{
            HUD.showText(text: "已连接")
        }else{
            if state == .error{
//                showHint("连接错误")
            }else if state == .stop{
//                showHint("已断开")
            }else if state == .refresh{
//                showHint("正在刷新")
            }
            self.session.startLive(stream)
        }
    }
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        if errorCode == .preView{
//            showHint("预览失败")
        }else if errorCode == .getStreamInfo{
            HUD.showText(text: "获取流媒体信息失败")
        }else if errorCode == .connectSocket{
            HUD.showText(text: "连接socket失败")
        }else if errorCode == .verification{
            HUD.showText(text: "验证服务器失败")
            self.session.startLive(stream)
        }else if errorCode == .reConnectTimeOut{
//            HUD.showText(text: "重新连接服务器超时")
            self.session.startLive(stream)
        }
    }
}
extension IMTestPageViewController: EMClientDelegate, EMChatManagerDelegate, EMChatroomManagerDelegate{
    /*!
    *  SDK连接服务器的状态变化时会接收到该回调
    *
    *  有以下几种情况，会引起该方法的调用：
    *  1. 登录成功后，手机无法上网时，会调用该回调
    *  2. 登录成功后，网络状态变化时，会调用该回调
    *
    *  @param aConnectionState 当前状态
    */
    func connectionStateDidChange(_ aConnectionState: EMConnectionState) {
        
    }
    /*!
    @method
    @brief 接收到一条及以上消息
    */
    func messagesDidReceive(_ aMessages: [Any]!) {
        weak var weakSelf = self
        self.msgQueue.async {
            let conId = weakSelf?.conversationModel.emModel.conversationId
            var msgArray = [EMMessage]()
            for num in 0...(aMessages.count-1){
                let msg = aMessages[num] as! EMMessage
                if msg.conversationId == conId {
                    msgArray.append(msg)
                }
            }
            let formated = weakSelf?.formatMessage(aMessages: msgArray)
            weakSelf?.dataArray += formated!
            DispatchQueue.main.async {
                weakSelf?.tableView.reloadData()
                if weakSelf?.isScrollUp == false{
                    weakSelf?.scrollToBottomRow()
                }
            }
        }
    }
    
    func formatMessage(aMessages: [EMMessage]) -> ([IMMessageModel]){
        var formated = [IMMessageModel]()
        for num in 0...aMessages.count - 1{
            let msg = aMessages[num]
            let model = IMMessageModel.init(aMsg: msg)
            formated.append(model)
        }
        return formated
    }
    
    func scrollToBottomRow(){
        if self.dataArray.count > 0{
            let toRow = self.dataArray.count - 1
            let toIndexPath = IndexPath.init(row: toRow, section: 0)
            self.tableView.scrollToRow(at: toIndexPath, at: .bottom, animated: false)
        }
    }
    //被踢出房间
    func didDismissFromChatroom(aChatroom: EMChatroom, aReason: EMChatroomBeKickedReason){
        let conversation = self.conversationModel.emModel
        if aChatroom.chatroomId == conversation.conversationId{
            self.navigationController?.popViewController(animated: true)
            self.session.running = false
            self.session.stopLive()
        }
    }
    
    func sendMessageWithBody(aBody: EMMessageBody){
        let message = EMMessage.init(conversationID: self.conversationModel.emModel.conversationId, from: self.chatRoomUserName, to: self.conversationModel.emModel.conversationId, body: aBody, ext: ["nickname":self.chatRoomNickName, "type":"teacher"])
        message?.chatType = EMChatTypeChatRoom
        weak var weakSelf = self
        EMClient.shared()?.chatManager.send(message, progress: nil, completion: { (message, error) in
            let formated = weakSelf?.formatMessage(aMessages: [message!])
            weakSelf?.dataArray = weakSelf!.dataArray + formated!
            DispatchQueue.main.async {
                weakSelf?.tableView.reloadData()
                weakSelf?.scrollToBottomRow()
            }
        })
    }
    
    func userDidLeave(_ aChatroom: EMChatroom!, user aUsername: String!) {
        if aChatroom.chatroomId == self.chatRoomID {
            self.getUserListData()
        }
    }
    
    func userDidJoin(_ aChatroom: EMChatroom!, user aUsername: String!) {
        if aChatroom.chatroomId == self.chatRoomID {
            self.getUserListData()
        }
    }
    
    func getUserListData(){
        IMHelper.shared.getUserListData(roomID: self.chatRoomID).asObservable()
        .subscribe(onNext: {[weak self] (model) in
            guard let `self` = self else { return }
            if model.code == 200{
                var userListArr: [LiveUserInfo] = [LiveUserInfo]()
                userListArr = model.data?.onlineUserList as! [LiveUserInfo]
                self.numLab.text = "(\(userListArr.count ?? 0)人在线)"
            }else{
                
            }
        }).disposed(by: disposeBag)
    }
}

extension IMTestPageViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        weak var weakSelf = self
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(IMLiveMessageTableViewCell.self), for: indexPath) as! IMLiveMessageTableViewCell
        cell.model = nil
        let model = self.dataArray[indexPath.row]
        cell.model = model
        cell.fansOptionsBlock = {(userName: String) in
            weakSelf?.noTalkUserID = userName
            weakSelf?.customOptionView.showView()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //赋值cell
        let model = self.dataArray[indexPath.row]
        let transformModel = model.emModel.body as! EMTextMessageBody
        let string = "\(model.emModel.from!)：\(transformModel.text!)"
        return ZuoHeightWithConstrainedWidth(width: tableViewW - 100/WIDTH_6_SCALE, font: DEF_FontSize_14, str: NSString(cString: string.cString(using: String.Encoding.utf8)!, encoding: String.Encoding.utf8.rawValue)!) + 25/WIDTH_6_SCALE
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > self.oldOffset {//向下
            if scrollView.contentOffset.y - self.oldOffset > 50/WIDTH_6_SCALE{
                self.isScrollUp = true
            }else{
                self.isScrollUp = false
            }
        }else{//向上
            print("向上")
            self.isScrollUp = false
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.oldOffset = scrollView.contentOffset.y
    }
}

extension IMTestPageViewController{
    func ZuoHeightWithConstrainedWidth(width:CGFloat, font:UIFont, str:NSString)->CGFloat{
        let constraintRect = CGSize(width:width, height:CGFloat.greatestFiniteMagnitude)
        let boundingBox = str.boundingRect(with:constraintRect, options:NSStringDrawingOptions.usesLineFragmentOrigin, attributes:[ NSAttributedString.Key.font:font], context:nil)
        // 返回boundingBox的。高度
        return boundingBox.height
    }
}
