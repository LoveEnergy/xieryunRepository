//
//  HomeViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/10/21.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController , UINavigationControllerDelegate{
    var nativeVersionString: String = ""
    var networkAPPVersion: String = ""
    var backPage: Int?
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var remoteClassView: RemoteClassView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var banner: HomeBannerView!
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var moduleCollectionView: HomeModuleCollectionView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var courseCollectionViewContainer: NestedListView!
    @IBOutlet weak var classifyTopView: CourseClassifyView!
    
    @IBOutlet weak var bookView: HomeBooksListView!
    @IBOutlet weak var trainView: HomeTrainListView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var courseCollectionView: UICollectionView!
    @IBOutlet weak var courseClassifyCollectionView: UICollectionView!
    
    @IBOutlet weak var navLine: LineView!
    @IBOutlet weak var vipADView: UIView!
    var ADProductID: Int = 0
    var ADProductType: Int = 0
    
    var topAlpha: CGFloat = 0.0 {
        didSet {
            navView.backgroundColor = UIColor(white: 1, alpha: topAlpha)
            navLine.alpha = topAlpha
        }
    }
    
    var currentSection: HomeListSection? {
        didSet {
            reloadCollectionView()
        }
    }
    
    var currentSectionIndex: Int = 0 {
        didSet {
            if self.data.count > currentSectionIndex {
                self.currentSection = self.data[currentSectionIndex]
            }
        }
    }
    
    var currentCourseNumber: Int {
        return currentSection?.courseList.count ?? 0
    }
    
    override var hideNavigationBar: Bool {
        return true
    }
    
    var data: [HomeListSection] = [] {
        didSet {
            currentSection = data.first
            classifyTopView.data = data
            courseCollectionViewContainer.contentSize = CGSize(width: kScreenWidth * CGFloat(data.count), height: courseCollectionViewContainer.height)
            courseCollectionViewContainer.totalPage = data.count
            
            courseCollectionViewContainer.scrollToPage(self.backPage!)
            self.classifyTopView.currentIndex = self.backPage!
            reloadCollectionView()
        }
    }
    
    var remoteData: [RemoteClassDetailModel] = []{
        didSet{
            self.remoteClassView.model = remoteData
            self.remoteClassView.collectionView.reloadData()
        }
    }
    
    func reloadCollectionView() {
//        courseClassifyCollectionView.reloadData()
        courseCollectionView.reloadData()
        collectionViewHeightConstraint.constant = courseCollectionView.contentSize.height
    }
    
    lazy var homePageADView : HomePageADView = {
        var homePageADView = HomePageADView.init(frame: self.view.bounds)
        homePageADView.homePageADViewDismissBlock = {
            UIView.animate(withDuration: 0.15, animations: {
                self.homePageADView.alpha = 0
            }) { (Bool) in
                self.homePageADView.removeFromSuperview()
            }
        }
        return homePageADView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self as UINavigationControllerDelegate
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.hidesBottomBarWhenPushed = false
        self.loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.15, animations: {
            self.homePageADView.alpha = 0
        }) { (Bool) in
            self.homePageADView.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self, selector: #selector(self.adVcClick(noti:)), name: NSNotification.Name(rawValue: "toADVc"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.openPushClick(noti:)), name: NSNotification.Name(rawValue: "pushOpen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(isPushFunc(noti:)), name: NSNotification.Name(rawValue: "isPushOpen"), object: nil)
//        UserDefaults.standard.set("1", forKey: "loadTimes")
    }
    
    override func loadView() {
        super.loadView()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
            self.moduleCollectionView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.scrollView.backgroundColor = UIColor.backgroundColor
        courseCollectionView.delegate = self
        courseCollectionView.dataSource = self
//        courseClassifyCollectionView.delegate = self
//        courseClassifyCollectionView.dataSource = self
        courseCollectionView.register(R.nib.courseCollectionViewCell)
        courseClassifyCollectionView.register(R.nib.courseClassifyCollectionViewCell)
        
        courseCollectionViewContainer.nestDelegate = self
        loadData()
        contentScrollView.delegate = self
//        DownloadManager.shared.addDownloadTask(url: "http://47.92.168.211/courseware/2/1/uO2J7uqpLb-0.flv")
        
        searchButton.addTarget(self, action: #selector(showSearch), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(clickMore), for: .touchUpInside)
        
        classifyTopView.indexSignal
        .asObservable()
            .subscribe(onNext: {[weak self] (value) in
                guard let `self` = self else { return }
                self.courseCollectionViewContainer.scrollToPage(value)
                self.currentSectionIndex = value
                self.backPage = value
            })
        .disposed(by: disposeBag)
        
        self.courseCollectionViewContainer.changedPage = { value in
            if value != self.classifyTopView.currentIndex {
                self.classifyTopView.currentIndex = value
                self.currentSectionIndex = value
            }
        }
        
        scrollView.addRefreshHeader {
            self.loadData()
        }
        
        PrivacyConfirmViewController.show()
        AddressManager.shared.getProvinceList()
        //首页广告显示
//        self.homePageADView.showView()
        
        self.vipADView.addSubview(self.vipADImgView)
        
    }
    
    lazy var vipADImgView : UIImageView = {
        weak var weakSelf = self
        var vipADImgView = UIImageView.init(frame: CGRect(x: 25/WIDTH_6_SCALE, y: 10/WIDTH_6_SCALE, width: SCREEN_WIDTH - 50/WIDTH_6_SCALE, height: (weakSelf?.vipADView.height)! - 10/WIDTH_6_SCALE))
        vipADImgView.image = UIImage.init(named: "home_vip_ad_bg")
        return vipADImgView
    }()
    
    @objc func showSearch() {
        let vc = R.storyboard.home.searchViewController()!
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
    
    func loadData() {
        HUD.loading(text: "")
        RequestHelper.shared.getBanner()
        .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                HUD.hideLoading()
                guard let `self` = self else { return }
                self.banner.datas = list.data
                self.scrollView.endRefresh()
                self.reloadAllView()
            })
        .disposed(by: disposeBag)
        
        HUD.loading(text: "")
        RequestHelper.shared.getCourses()//底部横向滑动一级标题选择，最新课程、公开课、西尔精品课程……
            .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                HUD.hideLoading()
                guard let `self` = self else { return }
                self.data = list.data
                self.scrollView.endRefresh()
                self.reloadAllView()
            })
            .disposed(by: disposeBag)
        
        HUD.loading(text: "")
        RequestHelper.shared.remoteClassData(pageNo: 1, pageSize: 10)
        .asObservable()
        .subscribe(onNext: {[weak self] (list) in
            HUD.hideLoading()
            guard let `self` = self else { return }
            self.remoteData = list.data?.rows as! [RemoteClassDetailModel]
        })
        .disposed(by: disposeBag)
        
        self.trainView.loadData()
        self.bookView.loadData()
        self.moduleCollectionView.loadData()
        self.checkVersionTapGestrue()//判断版本信息
        UserDefaults.standard.set(false, forKey: "isPushOpen")
        
        self.remoteClassView.moreRemoteClassBlock = {
            let vc = RemoteListClassViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func reloadAllView() {
        self.trainView.loadData()
        self.bookView.loadData()
        self.moduleCollectionView.loadData()
        (self.courseCollectionViewContainer.listView(page: self.courseCollectionViewContainer.currentPage) as? UICollectionView)?.reloadData()
        if self.backPage != nil {
            self.courseCollectionViewContainer.scrollToPage(self.backPage!)
            self.classifyTopView.currentIndex = self.backPage!
            self.currentSectionIndex = self.backPage!
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionViewHeightConstraint.constant = courseCollectionView.contentSize.height
    }
    
    func checkVersionTapGestrue(){
        //build版本
        let key = "CFBundleVersion"
        let currentVersion = "V\(Bundle.main.infoDictionary![key]!)"
        print("\(currentVersion)")
        // 这是获取appStore上的app的版本的url
        let appStoreUrl = "http://itunes.apple.com/lookup?id=1500864461"
        let urlstring = NSURL.init(string: appStoreUrl)
        var request = URLRequest.init(url: urlstring as! URL, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 10)
        request.httpMethod = "POST"
        let queue = OperationQueue.init()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue) { (response, data, error) in
            var receiveStatusDic: [String: Any] = [:]
            if error == nil{
                let receiveDic = try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! [String: Any]
                if receiveDic!["resultCount"] as! Int > 0{
                    receiveStatusDic["status"] = "1"
                    var tempDicArr: [[String: Any]] = receiveDic!["results"] as! [[String : Any]]
                    var versionInfo = tempDicArr[0]["version"]
                    receiveStatusDic["version"] = versionInfo
                }else{
                    receiveStatusDic["status"] = "-1"
                }
            }else{
                receiveStatusDic["status"] = "1"
            }
            self.performSelector(onMainThread: #selector(self.receiveData), with: receiveStatusDic, waitUntilDone: false)
        }
    }
    
    @objc func receiveData(){
        let infoDic = Bundle.main.infoDictionary
        self.nativeVersionString = infoDic!["CFBundleShortVersionString"] as! String
//        self.judgeUpdataVersion()
        self.dataManagerVersionInfo()
    }
    //判断是否更新
    func judgeUpdataVersion(){
        let comparisonResult = self.nativeVersionString.compare(self.networkAPPVersion)
        //创建UIAlertController(警告窗口)
        let alert = UIAlertController(title: "有新版本更新", message: nil, preferredStyle: .alert)
        let sure = UIAlertAction(title: "去更新", style: .default) { (UIAlertAction) in
            let urlString = NSURL.init(string: "itms-apps://itunes.apple.com/app/id1500864461?mt=8")
            UIApplication.shared.open(urlString as! URL, options: [:], completionHandler: nil)
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (UIAlertAction) in
            print("you selected cancel")
        }
        //将Actiont加入到AlertController
        alert.addAction(sure)
//        alert.addAction(cancel)
        switch comparisonResult {
        case .orderedSame:
            print("本地版本与商店版本号相同，不需要更新")
            break
        case .orderedAscending:
            print("本地版本号 < 商店版本号相同，需要更新")
            self.present(alert, animated: true, completion: nil)
            break
        case .orderedDescending:
            print("本地版本号 > 商店版本号相同，不需要更新")
            break
        default:
            break
        }
    }
    
    func dataManagerVersionInfo(){
        UserHelper.shared.getAPPVersionInfo().asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                if list.code == 200{
                    let versionModel: VersionDetailModel = list.data!
                    print("版本号：\(versionModel.clientVersion)")
                    self.networkAPPVersion = versionModel.clientVersion
                    self.judgeUpdataVersion()
                    //判断是否上线
                    let defaults = UserDefaults.standard
                    if versionModel.versionInfo == "0" {
                        defaults.set(false, forKey: "AuditStatus")
                    }else{
                        defaults.set(true, forKey: "AuditStatus")
                    }
                }
            })
        .disposed(by: disposeBag)
    }
}

extension HomeViewController: NestedListViewDelegate {
    func createListView(page: Int) -> UIScrollView {
        if self.data.count > page {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: (kScreenWidth-30)/2.0, height: 200)
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            let collectionView = HomeCourseCollectionView.init(frame: .zero, collectionViewLayout: layout)
            collectionView.data = self.data[page].courseList
            return collectionView
        }
        return UIScrollView()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == courseClassifyCollectionView {
            return data.count
        } else {
            return min(currentCourseNumber, 4)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == courseClassifyCollectionView {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.courseClassifyCollectionViewCell, for: indexPath)!
            let model = data[indexPath.row]
            cell.nameLabel.text = model.floorName
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.courseCollectionViewCell, for: indexPath)!
            if let model = currentSection?.courseList[indexPath.row] {
                cell.configure(model: model)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == courseClassifyCollectionView, let cell = collectionView.cellForItem(at: indexPath) as? CourseClassifyCollectionViewCell {
            cell.setSelected(true)
            self.currentSection = data[indexPath.row]
        } else {
            let model = data[0].courseList[indexPath.row]
            let vc = R.storyboard.home.courseDetailViewController()!
            vc.productID = model.productID.toString()
            vc.productType = model.productType
            CurrentControllerHelper.pushViewController(viewController: vc)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == courseClassifyCollectionView, let cell = collectionView.cellForItem(at: indexPath) as? CourseClassifyCollectionViewCell {
            cell.setSelected(false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView ==  courseClassifyCollectionView {
            let model = data[indexPath.row]
            let count = model.floorName.count
            return CGSize(width: CGFloat(count) * 18, height: 40)
        } else {
            return CGSize(width: (kScreenWidth-30)/2.0, height: 200)
        }
    }
    
    @objc func clickMore() {
        currentSection?.openMore()
    }
    
    @objc func adVcClick(noti: Notification){
        //字典判断是否为空
        guard let type = noti.userInfo!["type"] as? Int else{
            return
         }
        guard let productID = noti.userInfo!["productID"] as? Int else{
            return
        }
        self.ADProductID = productID
        self.ADProductType = type
        if self.ADProductID != 0{
            let detailVC = R.storyboard.home.courseDetailViewController()!
            detailVC.productID = "\(self.ADProductID)"
            detailVC.productType = self.ADProductType
            detailVC.isPushIn = true
            CurrentControllerHelper.pushViewController(viewController: detailVC)
        }
    }
    
    @objc func openPushClick(noti: Notification){
        //字典判断是否为空
        let userInfo = noti.userInfo as! [String: String]
        let openTypeString = userInfo["openType"]! as String
        let openType = Int(openTypeString)
        if openType == 1 {
            if let productID = userInfo["productID"]{
                let detailVC = R.storyboard.home.courseDetailViewController()!
                detailVC.productID = productID
                detailVC.productType = Int(userInfo["productType"]! as String)!
                detailVC.navigationController?.navigationBar.isHidden = false
                detailVC.isPushIn = true
                CurrentControllerHelper.pushViewController(viewController: detailVC)
            }
        }
        if openType == 2 {
            if let url = userInfo["url"]{
                let webVc = OpenPushWebViewController.init()
                let navVc = UINavigationController.init(rootViewController: webVc)
                webVc.webUrl = url
                webVc.title = "\(userInfo["title"]!)"
                navVc.modalPresentationStyle = .fullScreen
                self.present(navVc, animated: true, completion: nil)
            }
        }
    }
    
    @objc func isPushFunc(noti: Notification){
        let userInfo = noti.userInfo as! [String: String]
        let openType = userInfo["openType"]! as String
        if openType == "1" {
            if let productID = userInfo["productID"]{
                DispatchQueue.main.async {
                    let detailVC = R.storyboard.home.courseDetailViewController()!
                    detailVC.productID = productID
                    detailVC.productType = Int(userInfo["productType"]! as String)!
                    detailVC.navigationController?.navigationBar.isHidden = false
                    detailVC.isPushIn = true
                    CurrentControllerHelper.pushViewController(viewController: detailVC)
                }
            }
        }
        if openType == "2" {
            if let url = userInfo["url"]{
                DispatchQueue.main.async {
                    let webVc = OpenPushWebViewController.init()
                    let navVc = UINavigationController.init(rootViewController: webVc)
                    webVc.webUrl = url
                    webVc.title = "\(userInfo["title"]!)"
                    self.navigationController?.present(navVc, animated: true, completion: nil)
                }
            }
        }
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.mj_offsetY
        self.topAlpha = offset / 200.0
    }
}

protocol CourseProtocol {
    
    var imageURL: String { get }
    var name: String { get }
    var price: String { get }
    var priceValue: CGFloat { get }
    var buyNumber: Int { get }
    var productID: Int { get set }
    var startTime: String { get set }
    var addressString: String? { get }
    var productType: Int { get }
    var applePayID: String { get }
    var applePrice: Int { get }
    var teacherName: String { get }
    var objectType: Int { get }
    var courseType: Int { get }
}

class Course: CourseProtocol {
    var addressString: String? {
        return ""
    }
    
    var startTime: String = ""
    
    var priceValue: CGFloat {
        return 0
    }
    
    var productID: Int = 0
    
    var price: String {
        return ""
    }
    
    var buyNumber: Int {
        return 0
    }
    
    var productType: Int {
        return 0
    }
    
    var imageURL: String {
        return ""
    }
    
    var name: String {
        return ""
    }
    
    var applePrice: Int{
        return 0
    }
    var applePayID: String{
        return ""
    }
    
    var teacherName: String {
        return ""
    }
    
    var objectType: Int{
        return 0
    }
    
    var courseType: Int{
        return 0
    }
}
