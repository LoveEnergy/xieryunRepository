//
//  NestedListView.swift
//  CloudSchool
//
//  Created by Maynard on 2018/12/26.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

protocol NestedListViewDelegate: class {
    func createListView(page: Int) -> UIScrollView
}

class NestedListView: UIScrollView {
    
    static let listStartTag = 100001
    
    var totalPage: Int = 0 {
        didSet {
            self.contentSize = CGSize(width: CGFloat(totalPage) * kScreenWidth, height: 0)
        }
    }
    var currentPage: Int {
        return Int(self.contentOffset.x / self.width)
    }
    var changePageAnimate: Bool = true
    var nestDelegate: NestedListViewDelegate?
    
    var changedPage: ((Int) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseConfigure()
    }
    
    func baseConfigure() {
        bounces = false
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = self
        backgroundColor = .white
    }
    

    func scrollToPage(_ page: Int) {
        guard totalPage > 0 else {
            return
        }
        
        let tag = page + NestedListView.listStartTag
        if let view = self.viewWithTag(tag) {
            self.setContentOffset(CGPoint(x: CGFloat(page) * self.width, y: 0), animated: self.changePageAnimate)
        } else {
            guard let nestDelegate = self.nestDelegate else { return }
            let listView = nestDelegate.createListView(page: page)
            listView.tag = tag
            self.addSubview(listView)
            listView.snp.makeConstraints { (make) in
                make.left.equalTo(CGFloat(page) * self.width)
                make.size.equalTo(self)
                make.top.equalTo(0)
            }
        }
        self.setContentOffset(CGPoint(x: CGFloat(page) * self.width, y: 0), animated: self.changePageAnimate);
    }
    
    func reload() {
        self.removeSubviews()
        self.scrollToPage(0)
    }
    
    func listView(page: Int) -> UIScrollView? {
        let tag = page + NestedListView.listStartTag
        return self.viewWithTag(tag) as? UIScrollView
    }
    
    func allListView() -> [UIScrollView] {
        return []
    }

}

extension NestedListView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        if self.totalPage <= 0 && offsetX != 0 {
            scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(self.contentOffset.x / self.width)
        self.changedPage?(page)
        self.scrollToPage(page)
    }
    
}
