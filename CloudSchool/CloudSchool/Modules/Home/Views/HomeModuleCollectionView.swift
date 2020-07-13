//
//  HomeModuleCollectionView.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/10/14.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import Ruler

enum HomeFunctionType: Int {
    //环境保护法
    case huanjing = 1
    //新法规解读
    case xinfa = 12
    //环境监测
    case jiance = 21
    //基础知识
    case jichu = 26
    //行业管理
    case hangye = 98
    //案例分析
    case anli = 30
    //气候变化
    case qihou = 34
    //领导力
    case lingdao = 42
    //碳交易管理
    case jiaoyi = 70
    
    //热点变化
    case redian = 105
    
    
    var image: UIImage? {
        switch self {
        case .huanjing:
            return R.image.home_huanjing()
        case .jichu:
            return R.image.home_jichu()
        case .xinfa:
            return R.image.home_xinfa()
        case .anli:
            return R.image.home_anli()
        case .hangye:
            return R.image.home_hangye()
        case .jiance:
            return R.image.home_jiance()
        case .jiaoyi:
            return R.image.home_jiaoyi()
        case .lingdao:
            return R.image.home_lingdao()
        case .qihou:
            return R.image.home_qihou()
        case .redian:
            return R.image.home_redian()
        }
    }
    
    var title: String {
        switch self {
        case .huanjing:
            return "环境保护法"
        case .jichu:
            return "基础知识"
        case .xinfa:
            return "新法规解读"
        case .anli:
            return "案例分析"
        case .hangye:
            return "行业管理"
        case .jiance:
            return "环境监测"
        case .jiaoyi:
            return "碳交易管理"
        case .lingdao:
            return "领导力"
        case .qihou:
            return "气候变化"
        case .redian:
            return "热点问题"
        }
    }
}

import RxSwift

class HomeModuleCollectionView: UICollectionView {
    
    var datas: [HomeNavigationModel] = [] {
        didSet {
            self.reloadData()
        }
    }
    let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.register(R.nib.homeModuleCollectionViewCell)
        self.dataSource = self
        self.delegate = self
        self.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        loadData()
    }
    
    func loadData() {
        HUD.loading(text: "")
        RequestHelper.shared.getNaviList(parentID: "", type: "")
        .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                HUD.hideLoading()
                guard let `self` = self else { return }
                self.datas = list.data
            })
        .disposed(by: disposeBag)
    }

}

extension HomeModuleCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.homeModuleCollectionViewCell, for: indexPath)!
        cell.configure(model: datas[indexPath.row])
        if let type = HomeFunctionType(rawValue: datas[indexPath.row].seriesID) {
            cell.iconImageView.image = type.image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let width = Ruler.iPhoneHorizontal(Double((kScreenWidth - 20)/4.0), Double((kScreenWidth - 20)/5.0), Double((kScreenWidth - 20)/5.0)).value
        let height = Ruler.iPhoneHorizontal(95.0, 105.0, 105.0).value
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = datas[indexPath.row]
        let vc = R.storyboard.home.courseSectionListViewController()!
        vc.title = model.navigationName
        vc.parentID = model.seriesID.string
        
        CurrentControllerHelper.pushViewController(viewController: vc)
//        let vc = R.storyboard.home.courseProductListViewController()!
//        vc.title = model.navigationName
//
//        CurrentControllerHelper.pushViewController(viewController: vc)
        
    }
    
    
}
