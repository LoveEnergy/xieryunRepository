//
//  ZHFAddTitleAddressView.swift
//  AmazedBox
//
//  Created by 张海峰 on 2017/12/8.
//  Copyright © 2017年 张海峰. All rights reserved.
//
//这是一个自定义仿京东地址选择器。Swift版本，（保证集成成功，有不懂的地方可加QQ：991150443 进行讨论。）
//OC版本地址：https://github.com/FighterLightning/ZHFJDAddressOC.git
/*该demo的使用须知:
 1.下载该demo。把ProvinceModel.swift（必须），ZHFAddTitleAddressView.swift(必须) NetworkTools.swift(可用自己封装的)拖进项目
 2.pod 'Chrysan', :git => 'https://github.com/Harley-xk/Chrysan.git' //第三方加载框（根据需求进行添加）
 pod 'AFNetworking'//网络请求
 pod 'YYModel' //字典转模型
 3.把以下代码添加进自己的控制器方可使用，网络请求看ZHFAddTitleAddressView.swift头部注释根据需求进行修改
 4.如果感觉有帮助，不要吝啬你的星星哦！
  该demo地址：https://github.com/FighterLightning/ZHFJDAddress.git
 */
/*
 这个视图你需要修改的地方为：
 func getAddressMessageData(addressID: NSInteger, provinceIdOrCityId: NSInteger)
 该方法里的代码，已写清楚
 一个是模拟数据。
 二是网络请求数据。
 */

import UIKit
import Chrysan
import YYModel
import RxSwift
import RxCocoa

    let ScreenHeight = UIScreen.main.bounds.size.height
    let ScreenWidth = UIScreen.main.bounds.size.width
    protocol ZHFAddTitleAddressViewDelegate {
        func cancelBtnClick( titleAddress: String,titleID: String)
    }
    class ZHFAddTitleAddressView: UIView {
    let disposeBag = DisposeBag()
    let AddressAdministerCellIdentifier  = "AddressAdministerCellIdentifier"
    var delegate: ZHFAddTitleAddressViewDelegate?
    var userID :NSInteger = 0
    var defaultHeight: CGFloat = 200
    var title: String = "所在地区"
    var isclick: Bool = false  //判断是滚动还是点击
    var addAddressView: UIView =  UIView()
    lazy var provinceMarr:[RegionModel] = [] //省
    lazy var cityMarr:[RegionModel] = [] //市
    lazy var countyMarr:[RegionModel] = []  //县
    lazy var townMarr:[RegionModel] = [] //乡镇
    var titleScrollView :UIScrollView = UIScrollView()
    var contentScrollView :UIScrollView = UIScrollView()
    var radioBtn :UIButton = UIButton()
    var lineLabel :UILabel = UILabel()
    let titleScrollViewH :CGFloat = 37
    var titleMarr : NSMutableArray = NSMutableArray()
    lazy  var titleIDMarr : NSMutableArray = NSMutableArray()
    var tableViewMarr : NSMutableArray = NSMutableArray()
    var resultArr: [NSDictionary] = [NSDictionary]()//本地数组
    lazy var titleBtns : NSMutableArray = NSMutableArray()
    var PCCTID: NSInteger = -1
    var personalPage: Bool = false
    var toDistrictRow: Bool = false
    //初始化这个地址视图
    func initAddressView() -> UIView {
        //初始化本地数据（如果是网络请求请注释掉-----
        let imagePath: String = Bundle.main.path(forResource: "location", ofType: "txt")!
        var string : String = String()
        do {
            let string1: String  = try String.init(contentsOfFile: imagePath, encoding: String.Encoding.utf8)
            string = string1
        }catch { }
        let  resData : Data = string.data(using: String.Encoding.utf8)!
        do {
            let resultArr1  = try JSONSerialization.jsonObject(with: resData as Data, options: JSONSerialization.ReadingOptions.mutableLeaves)
            resultArr = resultArr1 as! [NSDictionary]
        }catch { }
        //------到这里
        self.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.isHidden = true
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapBtnAndcancelBtnClick))
//        tap.delegate = self
//        self.addGestureRecognizer(tap)
        //设置添加地址的View
        addAddressView.frame = CGRect.init(x: 0, y: ScreenHeight - CGFloat(NAVI_HEIGHT), width: ScreenWidth, height: defaultHeight)
        addAddressView.backgroundColor = UIColor.white
        self.addSubview(addAddressView)
        let titleLabelW = 100/WIDTH_6_SCALE
        let titleLabel: UILabel = UILabel.init(frame: CGRect.init(x: 40, y: 10/WIDTH_6_SCALE, width: titleLabelW, height: 30/WIDTH_6_SCALE))
        titleLabel.centerX = SCREEN_WIDTH/2
        titleLabel.text = title
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.textColor = UIColor.gray
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        addAddressView.addSubview(titleLabel)
        let cancelBtn:UIButton = UIButton.init(type: UIButton.ButtonType.custom)
        cancelBtn.frame = CGRect.init(x:addAddressView.frame.maxX - 80/WIDTH_6_SCALE, y: titleLabel.top, width: 60/WIDTH_6_SCALE, height: titleLabel.height)
        cancelBtn.tag = 1
        cancelBtn.setImage(UIImage.init(named: "cancel"), for: UIControl.State.normal)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(.black, for: .normal)
        cancelBtn.addTarget(self, action: #selector(tapBtnAndcancelBtnClick), for: UIControl.Event.touchUpInside)
        cancelBtn.titleLabel?.font = DEF_FontSize_17
        cancelBtn.setTitleColor(.gray, for: .normal)
        addAddressView.addSubview(cancelBtn)
        self.addTableViewAndTitle(tableViewTag: 0)
        //1.添加标题滚动视图
        setupTitleScrollView()
        //2.添加内容滚动视图
        setupContentScrollView()
        setupAllTitle(selectId: 0)
        return self
    }
    //弹出的动画效果
    func addAnimate() {
        self.isHidden = false
        UIView.animate(withDuration:0.2, animations: {
             self.addAddressView.frame.origin.y = ScreenHeight - self.defaultHeight - CGFloat(NAVI_HEIGHT)
        }, completion: nil)
    }
    //收回的动画效果
    @objc func tapBtnAndcancelBtnClick() {
        UIView.animate(withDuration:0.2, animations: {
            self.addAddressView.frame.origin.y = ScreenHeight - CGFloat(NAVI_HEIGHT)
        }) { (_) in
            self.isHidden = true
            var titleAddress :String = ""
            var titleID :String = ""
            var count: NSInteger = 0
            let str = self.titleMarr[self.titleMarr.count - 1] as! String
            if (str == "请选择") {
                count = self.titleMarr.count - 1
            }
            else{
                count = self.titleMarr.count
            }
            for i in 0 ..< count{
                titleAddress =  "\(titleAddress) \(self.titleMarr[i])"
                if i == count - 1 {
                    titleID = "\(titleID)\(self.titleIDMarr[i])"
                }
                else{
                    titleID = "\(titleID)\(self.titleIDMarr[i])="
                }
            }
            #warning("选择地址")
//            if self.personalPage == true{
//                if count == 1{
//                    return
//                }
//            }else{
//                if count == 1 || count == 2 || count == 3 {
//                    return
//                }
//            }
             self.delegate?.cancelBtnClick(titleAddress: titleAddress, titleID: titleID)
        }
    }
}
extension ZHFAddTitleAddressView :UIScrollViewDelegate{
    func setupTitleScrollView(){
       //TitleScrollView和分割线
        titleScrollView.frame = CGRect.init(x: 0, y: 50, width: ScreenWidth, height: titleScrollViewH)
        addAddressView.addSubview(titleScrollView)
        let lineView : UIView = UIView.init(frame: CGRect.init(x: 0, y: titleScrollView.frame.maxY, width: ScreenWidth, height: 0.5))
        lineView.backgroundColor = UIColor.gray
        addAddressView.addSubview(lineView)
    }
    func setupContentScrollView(){
        //ContentScrollView
        let y : CGFloat = titleScrollView.frame.maxY + 1
        contentScrollView.frame = CGRect.init(x: 0, y: y, width: ScreenWidth, height: defaultHeight - y)
        addAddressView.addSubview(contentScrollView)
        contentScrollView.delegate = self;
        contentScrollView.isPagingEnabled = true;
        contentScrollView.bounces = false;
    }
    //设置所有title
    func setupAllTitle( selectId: NSInteger ) {
        for view in titleScrollView.subviews {
            view.removeFromSuperview()
        }
         self.titleBtns.removeAllObjects()
        let btnH :CGFloat = self.titleScrollViewH
        lineLabel.backgroundColor = UIColor.red
        titleScrollView.addSubview(lineLabel)
        var x : CGFloat = 10
        for i in 0 ..< self.titleMarr.count {
            let title : String = (titleMarr[i] as? String)!
            let titlelenth : CGFloat = CGFloat(title.count * 15)
            let titleBtn :UIButton = UIButton.init(type:UIButton.ButtonType.custom)
            titleBtn.setTitle(title, for: UIControl.State.normal)
            titleBtn.tag = i
            titleBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
            titleBtn.setTitleColor(UIColor.red, for: UIControl.State.selected)
            titleBtn.isSelected = false
            titleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            titleBtn.frame = CGRect.init(x: x, y: 0, width: titlelenth, height: btnH)
            x  = (titlelenth + 10) + x
            titleBtn.addTarget(self, action: #selector(titleBtnClick), for: UIControl.Event.touchUpInside)
            self.titleBtns.add(titleBtn)
            if i == selectId {
                titleBtnClick(titleBtn: titleBtn)
            }
            titleScrollView.addSubview(titleBtn)
            titleScrollView.contentSize = CGSize.init(width: x, height: 0)
            titleScrollView.showsHorizontalScrollIndicator = false;
            contentScrollView.contentSize = CGSize.init(width: CGFloat(self.titleMarr.count) * ScreenWidth, height: 0)
            contentScrollView.showsHorizontalScrollIndicator = false;
        }
    }
    @objc func titleBtnClick(titleBtn: UIButton)  {
        radioBtn.isSelected = false
        titleBtn.isSelected = true
        setupOneTableView(btnTag :titleBtn.tag)
        let x :CGFloat  = CGFloat(titleBtn.tag) * ScreenWidth
        lineLabel.frame = CGRect.init(x: titleBtn.frame.minX, y: titleScrollViewH - 3, width: titleBtn.frame.size.width, height: 3)
        UIView.animate(withDuration: 0.25) {
            self.contentScrollView.contentOffset = CGPoint.init(x: x, y: 0)
        }
       // self.contentScrollView.setContentOffset(CGPoint.init(x: x, y: 0), animated: true)//使用这个动画效果会出现bug
        radioBtn = titleBtn
        isclick = true
    }
    func setupOneTableView(btnTag: NSInteger){
        let contentView : UITableView = self.tableViewMarr[btnTag] as! UITableView
        if btnTag == 0 {
          self.getAddressMessageData(addressID: 1, provinceIdOrCityId: 0)
        }
        if (contentView.superview != nil) {
            return
        }
        let x : CGFloat = CGFloat(btnTag) * ScreenWidth
        contentView.frame = CGRect.init(x: x, y: 0, width: ScreenWidth, height: contentScrollView.bounds.size.height)
        contentView.delegate = self
        contentView.dataSource = self
        self.contentScrollView.addSubview(contentView)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let leftI :NSInteger  = NSInteger(scrollView.contentOffset.x / ScreenWidth);
        if CGFloat(scrollView.contentOffset.x / ScreenWidth) != CGFloat(leftI){
            isclick = false
        }
        if isclick == false {
            if CGFloat(scrollView.contentOffset.x / ScreenWidth) == CGFloat(leftI)  {
                let titleBtn :UIButton  = titleBtns[leftI] as! UIButton
                titleBtnClick(titleBtn: titleBtn)
            }
        }
    }
}
// tableView代理处理
extension ZHFAddTitleAddressView:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return self.provinceMarr.count
        }
        else if tableView.tag == 1 {
            return self.cityMarr.count
        }
        else if self.personalPage == false{
            if tableView.tag == 2{//判断
                return self.countyMarr.count
            }else if tableView.tag == 3{
                if self.toDistrictRow == true {
                    return 0
                }
                return self.townMarr.count
            }
            else{
               return 0
            }
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell :AddressCell = tableView.dequeueReusableCell(withIdentifier: AddressAdministerCellIdentifier, for: indexPath) as! AddressCell
        if cell.isEqual(nil){
            cell = AddressCell(style:.default, reuseIdentifier: AddressAdministerCellIdentifier)
        }
        if tableView.tag == 0 {
            let provinceModel: RegionModel = self.provinceMarr[indexPath.row]
            cell.titleString = provinceModel.regionName
            self.PCCTID = provinceModel.regionID
        }
        else if tableView.tag == 1 {
           let cityModel: RegionModel = self.cityMarr[indexPath.row]
            cell.titleString = cityModel.regionName
            self.PCCTID = cityModel.regionID
        }
        else if tableView.tag == 2{
            let countyModel: RegionModel = self.countyMarr[indexPath.row]
            cell.titleString = countyModel.regionName
            self.PCCTID = countyModel.regionID
        }
        else if tableView.tag == 3{
            let townModel: RegionModel = self.townMarr[indexPath.row]
            cell.titleString = townModel.regionName
            self.PCCTID = townModel.regionID
        }
        if titleIDMarr.count > tableView.tag{
            let  pcctId :NSInteger = titleIDMarr[tableView.tag] as! NSInteger
            if self.PCCTID == pcctId{
              cell.isChangeRed = true
            }
            else{
                cell.isChangeRed = false
            }
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //先刷新当前选中的tableView
        let tableView: UITableView  = self.tableViewMarr[tableView.tag] as! UITableView
        tableView.reloadData()
        if tableView.tag == 0 || tableView.tag == 1 || tableView.tag == 2 {
            if tableView.tag == 0{
                let provinceModel: RegionModel = self.provinceMarr[indexPath.row]
                //1. 修改选中ID
                if self.titleIDMarr.count > 0{
                    self.titleIDMarr.replaceObject(at: tableView.tag, with: provinceModel.regionID)
                }
                else{
                    self.titleIDMarr.add(provinceModel.regionID)
                }
                //2.修改标题
                self.titleMarr.replaceObject(at: tableView.tag, with: provinceModel.regionName)
                //添加市区
                self.getAddressMessageData(addressID: 2 ,provinceIdOrCityId: provinceModel.regionID)
            }
            else if tableView.tag == 1 {
                let cityModel: RegionModel = self.cityMarr[indexPath.row]
                self.titleMarr.replaceObject(at: tableView.tag, with: cityModel.regionName)
                //1. 修改选中ID
                if self.titleIDMarr.count > 1{
                    self.titleIDMarr.replaceObject(at: tableView.tag, with: cityModel.regionID)
                }
                else{
                    self.titleIDMarr.add(cityModel.regionID)
                }
                //添加县城
                self.getAddressMessageData(addressID: 3 ,provinceIdOrCityId: cityModel.regionID)
                if self.personalPage == true {
                    self.tapBtnAndcancelBtnClick()
                }
            }
            else if tableView.tag == 2 {
                let countyModel: RegionModel = self.countyMarr[indexPath.row]
                titleMarr.replaceObject(at: tableView.tag, with: countyModel.regionName)
                //1. 修改选中ID
                if self.titleIDMarr.count > 2{
                    self.titleIDMarr.replaceObject(at: tableView.tag, with: countyModel.regionID)
                }
                else{
                    self.titleIDMarr.add(countyModel.regionID)
                }
                //添加乡镇
                self.getAddressMessageData(addressID: 4 ,provinceIdOrCityId: countyModel.regionID)
                if self.toDistrictRow == true {
                    self.tapBtnAndcancelBtnClick()
                }
            }
        }
        else if tableView.tag == 3 {
            let townModel: RegionModel = self.townMarr[indexPath.row]
            titleMarr.replaceObject(at: tableView.tag, with: townModel.regionName)
            //1. 修改选中ID
            if self.titleIDMarr.count > 3{
                self.titleIDMarr.replaceObject(at: tableView.tag, with: townModel.regionID)
            }
            else{
                self.titleIDMarr.add(townModel.regionID)
            }
            setupAllTitle(selectId: tableView.tag)
            self.tapBtnAndcancelBtnClick()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    //添加tableView和title
    func addTableViewAndTitle(tableViewTag: NSInteger){
        let tableView2:UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 200), style: UITableView.Style.plain)
        tableView2.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView2.tag = tableViewTag
        tableView2.register(AddressCell.self, forCellReuseIdentifier: AddressAdministerCellIdentifier)
        self.tableViewMarr.add(tableView2)
        self.titleMarr.add("请选择")
    }
    //改变title
    func changeTitle(replaceTitleMarrIndex:NSInteger){
        self.titleMarr.replaceObject(at: replaceTitleMarrIndex, with: "请选择")
        let index :NSInteger = self.titleMarr.index(of: "请选择")
        let count:NSInteger = self.titleMarr.count
        let loc: NSInteger = index + 1
        let range:NSInteger = count - index
        self.titleMarr.removeObjects(in: NSRange.init(location: loc, length: range - 1))
        self.tableViewMarr.removeObjects(in: NSRange.init(location: loc, length: range - 1))
    }
    //移除多余的title和tableView,收回选择器
    func removeTitleAndTableViewCancel(index:NSInteger){
        let indexAddOne:NSInteger = index + 1
        let indexsubOne:NSInteger = index - 1
        if (self.tableViewMarr.count >= indexAddOne){
            self.titleMarr.removeObjects(in: NSRange.init(location: index, length: self.titleMarr.count - indexAddOne))
            self.tableViewMarr.removeObjects(in: NSRange.init(location: index, length: self.titleMarr.count - indexAddOne))
        }
        self.setupAllTitle(selectId: indexsubOne)
        self.tapBtnAndcancelBtnClick()
    }
}
//防止手势冲突
extension ZHFAddTitleAddressView:UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if NSStringFromClass((touch.view?.classForCoder)!) == "UITableViewCellContentView" || touch.view == addAddressView || touch.view == titleScrollView {
            return false
        }
        return true
    }
}
//本地添加（所有的省都对应的有市，市对应的有县）
extension ZHFAddTitleAddressView {
    func getAddressMessageData(addressID: NSInteger, provinceIdOrCityId: NSInteger){
        switch addressID {
        case 1:
            self.case1()
        case 2:
            self.case2(selectedID: provinceIdOrCityId)
        case 3://判断
            self.case3(selectedID: provinceIdOrCityId)
        case 4:
            self.case4(selectedID: provinceIdOrCityId)
        default:
            break;
        }
        if self.tableViewMarr.count >= addressID{
            let tableView1: UITableView  = self.tableViewMarr[addressID - 1] as! UITableView
            tableView1.reloadData()
        }
    }
    func case1() {
        
        if resultArr.count > 0 {
            self.provinceMarr = AddressManager.shared.provinceList
        }
        else{
            self.tapBtnAndcancelBtnClick()
        }
    }
    func case2(selectedID: NSInteger) {
        UserHelper.shared.getCityList(regionID: selectedID.toString())
        .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                self.cityMarr = list.data
                if (self.tableViewMarr.count >= 2){
                    self.changeTitle(replaceTitleMarrIndex: 1)
                }
                else{
                    self.addTableViewAndTitle(tableViewTag: 1)
                }
                if (self.cityMarr.count > 0) {
                    self.setupAllTitle(selectId: 1)
                }
                else{
                    //没有对应的市
                    self.removeTitleAndTableViewCancel(index: 1)
                }
                if self.tableViewMarr.count > 1{
                    let tableView: UITableView  = self.tableViewMarr[1] as! UITableView
                    tableView.reloadData()
                }
            })
        .disposed(by: disposeBag)
    }
    func case3(selectedID: NSInteger) {
        
        UserHelper.shared.getCityList(regionID: selectedID.toString())
            .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                self.countyMarr = list.data
                if (self.tableViewMarr.count >= 3){
                    self.changeTitle(replaceTitleMarrIndex: 2)
                }
                else{
                    self.addTableViewAndTitle(tableViewTag: 2)
                }
                if (self.countyMarr.count > 0) {
                    self.setupAllTitle(selectId: 2)
                }
                else{
                    //没有对应的县
                    self.removeTitleAndTableViewCancel(index: 2)
                }
            })
            .disposed(by: disposeBag)
    }
    func case4(selectedID: NSInteger) {
        UserHelper.shared.getCityList(regionID: selectedID.toString())
            .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                self.townMarr = list.data
                if (self.tableViewMarr.count >= 4){
                    self.changeTitle(replaceTitleMarrIndex: 3)
                }
                else{
                    self.addTableViewAndTitle(tableViewTag: 3)
                }
                if (self.townMarr.count > 0) {
                    self.setupAllTitle(selectId: 3)
                }
                else{//没有对应的乡镇
                    self.removeTitleAndTableViewCancel(index: 3)
                }
            })
            .disposed(by: disposeBag)
    }
}
//网络请求*****你只需要修改这个方法里的内容就可使用
// 以下是网络请求方法
//extension ZHFAddTitleAddressView{
//
    //    func getAddressMessageData(addressID: NSInteger, provinceIdOrCityId: NSInteger) {
    //        var addressUrl =  String()
    //        var parameters : NSDictionary =  NSDictionary()
    //        switch addressID {
    //        case 1:
    //            //获取省份的URL
    //            addressUrl = "getProvinceAddressUrl"
    //            //请求省份需要传递的参数
    //            parameters = ["user_id" : userID]
    //        case 2:
    //            //获取市区的URL
    //            addressUrl = "getCityAddressUrl"
    //            //请求市区需要传递的参数
    //            parameters = ["province_id" : "5",
    //            "user_id" : userID]
    //        case 3:
    //            //获取县的URL
    //            addressUrl = "getCountyAddressUrl"
    //            //请求县需要传递的参数
    //            parameters = ["city_id" : "4",
    //                          "user_id" : userID]
    //        case 4:
    //            //获取乡镇的URL
    //            addressUrl = "getTownAddressUrl"
    //            //请求县需要传递的参数
    //            parameters = ["county_id" : "3",
    //                          "user_id" : userID]
    //        default:
    //            break;
    //        }
    //        //第三方加载工具
    //        self.addAddressView.chrysan.show()
    //        //网络请求
    //        NetworkTools.shareInstance.request(methodType: .POST, urlString:addressUrl, parameters: parameters as! [String : AnyObject]) { (result, error) in
    //            self.addAddressView.chrysan.hide()
    //            if result != nil
    //            {
    //                let dic = result as! NSDictionary
    //                let code : NSInteger = dic["code"] as! NSInteger
    //                if code == 200{
    //                    switch addressID {
    //                    case 1:
    //                        //拿到省列表
    //                       let  provinceArr: NSArray = dic["data"] as! NSArray
    //                       self.case1(provinceArr: provinceArr)
   //                        break;
    //                    case 2:
    //                        //拿到市列表
    //                        let  cityArr: NSArray = dic["data"] as! NSArray
    //                        self.case2(cityArr: cityArr)
    //                        break;
    //                    case 3:
    //                        //拿到县列表
    //                        let  countyArr: NSArray = dic["data"] as! NSArray
    //                        self.case3(countyArr: countyArr)
   //                        break;
    //                    case 4:
    //                        //拿到乡镇列表
//                            let  townArr: NSArray = dic["data"] as! NSArray
//                            self.case3(townArr: townArr)
   //                        break;
    //                    default:
    //                        break;
    //                    }
    //                    if self.tableViewMarr.count >= addressID{
    //                        let tableView1: UITableView  = self.tableViewMarr[addressID - 1] as! UITableView
    //                        tableView1.reloadData()
    //                    }
    //                }
    //                else{
    //                   self.addAddressView.chrysan.showMessage(dic["msg"] as! String, hideDelay: 2.0)
    //                }
    //            }
    //            else{
    //                self.addAddressView.chrysan.showMessage(error as! String, hideDelay: 2.0)
    //            }
    //        }
    //    }
/*下面这个主要是逻辑分析和数据处理
 只需要找到 ProvinceModel类，把其属性修改成你需要的即可
 以下方法：对没有下一级的情况，进行了逻辑判断（建议不要随意更改。）
 */
//    func case1(provinceArr: NSArray ) {
//        if provinceArr.count > 0{
//            self.provinceMarr.removeAllObjects()
//            for i in 0 ..< provinceArr.count{
//                let dic1 : [String : Any] = provinceArr[i] as! [String : Any]
//                let provinceModel:ProvinceModel  =
//                    ProvinceModel.yy_model(with: dic1)!
//                self.provinceMarr.add(provinceModel)
//            }
//        }
//        else{
//            self.tapBtnAndcancelBtnClick()
//        }
//    }
//    func case2(cityArr: NSArray) {
//        if cityArr.count > 0{
//            self.cityMarr.removeAllObjects()
//            for i in 0 ..< cityArr.count{
//                let dic1 : [String : Any] = cityArr[i] as! [String : Any]
//                let cityModel:CityModel  =
//                    CityModel.yy_model(with: dic1)!
//                self.cityMarr.add(cityModel)
//            }
//            if self.tableViewMarr.count >= 2{
//                 self.changeTitle(replaceTitleMarrIndex: 1)
//            }
//            else{
//                self.addTableViewAndTitle(tableViewTag: 1)
//            }
//            self.setupAllTitle(selectId: 1)
//        }
//        else{
//            //没有对应的市
//            self.removeTitleAndTableViewCancel(index: 1)
//        }
//    }
//    func case3(countyArr: NSArray ) {
//        if countyArr.count > 0{
//            self.countyMarr.removeAllObjects()
//            for i in 0 ..< countyArr.count{
//                let dic1 : [String : Any] = countyArr[i] as! [String : Any]
//                let countyModel:CountyModel  =
//                    CountyModel.yy_model(with: dic1)!
//                self.countyMarr.add(countyModel)
//            }
//            if (self.tableViewMarr.count >= 3){
//                self.changeTitle(replaceTitleMarrIndex: 2)
//            }
//            else{
//                 self.addTableViewAndTitle(tableViewTag: 2)
//            }
//            self.setupAllTitle(selectId: 2)
//        }
//        else{
//            //没有对应的县
//           self.removeTitleAndTableViewCancel(index: 2)
//        }
//}
//    func case4(townArr: NSArray) {
//        self.townMarr.removeAllObjects()
//        if townArr.count > 0{
//        for i in 0 ..< townArr.count{
//            let dic1 : [String : Any] = townArr[i] as! [String : Any]
//            let townModel:TownModel  =
//                TownModel.yy_model(with: dic1)!
//            self.townMarr.add(townModel)
//        }
//        if (self.tableViewMarr.count >= 4){
//             self.changeTitle(replaceTitleMarrIndex: 3)
//        }
//        else{
//          self.addTableViewAndTitle(tableViewTag: 3)
//        }
//            self.setupAllTitle(selectId: 3)
//        }
//        else{//没有对应的乡镇
//           self.removeTitleAndTableViewCancel(index: 3)
//        }}
//}

