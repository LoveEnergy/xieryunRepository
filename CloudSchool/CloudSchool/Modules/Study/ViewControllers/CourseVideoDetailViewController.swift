//
//  CourseVideoDetailViewController.swift
//  CloudSchool
//
//  Created by Maynard on 2018/12/27.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import AliyunPlayerSDK
import ZFPlayer
import RxSwift
import RxCocoa

class CourseVideoDetailViewController: UIViewController {
    var downloadBtnHiddenStatus: Bool = false//默认不隐藏
    @IBOutlet weak var tableView: UITableView!
    //    @IBOutlet weak var playerView: AliyunVodPlayerView!
//    var player: AliVcMediaPlayer = AliVcMediaPlayer()
    var player: ZFPlayerController!
    var manager: ZFAVPlayerManager!
    @IBOutlet weak var playerContainerView: UIView!
    var currentModel: CourseWareModel? {
        didSet {
            StudyManager.shared.currentModel = currentModel
        }
    }
    
    let disposeBag = DisposeBag()
    
    var viewModel: CourseWareListViewModel?
    
    var liveCourseID: Int = 0
    
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
    var userStudyID: String = "" {
        didSet {
            StudyManager.shared.userStudyID = userStudyID
        }
    }
    var controlView: ZFPlayerControlView = {
        let view = ZFPlayerControlView()
        view.fastViewAnimated = true
        return view
    }()
    
    lazy var moreBtn : UIButton = {
        var moreBtn = UIButton.init(frame: CGRect(x: SCREEN_WIDTH - 16/WIDTH_6_SCALE - 25/WIDTH_6_SCALE, y: 20/WIDTH_6_SCALE, width: 25/WIDTH_6_SCALE, height: 25/WIDTH_6_SCALE))
        moreBtn.addTarget(self, action: #selector(moreBtnClick(btn:)), for: .touchUpInside)
        moreBtn.setImage(UIImage.init(named: "gengduo"), for: .normal)
        return moreBtn
    }()
    
    lazy var downListView : DownListView = {
        weak var weakSelf = self
        var downListView = DownListView.init(frame: CGRect(x: 0, y: 45/WIDTH_6_SCALE + CGFloat(NAVI_HEIGHT), width: 50/WIDTH_6_SCALE, height: 30/WIDTH_6_SCALE))
        downListView.centerX = self.moreBtn.centerX
        downListView.downListSelect = {
            HUD.showText(text: "举报成功，平台将会在24小时之内做出处理")
            weakSelf?.downListView.close()
        }
        return downListView
    }()
    
    @IBOutlet weak var numberButton: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        self.downListView.close()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.manager.pause()
        self.downListView.close()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manager = ZFAVPlayerManager()
        player = ZFPlayerController(playerManager: manager, containerView: playerContainerView)
        player.isPauseByEvent = true
        player.controlView = self.controlView
        self.controlView.addSubview(self.moreBtn)
        
        player.shouldAutoPlay = true
        player.playerPlayStateChanged = {[weak self] asset, state in
            guard let `self` = self else { return }
            switch state {
            case .playStatePaused:
                self.recordEndTime()
            case .playStatePlaying:
                if let _ = self.startTime.emptyToNil() {
                    
                } else {
                    print("playing\n")
                    self.recordStartTime()
                }
                break
            case .playStatePlayFailed:
                break
            case .playStatePlayStopped:
                self.recordEndTime()
                break
            default:
                break
            }
        }
                
        configureUI()
        
        guard let viemModel = self.viewModel else {
            return
        }
        
        viemModel.data.asObservable().bind(to: tableView.rx.items(cellIdentifier: R.nib.courseDownloadTableViewCell.identifier, cellType: CourseDownloadTableViewCell.self)) { _, model, cell in
            cell.configure(model: model)
            if self.downloadBtnHiddenStatus == true{
                cell.downloadButton.isHidden = true
            }
        }.disposed(by: disposeBag)
        
        viewModel?.data.asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                if let model = self.viewModel?.data.value.first {
                    self.startPlay(model: model)
                }
            })
        .disposed(by: disposeBag)
        
        viemModel.liveUrl.asObservable()
            .subscribe(onNext: {[weak self] (url) in
                guard let `self` = self else { return }
                if let urlString = url.emptyToNil() {
                    self.playURL(urlString)
                }
            })
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(CourseWareModel.self)
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                if let currentModel = self.currentModel {
                    self.endPlay(model: currentModel)
                }
                self.startPlay(model: model)
            })
            .disposed(by: disposeBag)
//        return;
        DownloadManager.shared.downloadedNumber
        .asObservable()
            .subscribe(onNext: {[weak self] (value) in
                guard let `self` = self else { return }
                self.numberButton.isHidden = value <= 0
                self.numberButton.setTitle(value.string, for: .normal)
            })
        .disposed(by: disposeBag)
    }
    
    func configureUI() {
        tableView.separatorColor = UIColor.lineColor
        tableView.register(R.nib.courseDownloadTableViewCell)
        tableView.backgroundColor = UIColor.backgroundColor
    }
    
    func playURL(_ urlString: String) {
        if let urlRequest = URL(string: urlString) {
            player.assetURL = urlRequest
        }
    }
    func startPlay(model: CourseWareModel) {
        self.currentModel = model
        self.title = model.coursewareName
        print("startplay\n")
        recordStartTime()
        self.playURL(model.standardVideUrl)
        if model.standardVideUrl.isEmpty {
            self.playURL(model.highVideUrl)
        }
    }
    
    func endPlay(model: CourseWareModel) {
        recordEndTime()
    }
    
    func recordStartTime() {
        guard let model = self.currentModel else { return }
        self.startTime = Date().videoTimeFormatterString
    }
    
    func recordEndTime() {
        guard let model = self.currentModel else { return }
        self.endTime = Date().videoTimeFormatterString
//        self.updateTime(model: model)
    }
    
    func pausePlay(model: CourseWareModel) {
//        self.player
    }
    
    func updateTime(model: CourseWareModel) {
        UserHelper.shared.updateCourseProgress(userStudyID: self.userStudyID, courseID: model.courseID.string, startTime: self.startTime, endTime: self.endTime)
        .asObservable()
            .subscribe(onNext: { (result) in
                
            })
        .disposed(by: disposeBag)
        print("updateTime\n")
        self.startTime = ""
        self.endTime = ""
    }

    @IBAction func showDownloadListVC(_ sender: Any) {
        let vc = R.storyboard.my.offlineListViewController()!
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
    
    @objc func moreBtnClick(btn: UIButton){
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            self.downListView.show()
        }else{
            self.downListView.close()
        }
    }
    
    deinit {
        self.recordEndTime()
    }
}
