//
//  FrequencyViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/2/24.
//  Copyright © 2020 CEI. All rights reserved.
// 1. http://fdfs.xmcdn.com/group64/M00/16/D2/wKgMaV1fj3Hwdcz1ALVDXcebnv8219.mp3
// 2. http://fdfs.xmcdn.com/group74/M06/07/99/wKgO0l5X1x_zz6fqACNwAqdsrh8076.mp3
// 3. http://fdfs.xmcdn.com/group61/M02/B0/A2/wKgMZl00KIbQNuadABJ8jIPcBGo780.mp3

import UIKit
import StreamingKit
import IQKeyboardManagerSwift
import RxSwift
import RxCocoa
class FrequencyViewController: UIViewController {
    var finishPlay: Bool = false
    var playNum: Int = 0
    var switchUrl: Bool = false
    var lastOrNext: Int = 2//0.上一曲  1.下一曲  2.顺序播放
    var timer: Timer?
    var teacherNameString: String = ""
    var teacherImgString: String = ""
    var courseID: Int = 0
    var displayLink: CADisplayLink?
    let disposeBag = DisposeBag()
    var data: [CourseWareModel] = [CourseWareModel]()
    var playOver: Bool = false//判断单个音频是否播放完毕
    var userStudyID: String = "" {//学习ID
        didSet {
            StudyManager.shared.userStudyID = userStudyID
        }
    }
    var startTime: String = Date().videoTimeFormatterString {
        didSet {
            StudyManager.shared.startTime = startTime
            print(startTime)
        }
    }
    var endTime: String = Date().videoTimeFormatterString {
        didSet {
            StudyManager.shared.endTime = endTime
            StudyManager.shared.recordEndTime()
        }
    }
    var currentModel: CourseWareModel? {
        didSet {
            StudyManager.shared.currentModel = currentModel
        }
    }
    
    // 是否是第一次播放
    private var isFirstPlay:Bool = true
    // 音频播放器
    lazy var audioPlayer:STKAudioPlayer={
        let audioPlayer = STKAudioPlayer()
        audioPlayer.delegate = self
        return audioPlayer
    }()
    lazy var tableView : UITableView = {
        var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT) - CGFloat(NAVI_HEIGHT) - 51/WIDTH_6_SCALE))
        tableView.backgroundColor = .white
        tableView.tableFooterView = self.footerView
        tableView.tableHeaderView = self.headerView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FrequencyTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(FrequencyTableViewCell.self))
        tableView.separatorStyle = .none
        return tableView
    }()
    lazy var headerView : UIView = {
        var headerView = UIView.init(frame : CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 50/WIDTH_6_SCALE))
        headerView.backgroundColor = .white
        headerView.addSubview(self.iconView)
        self.iconView.centerX = SCREEN_WIDTH/2
        //下载
        let downLoadImg = UIImageView.init(frame: CGRect(x: 34/WIDTH_6_SCALE, y: 30.5/WIDTH_6_SCALE + self.iconView.bottom, width: 10.5/WIDTH_6_SCALE, height: 10.5/WIDTH_6_SCALE))
        downLoadImg.image = UIImage.init(named: "frequency_download")
        headerView.addSubview(downLoadImg)
        let downTitleLab = UILabel.init(frame: CGRect(x: 0, y: downLoadImg.bottom + 11/WIDTH_6_SCALE, width: 60/WIDTH_6_SCALE, height: 12/WIDTH_6_SCALE))
        downTitleLab.centerX = downLoadImg.centerX
        downTitleLab.textAlignment = .center
        downTitleLab.font = DEF_FontSize_10
        downTitleLab.text = "保存课程"
        downTitleLab.backgroundColor = .clear
        downTitleLab.textColor = UIColor.colorWithHex(hex: "BABABA")
        headerView.addSubview(downTitleLab)
        let downBtn = UIButton.init(frame: CGRect(x: downTitleLab.left, y: downLoadImg.top, width: downTitleLab.width, height: downTitleLab.bottom - downLoadImg.top))
        downBtn.backgroundColor = .clear
        downBtn.addTarget(self, action: #selector(downBtnClick), for: .touchUpInside)
        headerView.addSubview(downBtn)
        //定时关闭
        let timingTitleLab = UILabel.init(frame: CGRect(x: SCREEN_WIDTH - downTitleLab.left - downTitleLab.width, y: downTitleLab.top, width: downTitleLab.width, height: downTitleLab.height))
        timingTitleLab.text = "定时关闭"
        timingTitleLab.textAlignment = .center
        timingTitleLab.font = DEF_FontSize_10
        timingTitleLab.backgroundColor = .clear
        timingTitleLab.textColor = UIColor.colorWithHex(hex: "BABABA")
        headerView.addSubview(timingTitleLab)
        let timingImg = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 20/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE))
        timingImg.centerX = timingTitleLab.centerX
        timingImg.centerY = downLoadImg.centerY
        timingImg.image = UIImage.init(named: "frequency_close")
        headerView.addSubview(timingImg)
        let timingBtn = UIButton.init(frame: CGRect(x: timingTitleLab.left, y: timingImg.top, width: timingTitleLab.width, height: timingTitleLab.bottom - timingImg.top))
        timingBtn.backgroundColor = .clear
        timingBtn.addTarget(self, action: #selector(timingBtnClick), for: .touchUpInside)
        headerView.addSubview(timingBtn)
        //音频标题
        self.subjectTitleLab.frame = CGRect(x: downBtn.right + 10/WIDTH_6_SCALE, y: 0, width: timingBtn.left - downBtn.right - 20/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE)
        self.subjectTitleLab.centerY = downLoadImg.centerY
        headerView.addSubview(self.subjectTitleLab)
        self.instructionLab.frame = CGRect(x: 0, y: 0, width: self.subjectTitleLab.width, height: 15/WIDTH_6_SCALE)
        self.instructionLab.centerX = self.subjectTitleLab.centerX
        self.instructionLab.centerY = downTitleLab.centerY
        headerView.addSubview(self.instructionLab)
        //滑块
        self.slider.frame = CGRect(x: 11/WIDTH_6_SCALE, y: 34/WIDTH_6_SCALE + downBtn.bottom, width: SCREEN_WIDTH - 22/WIDTH_6_SCALE, height: 2/WIDTH_6_SCALE)
        headerView.addSubview(self.slider)
        //当前时间
        self.currentTime.frame = CGRect(x: 17/WIDTH_6_SCALE, y: self.slider.bottom + 15.5/WIDTH_6_SCALE, width: 60/WIDTH_6_SCALE, height: 15/WIDTH_6_SCALE)
        headerView.addSubview(self.currentTime)
        //总时间
        self.totalTime.frame = CGRect(x: SCREEN_WIDTH - self.currentTime.width - self.currentTime.left - 30/WIDTH_6_SCALE, y: self.currentTime.top, width: self.currentTime.width + 30/WIDTH_6_SCALE, height: self.currentTime.height)
        headerView.addSubview(self.totalTime)
        self.playBtn.frame = CGRect(x: 0, y: self.slider.bottom + 22.5/WIDTH_6_SCALE, width: 60/WIDTH_6_SCALE, height: 60/WIDTH_6_SCALE)
        self.playBtn.centerX = SCREEN_WIDTH/2
        headerView.addSubview(self.playBtn)
        self.lastOneBtn.frame = CGRect(x: self.playBtn.left - 43.5/WIDTH_6_SCALE - 20/WIDTH_6_SCALE, y: 0, width: 20/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE)
        self.lastOneBtn.centerY = self.playBtn.centerY
        headerView.addSubview(self.lastOneBtn)
        self.nextOneBtn.frame = CGRect(x: SCREEN_WIDTH - self.lastOneBtn.width - self.lastOneBtn.left, y: self.lastOneBtn.top, width: self.lastOneBtn.width, height: self.lastOneBtn.height)
        headerView.addSubview(self.nextOneBtn)
        headerView.addSubview(self.teacherIconImg)
        headerView.addSubview(self.teacherNameLab)
        headerView.addSubview(self.grayLineView)
        self.teacherIconImg.loadImage(string: self.teacherImgString)
        //下部分按钮背景
        let bottomWhiteView = UIView.init(frame: CGRect(x: 0, y: self.grayLineView.bottom, width: SCREEN_WIDTH, height: 64/WIDTH_6_SCALE))
        bottomWhiteView.backgroundColor = .white
        headerView.addSubview(bottomWhiteView)
        self.classDetailBtn.centerX = self.lastOneBtn.centerX - 5/WIDTH_6_SCALE
        self.commentBtn.centerX = self.nextOneBtn.centerX + 5/WIDTH_6_SCALE
        bottomWhiteView.addSubview(self.classDetailBtn)
        bottomWhiteView.addSubview(self.commentBtn)
        bottomWhiteView.addSubview(self.blueLineView)
        self.blueLineView.centerX = self.classDetailBtn.centerX
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: bottomWhiteView.bottom)
        #warning("第二版功能")
        downTitleLab.isHidden = true
        downLoadImg.isHidden = true
        downBtn.isHidden = true
        timingTitleLab.isHidden = true
        timingImg.isHidden = true
        timingBtn.isHidden = true
        bottomWhiteView.isHidden = true
        self.grayLineView.isHidden = true
        self.voiceListBtn.frame = CGRect(x: 40/WIDTH_6_SCALE, y: downLoadImg.top, width: 80/WIDTH_6_SCALE, height: downTitleLab.bottom - downLoadImg.top)
        headerView.addSubview(self.voiceListBtn)
        return headerView
    }()
    //分享
    lazy var shareBtn : UIButton = {
        var shareBtn = UIButton.init()
        shareBtn.setBackgroundColor(UIColor.clear, forState: .normal)
        shareBtn.setImage(UIImage.init(named: "blue_share"), for: .normal)
        shareBtn.addTarget(self, action: #selector(shareBtnClick), for: .touchUpInside)
        return shareBtn
    }()
    lazy var subjectTitleLab : UILabel = {
        var subjectTitleLab = UILabel.init()
        subjectTitleLab.font = DEF_FontSize_18
        subjectTitleLab.backgroundColor = .clear
        subjectTitleLab.textColor = .black
        subjectTitleLab.textAlignment = .center
        subjectTitleLab.text = "西尔环境"
        return subjectTitleLab
    }()
    lazy var iconView : UIImageView = {
        var iconView = UIImageView.init(frame: CGRect(x: 0, y: 30/WIDTH_6_SCALE, width: 200/WIDTH_6_SCALE, height: 200/WIDTH_6_SCALE))
        iconView.backgroundColor = UIColor.gray
        iconView.layer.cornerRadius = 4
        iconView.layer.masksToBounds = true
        return iconView
    }()
    lazy var instructionLab : UILabel = {
        var instructionLab = UILabel.init()
        instructionLab.font = DEF_FontSize_12
        instructionLab.backgroundColor = .clear
        instructionLab.textColor = .black
        instructionLab.textAlignment = .center
        instructionLab.text = "内容介绍"
        return instructionLab
    }()
    // 进度条
    lazy var slider:UISlider = {
        let slider = UISlider(frame: CGRect.zero)
        slider.maximumTrackTintColor = UIColor.lightGray
        slider.minimumTrackTintColor = UIColor.blue
        // 滑块滑动停止后才触发ValueChanged事件
    //        slider.isContinuous = false
        slider.addTarget(self, action: #selector(sliderChange(slider:)), for: UIControl.Event.valueChanged)
        slider.addTarget(self, action: #selector(sliderDragUp(slider:)), for: UIControl.Event.touchUpInside)
        slider.setThumbImage(UIImage.init(named: "frequency_progress"), for: .normal)
        return slider
    }()
    
    // 当前时间
    lazy var currentTime:UILabel = {
        let currentTime = UILabel()
        currentTime.font = UIFont.systemFont(ofSize: 12)
        currentTime.textColor = UIColor.colorWithHex(hex: "0378FD")
        currentTime.textAlignment = NSTextAlignment.left
        currentTime.text = "00:00"
        return currentTime
    }()
    // 总时间
    lazy var totalTime:UILabel = {
        let totalTime = UILabel()
        totalTime.font = UIFont.systemFont(ofSize: 12)
        totalTime.textColor = UIColor.colorWithHex(hex: "0378FD")
        totalTime.textAlignment = NSTextAlignment.right
        totalTime.text = "00:00"
        return totalTime
    }()
    //上一曲
    lazy var lastOneBtn : UIButton = {
        var lastOneBtn = UIButton.init()
        lastOneBtn.setBackgroundColor(UIColor.clear, forState: .normal)
        lastOneBtn.addTarget(self, action: #selector(lastOneBtnClick), for: .touchUpInside)
        lastOneBtn.setImage(UIImage.init(named: "frequency_last"), for: .normal)
        return lastOneBtn
    }()
    //下一曲
    lazy var nextOneBtn : UIButton = {
        var nextOneBtn = UIButton.init()
        nextOneBtn.setBackgroundColor(UIColor.clear, forState: .normal)
        nextOneBtn.addTarget(self, action: #selector(nextOneBtnClick), for: .touchUpInside)
        nextOneBtn.setImage(UIImage.init(named: "frequency_next"), for: .normal)
        return nextOneBtn
    }()
    lazy var playBtn : UIButton = {
        var playBtn = UIButton.init()
        playBtn.addTarget(self, action: #selector(playBtnClick(btn:)), for: .touchUpInside)
        playBtn.setImage(UIImage.init(named: "frequency_stop"), for: .normal)
        playBtn.setImage(UIImage(named: "frequency_play"), for: UIControl.State.selected)
        return playBtn
    }()
    //讲师头像
    lazy var teacherIconImg : UIImageView = {
        var teacherIconImg = UIImageView.init(frame: CGRect(x: 13.5/WIDTH_6_SCALE, y: self.playBtn.bottom + 33.5/WIDTH_6_SCALE, width: 46.5/WIDTH_6_SCALE, height: 46.5/WIDTH_6_SCALE))
        teacherIconImg.layer.cornerRadius = 4
        teacherIconImg.layer.masksToBounds = true
        teacherIconImg.backgroundColor = UIColor.lightGray
//        teacherIconImg.loadImage(string: self.teacherNameString)
        return teacherIconImg
    }()
    lazy var teacherNameLab : UILabel = {
        var teacherNameLab = UILabel.init(frame: CGRect(x: self.teacherIconImg.right + 12/WIDTH_6_SCALE, y: 0, width: 100/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE))
        teacherNameLab.centerY = self.teacherIconImg.centerY
        teacherNameLab.font = DEF_FontSize_15
        teacherNameLab.backgroundColor = .clear
        teacherNameLab.textColor = .black
        teacherNameLab.textAlignment = .left
        teacherNameLab.text = self.teacherNameString
        return teacherNameLab
    }()
    lazy var grayLineView : UIView = {
        var grayLineView = UIView.init(frame: CGRect(x: 0, y: self.teacherIconImg.bottom + 7.5/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 10/WIDTH_6_SCALE))
        grayLineView.backgroundColor = UIColor.colorWithHex(hex: "FAFAFA")
        return grayLineView
    }()
    lazy var blueLineView : UIView = {
        var blueLineView = UIView.init(frame: CGRect(x: 0, y: self.classDetailBtn.bottom + 3, width: 25.5/WIDTH_6_SCALE, height: 3))
        blueLineView.backgroundColor = UIColor.colorWithHex(hex: "0378FD")
        return blueLineView
    }()
    lazy var classDetailBtn : UIButton = {
        var classDetailBtn = UIButton.init(frame: CGRect(x: 0, y: 13/WIDTH_6_SCALE, width: 100/WIDTH_6_SCALE, height: 26/WIDTH_6_SCALE))
        classDetailBtn.setTitle("课程详情", for: .normal)
        classDetailBtn.setTitleColor(UIColor.black, for: .normal)
        classDetailBtn.titleLabel?.font = DEF_FontSize_18
        classDetailBtn.setBackgroundColor(UIColor.clear, forState: .normal)
        classDetailBtn.addTarget(self, action: #selector(switchBtnClick(btn:)), for: .touchUpInside)
        return classDetailBtn
    }()
    lazy var commentBtn : UIButton = {
        var commentBtn = UIButton.init(frame: CGRect(x: 0, y: self.classDetailBtn.top, width: self.classDetailBtn.width, height: self.classDetailBtn.height))
        commentBtn.setTitle("评论", for: .normal)
        commentBtn.setTitleColor(UIColor.black, for: .normal)
        commentBtn.titleLabel?.font = DEF_FontSize_18
        commentBtn.setBackgroundColor(UIColor.clear, forState: .normal)
        commentBtn.addTarget(self, action: #selector(switchBtnClick(btn:)), for: .touchUpInside)
        return commentBtn
    }()
    lazy var backBtn : UIButton = {
        var backBtn = UIButton.init(frame: CGRect(x: 10, y: 30, width: 20/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE))
        backBtn.setImage(UIImage.init(named: "clear_back"), for: .normal)
        backBtn.setTitleColor(.black, for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        return backBtn
    }()
    lazy var footerView : UIView = {
        var footerView = UIView.init(frame : CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0/WIDTH_6_SCALE))
        footerView.backgroundColor = .white
        return footerView
    }()
    lazy var replyView: ReplyViewWithNav = {
        var replyView = ReplyViewWithNav.init(frame: CGRect(x: 0, y: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT) - CGFloat(NAVI_HEIGHT) - 51/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 51/WIDTH_6_SCALE))
        replyView.replyViewBlock = {(sendString, sendView) in
//            let body = EMTextMessageBody.init(text: sendString!)
//            self.sendMessageWithBody(aBody: body!)
        }
        return replyView
    }()
    lazy var listView: FrequencyListView = {
        var listView = FrequencyListView.init(frame: self.view.bounds, array: self.data)
        listView.dismissViewBlock = {
            UIView.animate(withDuration: 0.15, animations: {
                self.listView.alpha = 0
            }) { (Bool) in
                self.listView.removeFromSuperview()
            }
        }
        listView.selectVoiceBlock = {(selectVoice: Int) in
            self.playNum = selectVoice
            StudyManager.shared.currentModel = self.data[self.playNum]
            self.audioPlayer.play(URL.init(string: self.data[self.playNum].standardVideUrl)!)
            self.totalTime.text = self.data[self.playNum].duration
            self.playBtn.isSelected = true
            self.starTimer()
            self.isFirstPlay = false
            self.switchUrl = true
            self.lastOrNext = 1
            UIView.animate(withDuration: 0.15, animations: {
                self.listView.alpha = 0
            }) { (Bool) in
                self.listView.removeFromSuperview()
            }
        }
        return listView
    }()
    lazy var voiceListBtn : UIButton = {
        var voiceListBtn = UIButton.init()
        voiceListBtn.setTitle("音频列表", for: .normal)
        voiceListBtn.setTitleColor(UIColor.colorWithHex(hex: "BABABA"), for: .normal)
        voiceListBtn.titleLabel?.font = DEF_FontSize_14
        voiceListBtn.setBackgroundColor(UIColor.clear, forState: .normal)
        voiceListBtn.addTarget(self, action: #selector(voiceListBtnClick), for: .touchUpInside)
        return voiceListBtn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "音频"
        self.view.addSubview(self.tableView)
        let barItem = UIBarButtonItem.init(customView: self.backBtn)
        self.navigationItem.leftBarButtonItem = barItem
//        self.view.addSubview(self.replyView)
        NotificationCenter.default.addObserver(self, selector: #selector(configLockScreenPlay) , name:UIApplication.didEnterBackgroundNotification, object: nil)
        try! AVAudioSession.sharedInstance().setCategory(.playback);
        try! AVAudioSession.sharedInstance().setActive(true)
        loadData()
        
        self.shareBtn.frame = CGRect(x: 0, y: 0, width: 20/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE)
        self.shareBtn.isHidden = true
        let rightItem = UIBarButtonItem.init(customView: self.shareBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
    }
    override func viewDidAppear(_ animated:Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.recordEndTime()
    }
}

extension FrequencyViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FrequencyTableViewCell.self), for: indexPath) as! FrequencyTableViewCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let string = "培养了大批生态环境执法专业化人才，逐步建立起中国的生态环境执法精英人才库，对带动整个生态环境执法队伍，提升能力建设具有重要意义。"
        return ZuoHeightWithConstrainedWidth(width: SCREEN_WIDTH - 55/WIDTH_6_SCALE - 70.5/WIDTH_6_SCALE, font: DEF_FontSize_14, str: NSString(cString: string.cString(using: String.Encoding.utf8)!, encoding: String.Encoding.utf8.rawValue)!) + 37/WIDTH_6_SCALE
    }
}

extension FrequencyViewController{
    @objc func voiceListBtnClick(){
        self.listView.showView()
    }
    @objc func configLockScreenPlay(){
        
    }
    @objc func downBtnClick(){
        print("点击下载保存")
    }
    @objc func timingBtnClick(){
        print("点击定时关闭")
    }
    @objc func sliderChange(slider: UISlider) {
        print("slider.value = %d",slider.value)
        audioPlayer.seek(toTime: Double(slider.value * Float(self.audioPlayer.duration)))
    }
    
    @objc func sliderDragUp(slider: UISlider) {
        print("value:(sender.value)")
    }
    
    @objc func lastOneBtnClick(){
        if self.playNum > 0{
            self.lastOrNext = 0
            self.playBtn.isSelected = true
            self.playNum = self.playNum - 1
            StudyManager.shared.currentModel = self.data[self.playNum]
            self.audioPlayer.play(URL.init(string: self.data[self.playNum].standardVideUrl)!)
            self.totalTime.text = self.data[self.playNum].duration
            self.switchUrl = true
        }else{
            HUD.showText(text: "无更多音频")
        }
    }
    
    @objc func nextOneBtnClick(){
        if self.playNum >= self.data.count - 1{
            HUD.showText(text: "无更多音频")
        }else{
            self.lastOrNext = 1
            self.playBtn.isSelected = true
            self.playNum = self.playNum + 1
            StudyManager.shared.currentModel = self.data[self.playNum]
            self.audioPlayer.play(URL.init(string: self.data[self.playNum].standardVideUrl)!)
            self.totalTime.text = self.data[self.playNum].duration
            self.switchUrl = true
        }
    }
    
    @objc func shareBtnClick(){
        
    }
    @objc func playBtnClick(btn: UIButton){
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            if isFirstPlay {
                self.currentModel = self.data[self.playNum]
                self.audioPlayer.play(URL.init(string: self.data[self.playNum].standardVideUrl)!)
                self.totalTime.text = self.data[self.playNum].duration
                starTimer()
                isFirstPlay = false
                self.playBtn.isSelected = true
            }else {
                starTimer()
                self.audioPlayer.resume()
                if self.playOver {
                    self.currentModel = self.data[self.playNum]
                    self.audioPlayer.play(URL.init(string: self.data[self.playNum].standardVideUrl)!)
                    self.totalTime.text = self.data[self.playNum].duration
                }
            }
            self.recordStartTime()
        }else{
            removeTimer()
            self.audioPlayer.pause()
            self.recordEndTime()
        }
    }
    func getMMSSFromSS(duration:Int)->(String){
        var min = duration / 60
        let sec = duration % 60
        var hour : Int = 0
        if min >= 60 {
            hour = min / 60
            min = min % 60
            if hour > 0 {
                return String(format: "%02d:%02d:%02d", hour, min, sec)
            }
        }
        return String(format: "%02d:%02d", min, sec)
    }
    func starTimer() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateCurrentLabel))
        displayLink?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }
        
    func removeTimer() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc func updateCurrentLabel() {
        let currentTime:Int = Int(self.audioPlayer.progress)
        self.currentTime.text = getMMSSFromSS(duration: currentTime)
        let progress = Float(self.audioPlayer.progress / self.audioPlayer.duration)
        slider.value = progress
    }
    @objc func backBtnClick(){
        self.audioPlayer.pause()
        self.navigationController?.popViewController()
    }
    @objc func switchBtnClick(btn: UIButton){
        if btn == self.classDetailBtn{
            UIView.animate(withDuration: 0.3) {
                self.blueLineView.centerX = self.classDetailBtn.centerX
            }
        }else{
            UIView.animate(withDuration: 0.3) {
                self.blueLineView.centerX = self.commentBtn.centerX
            }
        }
    }
    
    func loadData() {
        UserHelper.shared.getCourseWareList(courseID: "\(self.courseID)")
            .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                if list.code == 200{
                    self.data = list.data
                    self.iconView.loadImage(string: self.data[0].smallPhotoUrl)
                    StudyManager.shared.currentModel = self.data[0]
                    self.playBtnClick(btn:self.playBtn)
                }
                }, onError: { (error) in
            })
            .disposed(by: disposeBag)
    }
    
    func recordEndTime() {
        self.endTime = Date().videoTimeFormatterString
    }
    func recordStartTime() {
        self.startTime = Date().videoTimeFormatterString
    }
}
extension FrequencyViewController: STKAudioPlayerDelegate{
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didStartPlayingQueueItemId queueItemId: NSObject) {
        
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishBufferingSourceWithQueueItemId queueItemId: NSObject) {//完成缓冲
        
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, stateChanged state: STKAudioPlayerState, previousState: STKAudioPlayerState) {
        
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishPlayingQueueItemId queueItemId: NSObject, with stopReason: STKAudioPlayerStopReason, andProgress progress: Double, andDuration duration: Double) {//当前音频播放完毕
        if self.switchUrl == false{
//            if self.playNum >= self.data.count - 1{
//                HUD.showText(text: "无更多音频")
            self.playBtn.isSelected = false
            self.playOver = true
            self.recordEndTime()
//            }else{
//                self.playNum = self.playNum + 1
//                StudyManager.shared.currentModel = self.data[self.playNum]
//                self.audioPlayer.play(URL.init(string: self.data[self.playNum].standardVideUrl)!)
//                self.totalTime.text = self.data[self.playNum].duration
//                self.recordEndTime()
//                self.recordStartTime()
//            }
        }else{
            if self.lastOrNext == 2{
                if self.playNum == self.data.count - 1{
                    HUD.showText(text: "无更多音频")
                    self.playBtn.isSelected = false
                    self.recordEndTime()
                }
            }
            if self.lastOrNext == 1{//下一曲
                self.lastOrNext = 2
                self.recordEndTime()
                self.recordStartTime()
            }
            if self.lastOrNext == 0{//上一曲
                self.lastOrNext = 2
                self.recordEndTime()
                self.recordStartTime()
            }
            
        }
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, unexpectedError errorCode: STKAudioPlayerErrorCode) {
        
    }
}
extension FrequencyViewController{
    func ZuoHeightWithConstrainedWidth(width:CGFloat, font:UIFont, str:NSString)->CGFloat{
        let constraintRect = CGSize(width:width, height:CGFloat.greatestFiniteMagnitude)
        let boundingBox = str.boundingRect(with:constraintRect, options:NSStringDrawingOptions.usesLineFragmentOrigin, attributes:[ NSAttributedString.Key.font:font], context:nil)
        // 返回boundingBox的。高度
        return boundingBox.height
    }
}
