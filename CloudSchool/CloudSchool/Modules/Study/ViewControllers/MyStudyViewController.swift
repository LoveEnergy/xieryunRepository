//
//  MyStudyViewController.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/13.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import QMUIKit

class MyStudyViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: QMUISegmentedControl!
    @IBOutlet weak var scrollView: NestedListView!
    var viewModel: MyStudyViewModel = MyStudyViewModel()
    var classViewModel: MyClassViewModel = MyClassViewModel()
    var liveViewModel: MyLiveViewModel = MyLiveViewModel()
    var viewExpiredModel: MyStudyExpiredViewModel = MyStudyExpiredViewModel()
    var classExpiredViewModel: MyClassExpiredViewModel = MyClassExpiredViewModel()
    var liveExpiredViewModel: MyLiveExpiredViewModel = MyLiveExpiredViewModel()
    let disposeBag: DisposeBag = DisposeBag()
    var studyExpiredArr: [ClassModel] = [ClassModel]()
    var classExpiredArr: [StudyModel] = [StudyModel]()
    var liveExpiredArr: [ClassModel] = [ClassModel]()
    var blueLineY: CGFloat = 0.0{
        didSet{
            self.blueLineView.frame = CGRect(x: self.blueLineView.x, y: blueLineY, width: self.blueLineView.width, height: self.blueLineView.height)
        }
    }
    var productType: Int = 0{
        didSet{
            if self.productType == 3{
                self.currentIndex = 2
            }
            if self.productType == 5 {
                self.currentIndex = 4
            }
        }
    }
    var currentIndex: Int = 0 {
        didSet {
            if currentIndex == 0 {
                self.segmentControl.selectedSegmentIndex = 0
                UIView.animate(withDuration: 0.3) {
                    self.blueLineView.centerX = self.learningBtn.centerX
                }
            }
            if currentIndex == 1 {
                self.segmentControl.selectedSegmentIndex = 0
                UIView.animate(withDuration: 0.3) {
                    self.blueLineView.centerX = self.expiredBtn.centerX
                }
            }
            if currentIndex == 2 {
                self.segmentControl?.selectedSegmentIndex = 1
                UIView.animate(withDuration: 0.3) {
                    self.blueLineView.centerX = self.learningBtn.centerX
                }
            }
            if currentIndex == 3 {
                self.segmentControl.selectedSegmentIndex = 1
                UIView.animate(withDuration: 0.3) {
                    self.blueLineView.centerX = self.expiredBtn.centerX
                }
            }
            if currentIndex == 4 {
                self.segmentControl?.selectedSegmentIndex = 2
                UIView.animate(withDuration: 0.3) {
                    self.blueLineView.centerX = self.learningBtn.centerX
                }
            }
            if currentIndex == 5 {
                self.segmentControl.selectedSegmentIndex = 2
                UIView.animate(withDuration: 0.3) {
                    self.blueLineView.centerX = self.expiredBtn.centerX
                }
            }
            self.scrollView?.scrollToPage(currentIndex)
        }
    }
    
    lazy var courseLearningTableView: BaseListTableView = { () -> BaseListTableView<MyStudyViewModel> in
        let tableView = BaseListTableView(viewModel: viewModel)
        tableView.emptyDataSetSource = self
        return tableView
    }()
    lazy var classLearningTableView: BaseListTableView = { () -> BaseListTableView<MyClassViewModel> in
        let tableView = BaseListTableView(viewModel: classViewModel)
        tableView.emptyDataSetSource = self
        return tableView
    }()
    lazy var liveLearningTableView: BaseListTableView = { () -> BaseListTableView<MyLiveViewModel> in
        let tableView = BaseListTableView(viewModel: liveViewModel)
        tableView.emptyDataSetSource = self
        return tableView
    }()
    lazy var courseExpiredTableView: UITableView = {
        let tableView = UITableView.init()
        tableView.emptyDataSetSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 110
        tableView.register(StudyExpiredTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(StudyExpiredTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    lazy var classExpiredTableView: UITableView = {
        let tableView = UITableView.init()
        tableView.emptyDataSetSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 110
        tableView.register(ClassExpiredTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(ClassExpiredTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    lazy var liveExpiredTableView: UITableView = {
        let tableView = UITableView.init()
        tableView.rowHeight = 110
        tableView.emptyDataSetSource = self
        tableView.register(LiveExpiredTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(LiveExpiredTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func encode(with coder: NSCoder) {
        self.encode(with: coder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector:#selector(myClassSelect(noti:)), name: NSNotification.Name(rawValue: "goForMyClass"), object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(upDataClassData(noti:)), name: NSNotification.Name(rawValue: "updataData"), object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(myLiveSelect(noti:)), name: NSNotification.Name(rawValue: "goForMyLive"), object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addResponse()
        LoginHelper.shared.currentUser
        .asObservable()
            .subscribe(onNext: {[weak self] (message) in
                guard let `self` = self else { return }
                self.loadData()
            })
        .disposed(by: disposeBag)
        loadData()
    }
    func loadData(){
        //我的直播课堂(已过期)
        UserHelper.shared.getLiveList(type: "3", isExpire: "1")
        .asObservable().subscribe(onNext: {[weak self] (list) in
            guard let `self` = self else { return }
            if list.code == 200{
                self.liveExpiredArr = list.data
            }else{
                self.liveExpiredArr.removeAll()
            }
            self.liveExpiredTableView.reloadData()
            }, onError: { (error) in
                
        }).disposed(by: disposeBag)
        //我的班级(已过期)
        UserHelper.shared.getStudyList(type: "1", isExpire: "1")
        .asObservable().subscribe(onNext: {[weak self] (list) in
            if list.code == 200{
                self?.classExpiredArr = list.data
            }else{
                self?.classExpiredArr.removeAll()
            }
            self?.classExpiredTableView.reloadData()
            }, onError: { (error) in
                
            }).disposed(by: disposeBag)
        //我的课程(已过期)
        UserHelper.shared.getClassList(type: "2", isExpire: "1")
        .asObservable().subscribe(onNext: {[weak self] (list) in
            guard let `self` = self else { return }
            if list.code == 200{
                self.studyExpiredArr = list.data
            }else{
                self.studyExpiredArr.removeAll()
            }
            self.courseExpiredTableView.reloadData()
            }, onError: { (error) in
                    
            }).disposed(by: disposeBag)
    }
    deinit {
        // 记得移除通知监听
        // 如果不需要的话,记得把相应的通知注册给取消,避免内存浪费或崩溃
        NotificationCenter.default.removeObserver(self)
    }
    func configureUI() {
        title = "我的学习"
        courseLearningTableView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: scrollView.pheight)
        classLearningTableView.frame = CGRect(x: kScreenWidth * 2, y: 0, width: kScreenWidth, height: scrollView.pheight)
        liveLearningTableView.frame = CGRect(x: kScreenWidth * 4, y: 0, width: kScreenWidth, height: scrollView.pheight)
        
        courseExpiredTableView.frame = CGRect(x: kScreenWidth, y: 0, width: kScreenWidth, height: scrollView.pheight)
        classExpiredTableView.frame = CGRect(x: kScreenWidth * 3, y: 0, width: kScreenWidth, height: scrollView.pheight)
        liveExpiredTableView.frame = CGRect(x: kScreenWidth * 5, y: 0, width: kScreenWidth, height: scrollView.pheight)
        
        scrollView.nestDelegate = self
        scrollView.contentSize = CGSize(width: kScreenWidth * 6, height: scrollView.pheight)
        scrollView.totalPage = 6
        scrollView.scrollToPage(0)
        scrollView.changedPage = { index in
            self.currentIndex = index
        }
        
        segmentControl.updateSegmentedUI(withTintColor: UIColor(hex: "1fa2f8"), selectedTextColor: UIColor.white, fontSize: UIFont.systemFont(ofSize: 16))
        if #available(iOS 13, *) {
            //高于 iOS13
            print("高于13")
            self.segmentControl.backgroundColor = .white
        } else {
            //低于 iOS 13
            print("低于13")
        }
        if self.productType == 3{
            self.currentIndex = 2
        }
        if self.productType == 5 {
            self.currentIndex = 4
        }
        self.learningBtn.frame = CGRect(x: SCREEN_WIDTH/2 - 80/WIDTH_6_SCALE, y: self.segmentControl.bottom + 10/WIDTH_6_SCALE, width: 60/WIDTH_6_SCALE, height: 40/WIDTH_6_SCALE)
        self.expiredBtn.frame = CGRect(x: SCREEN_WIDTH/2 + 20/WIDTH_6_SCALE, y: self.learningBtn.top, width: self.learningBtn.width, height: self.learningBtn.height)
        self.blueLineY = self.learningBtn.frame.maxY
        self.view.addSubview(self.learningBtn)
        self.view.addSubview(self.expiredBtn)
        self.view.addSubview(self.blueLineView)
    }
    
    lazy var learningBtn : UIButton = {
        var learningBtn = UIButton.init()
        learningBtn.setTitle("学习中", for: .normal)
        learningBtn.setTitleColor(UIColor.colorWithHex(hex: "0378FD"), for: .normal)
        learningBtn.titleLabel?.font = DEF_FontSize_14
        learningBtn.setBackgroundColor(UIColor.white, forState: .normal)
        learningBtn.adjustsImageWhenHighlighted = false
        learningBtn.addTarget(self, action: #selector(learningBtnClick), for: .touchUpInside)
        return learningBtn
    }()
    lazy var expiredBtn : UIButton = {
        var expiredBtn = UIButton.init()
        expiredBtn.setTitle("已过期", for: .normal)
        expiredBtn.setTitleColor(UIColor.colorWithHex(hex: "0378FD"), for: .normal)
        expiredBtn.titleLabel?.font = DEF_FontSize_14
        expiredBtn.setBackgroundColor(UIColor.white, forState: .normal)
        expiredBtn.adjustsImageWhenHighlighted = false
        expiredBtn.addTarget(self, action: #selector(expiredBtnClick), for: .touchUpInside)
        return expiredBtn
    }()
    lazy var blueLineView : UIView = {
        weak var weakSelf = self
        var lineView = UIView.init(frame: CGRect(x: 0, y: weakSelf!.learningBtn.bottom + 1, width: weakSelf!.learningBtn.width - 10/WIDTH_6_SCALE, height: 2/WIDTH_6_SCALE))
        lineView.centerX = weakSelf!.learningBtn.centerX
        lineView.backgroundColor = UIColor.colorWithHex(hex: "0378FD")
        return lineView
    }()
    func addResponse() {
        segmentControl.rx.controlEvent(UIControl.Event.valueChanged)
            .map { () -> Int in
                return self.segmentControl.selectedSegmentIndex
            }.subscribe(onNext: {[weak self] (value) in
                guard let `self` = self else { return }
                if value == 0{
                    self.currentIndex = 0
                }
                if value == 1{
                    self.currentIndex = 2
                }
                if value == 2{
                    self.currentIndex = 4
                }
                UIView.animate(withDuration: 0.3) {
                    self.blueLineView.centerX = self.learningBtn.centerX
                }
            })
        .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        classViewModel.loadData()
        viewModel.loadData()
        liveViewModel.loadData()
    }
    
    @objc func myClassSelect(noti: Notification){
        let userInfo = noti.userInfo as! [String: AnyObject]
        self.productType = userInfo["productType"] as! Int
        self.learningBtn.frame = CGRect(x: SCREEN_WIDTH/2 - 80/WIDTH_6_SCALE, y: self.segmentControl?.bottom ?? 0 + 10/WIDTH_6_SCALE, width: 60/WIDTH_6_SCALE, height: 40/WIDTH_6_SCALE)
        self.expiredBtn.frame = CGRect(x: SCREEN_WIDTH/2 + 20/WIDTH_6_SCALE, y: self.learningBtn.top, width: self.learningBtn.width, height: self.learningBtn.height)
        self.blueLineView.frame = CGRect(x: 0, y: self.learningBtn.bottom + 1, width: self.learningBtn.width - 10/WIDTH_6_SCALE, height: 2/WIDTH_6_SCALE)
    }
    
    @objc func myLiveSelect(noti: Notification){
        let userInfo = noti.userInfo as! [String: AnyObject]
        self.productType = userInfo["productType"] as! Int
        self.learningBtn.frame = CGRect(x: SCREEN_WIDTH/2 - 80/WIDTH_6_SCALE, y: self.segmentControl?.bottom ?? 0  + 10/WIDTH_6_SCALE, width: 60/WIDTH_6_SCALE, height: 40/WIDTH_6_SCALE)
        self.expiredBtn.frame = CGRect(x: SCREEN_WIDTH/2 + 20/WIDTH_6_SCALE, y: self.learningBtn.top, width: self.learningBtn.width, height: self.learningBtn.height)
        self.blueLineView.frame = CGRect(x: 0, y: self.learningBtn.bottom + 1, width: self.learningBtn.width - 10/WIDTH_6_SCALE, height: 2/WIDTH_6_SCALE)
        self.blueLineView.centerX = self.learningBtn.centerX
    }
    
    @objc func upDataClassData(noti: Notification){
        self.studyExpiredArr.removeAll()
        self.liveExpiredArr.removeAll()
        self.classExpiredArr.removeAll()
        self.loadData()
    }
    
    @objc func learningBtnClick(){
        if self.segmentControl.selectedSegmentIndex == 0 {
            self.scrollView.scrollToPage(0)
        }
        if self.segmentControl.selectedSegmentIndex == 1 {
            self.scrollView.scrollToPage(2)
        }
        if self.segmentControl.selectedSegmentIndex == 2 {
            self.scrollView.scrollToPage(4)
        }
        UIView.animate(withDuration: 0.3) {
            self.blueLineView.centerX = self.learningBtn.centerX
        }
    }
    
    @objc func expiredBtnClick(){
        if self.segmentControl.selectedSegmentIndex == 0 {
            self.scrollView.scrollToPage(1)
        }
        if self.segmentControl.selectedSegmentIndex == 1 {
            self.scrollView.scrollToPage(3)
        }
        if self.segmentControl.selectedSegmentIndex == 2 {
            self.scrollView.scrollToPage(5)
        }
        UIView.animate(withDuration: 0.3) {
            self.blueLineView.centerX = self.expiredBtn.centerX
        }
    }
    
    func afterDelayCourse(){
        //我的课程(已过期)
        UserHelper.shared.getClassList(type: "2", isExpire: "1")
        .asObservable().subscribe(onNext: {[weak self] (list) in
            guard let `self` = self else { return }
            if list.code == 200{
                self.studyExpiredArr = list.data
            }else{
                self.studyExpiredArr.removeAll()
            }
            self.courseExpiredTableView.reloadData()
            }, onError: { (error) in
                    
            }).disposed(by: disposeBag)
        viewModel.loadData()
    }
}

extension MyStudyViewController: NestedListViewDelegate {
    func createListView(page: Int) -> UIScrollView {
        switch page {
        case 0:
            return courseLearningTableView
        case 1:
            return courseExpiredTableView
        case 2:
            return classLearningTableView
        case 3:
            return classExpiredTableView
        case 4:
            return liveLearningTableView
        default:
            return liveExpiredTableView
        }
    }
}

import DZNEmptyDataSet
extension MyStudyViewController: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return R.image.common_empty_image()!
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributeString = NSAttributedString(string: "没有相关内容", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),
                                                                                            NSAttributedString.Key.foregroundColor:UIColor.init(hexString: "555555")])
        return attributeString
    }
}

extension MyStudyViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        if tableView == self.courseExpiredTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(StudyExpiredTableViewCell.self), for: indexPath) as! StudyExpiredTableViewCell
            cell.model = self.studyExpiredArr[indexPath.row]
            cell.supplyDelayBlock = {
                let alert = UIAlertController(title: "我们将免费为您延长30天的课程有效期，课程只能允许延期一次", message: nil, preferredStyle: .alert)
                let sure = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
                    HUD.loading(text: "")
                    UserHelper.shared.makeCourseDelay(userStudyID: self.studyExpiredArr[indexPath.row].userStudyID).asObservable().subscribe(onNext: {[weak self] (list) in
                        HUD.hideLoading()
                        guard let `self` = self else { return }
                        if list.code == 200{
                            self.afterDelayCourse()
                        }else{
                            HUD.showText(text: list.message ?? "")
                        }
                        }, onError: { (error) in
                            HUD.hideLoading()
                            HUD.showError(error: error.localizedDescription)
                    }).disposed(by: self.disposeBag)
                }
                let cancel = UIAlertAction(title: "取消", style: .cancel) { (UIAlertAction) in
                    print("you selected cancel")
                }
                alert.addAction(sure)
                alert.addAction(cancel)
                alert.show()
            }
            cell.supplyBuyAgainBlock = {
                let detailVC = R.storyboard.home.courseDetailViewController()!
                detailVC.productID = "\(self.studyExpiredArr[indexPath.row].productID)"
                detailVC.productType = 1//在线课程
                CurrentControllerHelper.pushViewController(viewController: detailVC)
            }
            return cell
        }
        if tableView == self.classExpiredTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ClassExpiredTableViewCell.self), for: indexPath) as! ClassExpiredTableViewCell
            if self.classExpiredArr.count != 0{
                cell.model = self.classExpiredArr[indexPath.row]
            }
            return cell
        }
        if tableView == self.liveExpiredTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(LiveExpiredTableViewCell.self), for: indexPath) as! LiveExpiredTableViewCell
            if self.liveExpiredArr.count != 0{
                cell.model = self.liveExpiredArr[indexPath.row]
            }
            return cell
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.courseExpiredTableView {
            return self.studyExpiredArr.count
        }
        if tableView == self.classExpiredTableView{
            return self.classExpiredArr.count
        }
        if tableView == self.liveExpiredTableView{
            return self.liveExpiredArr.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.liveExpiredTableView {
            let model = self.liveExpiredArr[indexPath.row]
            let detailVC = R.storyboard.study.courseVideoDetailViewController()!
            detailVC.downloadBtnHiddenStatus = true
            let viewModel: CourseWareListViewModel = CourseWareListViewModel(liveCourseID: model.objectID)
            detailVC.viewModel = viewModel
            CurrentControllerHelper.pushViewController(viewController: detailVC)
        }
    }
}
