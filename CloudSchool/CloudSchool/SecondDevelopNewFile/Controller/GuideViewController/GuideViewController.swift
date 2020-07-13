//
//  GuideViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/5/25.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {
    var window: UIWindow?
    let numOfPages = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.pageControl)
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.startBtn)
        if Is_Iphone_X  {
            for index  in 0..<numOfPages {
                let imageView = UIImageView(image: UIImage(named: "GuideImageX-\(index + 1)"))
                imageView.frame = CGRect(x: SCREEN_WIDTH * CGFloat(index), y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
                scrollView.addSubview(imageView)
            }
        }else{
            for index  in 0..<numOfPages {
                let imageView = UIImageView(image: UIImage(named: "GuideImage8-\(index + 1)"))
                imageView.frame = CGRect(x: SCREEN_WIDTH * CGFloat(index), y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
                scrollView.addSubview(imageView)
            }
        }
    }
    
    lazy var startBtn : UIButton = {
        weak var weakSelf = self
        let btnH = CGFloat(67.5*375/562.5)
        var startBtn = UIButton.init(frame: CGRect(x: 0, y: weakSelf!.pageControl.top - btnH - CGFloat(55.5*375/562.5), width: CGFloat(300*375/562.5), height: btnH))
        startBtn.setTitle("立即体验", for: .normal)
        startBtn.setTitleColor(UIColor.white, for: .normal)
        startBtn.titleLabel?.font = DEF_FontSize_24
        startBtn.setBackgroundColor(UIColor.colorWithHex(hex: "089EFF"), forState: .normal)
        startBtn.addTarget(self, action: #selector(startBtnClick), for: .touchUpInside)
        startBtn.alpha = 0.0
        startBtn.centerX = SCREEN_WIDTH/2
        startBtn.layer.cornerRadius = btnH/2
        startBtn.layer.masksToBounds = true
        return startBtn
    }()
    
    lazy var scrollView : UIScrollView = {
        var scrollView = UIScrollView.init(frame: self.view.bounds)
        scrollView.backgroundColor = UIColor.orange
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.contentOffset = CGPoint.zero
        // 将 scrollView 的 contentSize 设为屏幕宽度的3倍(根据实际情况改变)
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH * CGFloat(numOfPages), height: SCREEN_HEIGHT)
        scrollView.delegate = self
        return scrollView
    }()
    
    lazy var pageControl : UIPageControl = {
        var pageControl = UIPageControl.init(frame: CGRect(x: 0, y: SCREEN_HEIGHT - CGFloat(80*375/562.5), width: SCREEN_WIDTH, height: 30/WIDTH_6_SCALE))
        pageControl.backgroundColor = UIColor.clear
        pageControl.numberOfPages = numOfPages
        pageControl.currentPage = 0
        return pageControl
    }()
    
    @objc func startBtnClick(){
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        let vc = storyBoard.instantiateInitialViewController()
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }
}
// MARK: - UIScrollViewDelegate
extension GuideViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        // 随着滑动改变pageControl的状态
        pageControl.currentPage = Int(offset.x / view.bounds.width)
        // 因为currentPage是从0开始，所以numOfPages减1
        if pageControl.currentPage == numOfPages - 1 {
            UIView.animate(withDuration: 0.5, animations: {
                self.startBtn.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.startBtn.alpha = 0.0
            })
        }
    }
}
