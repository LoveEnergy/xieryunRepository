//
//  PlayLiveViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/2/11.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit
import IJKMediaFramework
import IQKeyboardManagerSwift
import RxSwift
import RxCocoa
import WebKit

class PlayLiveViewController: UIViewController, UINavigationControllerDelegate{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
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
    var objectID: Int = 0
    var productID: Int = 0
    var teacherID: Int = 0
    var shareImg: String = ""
    var chatRoomID: String = ""
    var userListArr: [LiveUserInfo] = [LiveUserInfo]()
    var classDetailBtn: UIButton?
    var onlineUserBtn: UIButton?
    lazy var options: IJKFFOptions = {
        let options = IJKFFOptions.byDefault()
        options?.setFormatOptionIntValue(0, forKey: "auto_convert")// 自动转屏开关
        return options!
    }()
    var player: IJKFFMoviePlayerController?
    lazy var playerView : UIView = {
        var playerView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 257/WIDTH_6_SCALE))
        playerView.backgroundColor = UIColor.gray
        return playerView
    }()
    lazy var changeModeBtn : UIButton = {
        var changeModeBtn = UIButton.init(frame: CGRect(x: SCREEN_WIDTH - 30/WIDTH_6_SCALE, y: self.playerView.height - 30/WIDTH_6_SCALE, width: 20/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE))
        changeModeBtn.setImage(UIImage.init(named: "player_full_btn"), for: .normal)
        changeModeBtn.setBackgroundColor(UIColor.clear, forState: .normal)
        changeModeBtn.addTarget(self, action: #selector(exitFullScreen(btn:)), for: .touchUpInside)
        return changeModeBtn
    }()
    lazy var backBtn : UIButton = {
        var backBtn = UIButton.init(frame: CGRect(x: 10, y: 30, width: 25/WIDTH_6_SCALE, height: 25/WIDTH_6_SCALE))
        backBtn.setImage(UIImage.init(named: "clear_back"), for: .normal)
        backBtn.setBackgroundColor(UIColor.clear, forState: .normal)
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        return backBtn
    }()
    lazy var teacherInfo : UIView = {
        var teacherInfo = UIView.init(frame: CGRect(x: 0, y: 275/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 78/WIDTH_6_SCALE + 50/WIDTH_6_SCALE))
        teacherInfo.backgroundColor = UIColor.colorWithHex(hex: "f4f4f4")
        var whiteView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 68/WIDTH_6_SCALE))
        whiteView.backgroundColor = .white
        teacherInfo.addSubview(whiteView)
        whiteView.addSubview(self.shareTitleLab)
        self.shareTitleLab.centerY = whiteView.centerY + 15/WIDTH_6_SCALE
        whiteView.addSubview(self.lineView)
        self.lineView.frame = CGRect(x: self.shareTitleLab.left - 1, y: 10/WIDTH_6_SCALE, width: 1, height: 38/WIDTH_6_SCALE)
        whiteView.addSubview(self.teacherImgView)
        self.teacherImgView.centerY = whiteView.height/2
        self.teacherNameLab.frame = CGRect(x: self.teacherImgView.right + 5/WIDTH_6_SCALE, y: self.teacherImgView.top + 8/WIDTH_6_SCALE, width: self.lineView.left - self.teacherImgView.right - 10/WIDTH_6_SCALE, height: self.teacherImgView.height - 16/WIDTH_6_SCALE)
        teacherNameLab.centerY = self.teacherImgView.centerY
        whiteView.addSubview(self.teacherNameLab)
        whiteView.addSubview(self.shareImgView)
        whiteView.addSubview(self.shareBtn)
        self.shareImgView.centerX = self.shareTitleLab.centerX
        self.shareImgView.centerY = whiteView.centerY - 15/WIDTH_6_SCALE
        self.shareBtn.frame = CGRect(x: self.shareTitleLab.left, y: self.shareImgView.top, width: self.shareTitleLab.width, height: self.shareTitleLab.bottom)
        //课程详情和评论
        var selectItemView = UIView.init(frame: CGRect(x: 0, y: whiteView.bottom + 10/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 50/WIDTH_6_SCALE))
        selectItemView.backgroundColor = UIColor.white
        teacherInfo.addSubview(selectItemView)
        for num in 0...2{//CGFloat(num) * SCREEN_WIDTH/2
            var btn = UIButton.init(frame: CGRect(x: (SCREEN_WIDTH - 300/WIDTH_6_SCALE)/2 + CGFloat(num) * 105/WIDTH_6_SCALE, y: 5/WIDTH_6_SCALE, width: 90/WIDTH_6_SCALE, height: selectItemView.height - 2 - 5/WIDTH_6_SCALE))
            selectItemView.addSubview(btn)
            btn.setTitleColor(.black, for: .normal)
            btn.titleLabel?.font = DEF_FontSize_18
            btn.addTarget(self, action: #selector(selectItemBtnClick(btn:)), for: .touchUpInside)
            btn.tag = 1000 + num
        }
        self.classDetailBtn = (selectItemView.viewWithTag(1000) as! UIButton)
        var IMBtn = selectItemView.viewWithTag(1001) as! UIButton
        self.onlineUserBtn = (selectItemView.viewWithTag(1002) as! UIButton)
        classDetailBtn!.setTitle("课程详情", for: .normal)
        IMBtn.setTitle("讨论", for: .normal)
        onlineUserBtn!.setTitle("在线用户", for: .normal)
        self.blueView.frame = CGRect(x: 0, y: classDetailBtn!.bottom, width: 50/WIDTH_6_SCALE, height: 2)
        self.onlineNumLab.frame = CGRect(x: onlineUserBtn!.right, y: 0, width: SCREEN_WIDTH - onlineUserBtn!.right, height: 15/WIDTH_6_SCALE)
        self.onlineNumLab.centerY = onlineUserBtn!.centerY
        self.blueView.centerX = classDetailBtn!.centerX
        selectItemView.addSubview(self.blueView)
        selectItemView.addSubview(self.onlineNumLab)
        return teacherInfo
    }()
    lazy var blueView : UIView = {
        var blueView = UIView.init()
        blueView.backgroundColor = UIColor.colorWithHex(hex: "0378FD")
        return blueView
    }()
    lazy var teacherImgView : UIImageView = {
        var teacherImgView = UIImageView.init(frame: CGRect(x: 7.5/WIDTH_6_SCALE, y: 7.5/WIDTH_6_SCALE, width: 51/WIDTH_6_SCALE, height: 51/WIDTH_6_SCALE))
        teacherImgView.backgroundColor = UIColor.lightGray
        return teacherImgView
    }()
    lazy var teacherNameLab : UILabel = {
        var teacherNameLab = UILabel.init(frame: CGRect(x: self.teacherImgView.right + 5/WIDTH_6_SCALE, y: self.teacherImgView.top + 8/WIDTH_6_SCALE, width: 280/WIDTH_6_SCALE - self.teacherImgView.right - 5/WIDTH_6_SCALE, height: self.teacherImgView.height - 16/WIDTH_6_SCALE))
        teacherNameLab.centerY = self.teacherImgView.centerY
        teacherNameLab.font = DEF_FontSize_14
        teacherNameLab.backgroundColor = .clear
        teacherNameLab.textColor = .black
        teacherNameLab.textAlignment = .left
        teacherNameLab.text = ""
        teacherNameLab.lineBreakMode = .byWordWrapping
        teacherNameLab.numberOfLines = 0
        teacherNameLab.sizeToFit()
        return teacherNameLab
    }()
    lazy var teacherIntroduceLab : UILabel = {
        var teacherIntroduceLab = UILabel.init(frame: CGRect(x: self.teacherNameLab.left, y: self.teacherNameLab.bottom + 10/WIDTH_6_SCALE, width: self.teacherNameLab.width, height: 13/WIDTH_6_SCALE))
        teacherIntroduceLab.font = DEF_FontSize_10
        teacherIntroduceLab.backgroundColor = .clear
        teacherIntroduceLab.textColor = UIColor.colorWithHex(hex: "808080")
        teacherIntroduceLab.textAlignment = .left
        teacherIntroduceLab.text = ""
        return teacherIntroduceLab
    }()
    lazy var tableView : UITableView = {
        var tableView = UITableView.init(frame: CGRect(x: SCREEN_WIDTH, y: self.teacherInfo.bottom, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.teacherInfo.bottom - 51/WIDTH_6_SCALE - CGFloat(BOTTOM_HEIGHT)))
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(IMMessageTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(IMMessageTableViewCell.self))
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        // 设置预估行高 --> 先让 tableView 能滚动，在滚动的时候再去计算显示的 cell 的真正的行高，并且调整 tabelView 的滚动范围
        tableView.estimatedRowHeight = 300
        return tableView
    }()
    
    lazy var coverWebView: WKWebView = {
        weak var weakSelf = self
        let jsString = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}"
        var wkUScript = WKUserScript.init(source: jsString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        var wkUController = WKUserContentController.init()
                wkUController.addUserScript(wkUScript)
        var wkWebConfig = WKWebViewConfiguration.init()
        wkWebConfig.userContentController = wkUController
        var coverWebView = WKWebView.init(frame: CGRect(x: 0, y: self.teacherInfo.bottom, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.teacherInfo.bottom - 51/WIDTH_6_SCALE - CGFloat(BOTTOM_HEIGHT)), configuration: wkWebConfig)
        coverWebView.scrollView.bounces = true
        coverWebView.scrollView.showsHorizontalScrollIndicator = false
        coverWebView.scrollView.isScrollEnabled = true
        coverWebView.uiDelegate = self
        coverWebView.navigationDelegate = self
        coverWebView.backgroundColor = UIColor.clear
        return coverWebView
    }()
    lazy var courseDetailLab : UILabel = {
        var titleLab = UILabel.init()
        titleLab.font = DEF_FontSize_14
        titleLab.backgroundColor = .clear
        titleLab.textColor = .black
        titleLab.textAlignment = .left
        titleLab.text = "aaa"
        titleLab.lineBreakMode = .byWordWrapping
        titleLab.numberOfLines = 0
        return titleLab
    }()
    lazy var userListTableView : UITableView = {
        var tableView = UITableView.init(frame: CGRect(x: SCREEN_WIDTH * CGFloat(2), y: self.teacherInfo.bottom, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.teacherInfo.bottom - 51/WIDTH_6_SCALE - CGFloat(BOTTOM_HEIGHT)))
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LiveUserListInfoTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(LiveUserListInfoTableViewCell.self))
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var lineView : UIView = {
        var lineView = UIView.init()
        lineView.backgroundColor = UIColor.colorWithHex(hex: "F4F4F4")
        return lineView
    }()
    lazy var shareTitleLab : UILabel = {
        var labelW = 100/WIDTH_6_SCALE
        var shareTitleLab = UILabel.init(frame: CGRect(x: SCREEN_WIDTH - labelW, y: 0, width: labelW, height: 14/WIDTH_6_SCALE))
        shareTitleLab.font = DEF_FontSize_12
        shareTitleLab.backgroundColor = .clear
        shareTitleLab.textColor = UIColor.colorWithHex(hex: "0378FD")
        shareTitleLab.textAlignment = .center
        shareTitleLab.text = "立即分享直播"
        return shareTitleLab
    }()
    lazy var shareImgView : UIImageView = {
        var shareImgView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 16/WIDTH_6_SCALE, height: 16/WIDTH_6_SCALE))
        shareImgView.image = UIImage.init(named: "blue_share")
        return shareImgView
    }()
    lazy var shareBtn : UIButton = {
        var shareBtn = UIButton.init()
        shareBtn.setBackgroundColor(UIColor.clear, forState: .normal)
        shareBtn.addTarget(self, action: #selector(shareBtnClick), for: .touchUpInside)
        return shareBtn
    }()
    lazy var replyView: ReplyView = {
        var replyView = ReplyView.init(frame: CGRect(x: 0, y: self.tableView.bottom, width: SCREEN_WIDTH, height: 51/WIDTH_6_SCALE))
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
    lazy var onlineNumLab : UILabel = {
        var titleLab = UILabel.init()
        titleLab.font = DEF_FontSize_12
        titleLab.backgroundColor = .clear
        titleLab.textColor = .black
        titleLab.textAlignment = .left
        return titleLab
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.networkData()
        
        self.navigationController?.delegate = self as UINavigationControllerDelegate
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //该页面显示时可以横竖屏切换
        appDelegate.interfaceOrientations = .allButUpsideDown
        IQKeyboardManager.shared.enable = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        weak var weakSelf = self
        self.player?.pause()
        self.player?.stop()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //页面退出时还原强制竖屏状态
        appDelegate.interfaceOrientations = .portrait
        IQKeyboardManager.shared.enable = true
        NotificationCenter.default.removeObserver(self)
        if self.conversationModel != nil{
            if self.conversationModel.emModel.conversationId != nil{
                EMClient.shared()?.roomManager.leaveChatroom(self.conversationModel.emModel.conversationId, completion: { (error) in
                    if error == nil{
//                        let str = "\(self.chatRoomUserName)离开聊天室"
//                        self.showHint(str)
                    }
                })
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.superview?.backgroundColor = .cyan
        self.msgQueue = DispatchQueue.init(label: "emmessage.com")
        self.view.addSubview(self.playerView)
        
        self.view.addSubview(self.backBtn)
        self.view.addSubview(self.teacherInfo)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.coverWebView)
        self.view.addSubview(self.userListTableView)
        self.view.addSubview(self.replyView)
    }
    deinit {
        EMClient.shared()?.chatManager.remove(self)
        EMClient.shared()?.roomManager.remove(self)
    }
    func networkData(){
        //拿到拉流地址
        RequestHelper.shared.getProuct(productID: "\(productID)")
        .asObservable()
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                guard let data = model.data else { return }
                self.teacherNameLab.text = data.productName
                self.teacherImgView.loadImage(string: data.thumbnailUrl)
                self.shareImg = data.previewImgUrl
                let playerTemp = IJKFFMoviePlayerController(contentURL: URL.init(string: data.playUrl), with: self.options)
                self.playerView.addSubview((playerTemp?.view)!)
                self.playerView.addSubview(self.changeModeBtn)
                playerTemp?.view.frame = self.playerView.bounds
                playerTemp?.scalingMode = .aspectFit
                let autoresize = UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue
                playerTemp?.view.autoresizingMask = UIView.AutoresizingMask(rawValue: autoresize)
                playerTemp?.prepareToPlay()
                self.player = playerTemp
                self.player?.play()
                self.coverWebView.loadHTMLString(data.mobileIntroduce, baseURL: nil)
            }, onError: { (error) in

            })
        .disposed(by: disposeBag)
        
        IMHelper.shared.getChatRoomInfo(objectID: "\(self.objectID)").asObservable()
        .subscribe(onNext: {[weak self] (model) in
            guard let `self` = self else { return }
            if model.code == 200{
                let info : IMModel = model.data!
                self.isRoomOwner = true
                self.chatRoomUserName = info.username
                self.chatRoomNickName = info.nickname
                self.IMPassword = info.password
                self.chatRoomID = "\(info.roomID)"
                //顺序执行
                let workGroup = DispatchGroup.init()
                let workingQueue = DispatchQueue(label: "loginRoom")
                workGroup.enter()
                workingQueue.async {
                    let error = EMClient.shared()?.login(withUsername: self.chatRoomUserName, password: self.IMPassword)
                    if error != nil{
                        self.showAlert(title: "注册失败", message: "")
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
                workGroup.enter()
                workingQueue.async {
                    self.getUserListData()
                    workGroup.leave()
                }
                // 调度组里的任务都执行完毕
                workGroup.notify(queue: workingQueue) {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                EMClient.shared()?.add(self, delegateQueue: nil)
                //注册聊天室回调
                EMClient.shared()?.roomManager.add(self, delegateQueue: nil)
                //注册消息代理
                EMClient.shared()?.chatManager.add(self, delegateQueue: nil)
                let conversation = EMClient.shared()?.chatManager.getConversation("\(info.roomID)", type: EMConversationTypeChatRoom, createIfNotExist: true)
                self.conversationModel = IMConversationModel.init(aModel: conversation!)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            if model.code == 5001{
                self.blueView.centerX = SCREEN_WIDTH/2
                self.classDetailBtn?.isHidden = true
                self.onlineUserBtn?.isHidden = true
                self.replyView.isUserInteractionEnabled = false
            }
        })
        .disposed(by: disposeBag)
    }
}

extension PlayLiveViewController {
    @objc func exitFullScreen(btn: UIButton){
        btn.isSelected = !btn.isSelected
        if btn.isSelected == true{
            self.playerView.frame = CGRect(x: 0, y: 0, width: SCREEN_HEIGHT, height: SCREEN_WIDTH)
            self.appDelegate.interfaceOrientations = .landscapeRight
            self.replyView.isHidden = true
            self.teacherInfo.isHidden = true
            self.tableView.isHidden = true
            self.changeModeBtn.frame = CGRect(x: SCREEN_HEIGHT - 30/WIDTH_6_SCALE, y: self.playerView.height - 30/WIDTH_6_SCALE, width: 20/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE)
        }else{
            self.playerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 257/WIDTH_6_SCALE)
            self.appDelegate.interfaceOrientations = .portrait
            self.replyView.isHidden = false
            self.teacherInfo.isHidden = false
            self.tableView.isHidden = false
            self.changeModeBtn.frame = CGRect(x: SCREEN_WIDTH - 30/WIDTH_6_SCALE, y: self.playerView.height - 30/WIDTH_6_SCALE, width: 20/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE)
        }
        
    }
    @objc func backBtnClick(){
        self.navigationController?.popViewController()
    }
    @objc func selectItemBtnClick(btn: UIButton){
        if btn.tag == 1000{
            UIView.animate(withDuration: 0.3) {
                self.blueView.centerX = btn.centerX
                self.coverWebView.frame = CGRect(x: 0, y: self.teacherInfo.bottom, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.teacherInfo.bottom - 51/WIDTH_6_SCALE - CGFloat(BOTTOM_HEIGHT))
                self.tableView.frame = CGRect(x: SCREEN_WIDTH, y: self.teacherInfo.bottom, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.teacherInfo.bottom - 51/WIDTH_6_SCALE - CGFloat(BOTTOM_HEIGHT))
                self.userListTableView.frame = CGRect(x: SCREEN_WIDTH * CGFloat(2), y: self.teacherInfo.bottom, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.teacherInfo.bottom - 51/WIDTH_6_SCALE - CGFloat(BOTTOM_HEIGHT))
            }
        }
        if btn.tag == 1001{
            UIView.animate(withDuration: 0.3) {
                self.blueView.centerX = btn.centerX
                self.coverWebView.frame = CGRect(x: -SCREEN_WIDTH, y: self.teacherInfo.bottom, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.teacherInfo.bottom - 51/WIDTH_6_SCALE - CGFloat(BOTTOM_HEIGHT))
                self.tableView.frame = CGRect(x: 0, y: self.teacherInfo.bottom, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.teacherInfo.bottom - 51/WIDTH_6_SCALE - CGFloat(BOTTOM_HEIGHT))
                self.userListTableView.frame = CGRect(x: SCREEN_WIDTH, y: self.teacherInfo.bottom, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.teacherInfo.bottom - 51/WIDTH_6_SCALE - CGFloat(BOTTOM_HEIGHT))
            }
        }
        if btn.tag == 1002{
            UIView.animate(withDuration: 0.3) {
                self.blueView.centerX = btn.centerX
                self.coverWebView.frame = CGRect(x: -SCREEN_WIDTH * CGFloat(2), y: self.teacherInfo.bottom, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.teacherInfo.bottom - 51/WIDTH_6_SCALE - CGFloat(BOTTOM_HEIGHT))
                self.tableView.frame = CGRect(x: -SCREEN_WIDTH, y: self.teacherInfo.bottom, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.teacherInfo.bottom - 51/WIDTH_6_SCALE - CGFloat(BOTTOM_HEIGHT))
                self.userListTableView.frame = CGRect(x: 0, y: self.teacherInfo.bottom, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.teacherInfo.bottom - 51/WIDTH_6_SCALE - CGFloat(BOTTOM_HEIGHT))
            }
        }
    }
    @objc func shareBtnClick(){
        let urlString = "http://www.cei.net.cn/mobile/cdetail?id=\(self.productID)"
        let contentType: SSDKContentType = .webPage
        let url = URL(string: self.shareImg)
        do {
            let data = try Data(contentsOf: url!)
            let image = UIImage(data: data)
            ShareHelper.customShare(url: URL(string: urlString)!, image: image, title: self.teacherNameLab.text, content: "", contentType: contentType)
        }catch let error as NSError {
            HUD.showError(error: error.description)
        }
    }
}

extension PlayLiveViewController: EMClientDelegate, EMChatManagerDelegate, EMChatroomManagerDelegate{
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
        }
    }
    /*!
     *  有成员被加入禁言列表
     *
     *  @param aChatroom        聊天室
     *  @param aMutedMembers    被禁言的成员
     *  @param aMuteExpire      禁言失效时间，暂时不可用
     */
    func chatroomMuteListDidUpdate(_ aChatroom: EMChatroom!, addedMutedMembers aMutes: [Any]!, muteExpire aMuteExpire: Int) {
        
    }
    /*!
     *  有成员被移出禁言列表
     *
     *  @param aChatroom        聊天室
     *  @param aMutedMembers    移出禁言列表的成员
     */
    func chatroomMuteListDidUpdate(_ aChatroom: EMChatroom!, removedMutedMembers aMutes: [Any]!) {
        
    }
    func sendMessageWithBody(aBody: EMMessageBody){
        let message = EMMessage.init(conversationID: self.conversationModel.emModel.conversationId, from: self.chatRoomUserName, to: self.conversationModel.emModel.conversationId, body: aBody, ext: ["nickname":self.chatRoomNickName, "type":"user"])
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
                self.userListArr = model.data?.onlineUserList as! [LiveUserInfo]
                self.onlineNumLab.text = "(\(self.userListArr.count ?? 0)人)"
                self.userListTableView.reloadData()
            }else{
                
            }
        }).disposed(by: disposeBag)
    }
}

extension PlayLiveViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return self.dataArray.count
        }
        if tableView == self.userListTableView {
            return self.userListArr.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(IMMessageTableViewCell.self), for: indexPath) as! IMMessageTableViewCell
            cell.model = nil
            let model = self.dataArray[indexPath.row]
            cell.model = model
            if self.isRoomOwner == false {
                cell.touchBtn.isHidden = true
            }
            return cell
        }
        if tableView == self.userListTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(LiveUserListInfoTableViewCell.self), for: indexPath) as! LiveUserListInfoTableViewCell
            cell.model = self.userListArr[indexPath.row]
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView {
            //赋值cell
            let model = self.dataArray[indexPath.row]
            let transformModel = model.emModel.body as! EMTextMessageBody
            let string = "\(model.emModel.from ?? "")：\(transformModel.text ?? "")"
            return ZuoHeightWithConstrainedWidth(width: SCREEN_WIDTH - 44/WIDTH_6_SCALE - 84/WIDTH_6_SCALE, font: DEF_FontSize_14, str: NSString(cString: string.cString(using: String.Encoding.utf8)!, encoding: String.Encoding.utf8.rawValue)!) + 37/WIDTH_6_SCALE
        }
        if tableView == self.userListTableView {
            return 40/WIDTH_6_SCALE
        }
        return 0
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > self.oldOffset {//向下
            print("向下")
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
        self.oldOffset  = scrollView.contentOffset.y
    }
}

extension PlayLiveViewController{
    func ZuoHeightWithConstrainedWidth(width:CGFloat, font:UIFont, str:NSString)->CGFloat{
        let constraintRect = CGSize(width:width, height:CGFloat.greatestFiniteMagnitude)
        let boundingBox = str.boundingRect(with:constraintRect, options:NSStringDrawingOptions.usesLineFragmentOrigin, attributes:[ NSAttributedString.Key.font:font], context:nil)
        // 返回boundingBox的。高度
        return boundingBox.height
    }
    func getLabelWidth(text: String, font: UIFont, height: CGFloat)-> CGFloat {
        let statusLabelText: NSString = text as NSString
        let size = CGSize(width: CGFloat(MAXFLOAT), height: height)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil).size
        return strSize.width
    }
}

extension PlayLiveViewController: WKUIDelegate, WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        HUD.hideLoading()
        weak var weakSelf = self
        webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';", completionHandler: nil)
        webView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none';", completionHandler: nil)
        webView.evaluateJavaScript("document.body.offsetHeight;") { (any, error) in
            if any is Int, let y = any as? Int {
//                weakSelf?.coverWebView.frame  = CGRect(x: 0, y: weakSelf!.teacherInfo.bottom, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - weakSelf!.teacherInfo.bottom - 51/WIDTH_6_SCALE - CGFloat(y))
            }
        }
    }
}
