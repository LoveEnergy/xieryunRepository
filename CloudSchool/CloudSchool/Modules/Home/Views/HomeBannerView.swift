//
//  HomeBannerView.swift
//  KuTing
//
//  Created by Maynard on 2018/3/21.
//  Copyright © 2018年 Pengxianhe. All rights reserved.
//

import UIKit
import FSPagerView
import Kingfisher
import ObjectMapper

class HomeBannerView: UIView {
    var banner: FSPagerView = {
        let view = FSPagerView()
        view.scrollDirection = .horizontal
        view.isInfinite = true
        view.automaticSlidingInterval = 3.0
        view.register(R.nib.homeBannerCollectionViewCell(), forCellWithReuseIdentifier: R.nib.homeBannerCollectionViewCell.identifier)
        return view
    }()
    
    var pageControl: FSPageControl = {
        let control = FSPageControl()
        control.contentHorizontalAlignment = .center
        control.numberOfPages = 2
        control.tintColor = UIColor.red
        control.setFillColor(UIColor(white: 1, alpha: 0.5), for: .normal)
        control.setFillColor(UIColor.white, for: .selected)
        //圆点大小
        control.itemSpacing = 8
        //圆点间隔
        control.interitemSpacing = 16
        return control
    }()
    
    var datas: [BannerModel] = [] {
        didSet {
            pageControl.numberOfPages = datas.count
            banner.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseConfigure()
    }
    
    fileprivate func baseConfigure() {
        addSubview(banner)
        addSubview(pageControl)
        banner.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(banner)
            make.height.equalTo(20)
        }
        
        banner.delegate = self
        banner.dataSource = self
    }

}

extension HomeBannerView: FSPagerViewDelegate, FSPagerViewDataSource {
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return datas.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: R.nib.homeBannerCollectionViewCell.identifier, at: index) as! HomeBannerCollectionViewCell
        let model = datas[index]

//        if let url = URL(string: model.appImageUrl) {
//            cell.imageView?.kf.setImage(with: url)
//            if model.appImageUrl.isEmpty {
//                if let imageUrl = URL(string: model.imageUrl) {
//                    cell.imageView?.kf.setImage(with: imageUrl)
//                }
//            }
//        }
        if let url = URL(string: model.appImageUrl) {
            if model.appImageUrl.isEmpty {
                if let imageUrl = URL(string: model.imageUrl) {
                    cell.imageView?.kf.setImage(with: imageUrl)
                }
            }else{
                cell.imageView?.kf.setImage(with: url)
            }
        }else{
            if let imageUrl = URL(string: model.imageUrl) {
                cell.imageView?.kf.setImage(with: imageUrl)
            }
        }
        return cell
    }
    
    // MARK:- FSPagerView Delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        self.pageControl.currentPage = index
        let model = datas[index]
        switch model.linkType {
            //产品
        case 1:
            let vc = R.storyboard.home.courseDetailViewController()!
            vc.productID = model.productID.toString()
            vc.productType = model.linkType
            CurrentControllerHelper.pushViewController(viewController: vc)
        case 2:
            if let url = URL(string: model.imageUrl) {
                BrowserHelper.showURL(url: url)
            }
        case 3:
            let vc = R.storyboard.news.newsDetailViewController()!
            vc.pageID = model.pageID.string
            CurrentControllerHelper.pushViewController(viewController: vc)
        default:
            break
        }
        
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.pageControl.currentPage != pagerView.currentIndex else {
            return
        }
        self.pageControl.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
    }
}
