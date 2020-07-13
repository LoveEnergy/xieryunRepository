//
//  HomePageADView.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/5/20.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class HomePageADView: UIView {
    public var homePageADViewDismissBlock:(()->())?
    lazy var whiteBGView : UIView = {
        let viewWidth = CGFloat(SCREEN_WIDTH - 50/WIDTH_6_SCALE)
        var whiteBGView = UIView.init(frame: CGRect(x: (SCREEN_WIDTH - viewWidth)/2, y: 200.0/WIDTH_6_SCALE, width: viewWidth, height: 200.0/WIDTH_6_SCALE))
        whiteBGView.backgroundColor = .white
        whiteBGView.layer.cornerRadius = 6
        whiteBGView.layer.masksToBounds = true
        return whiteBGView
    }()
    lazy var topImgView : UIImageView = {
        weak var weakSelf = self
        var topImgView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: (weakSelf?.whiteBGView.width)!, height: 80/WIDTH_6_SCALE))
        topImgView.image = UIImage.init(named: "goodsdetail_live_invite_code_bg")
        return topImgView
    }()
    lazy var closeBtn : UIButton = {
        weak var weakSelf = self
        let btnW = 25/WIDTH_6_SCALE
        var closeBtn = UIButton.init(frame: CGRect(x: (weakSelf?.whiteBGView.width)! - 5/WIDTH_6_SCALE - btnW, y: 5/WIDTH_6_SCALE, width: btnW, height: btnW))
        closeBtn.setImage(UIImage.init(named: "goodsdetail_x"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        return closeBtn
    }()
    lazy var titleLab : UILabel = {
        weak var weakSelf = self
        var titleLab = UILabel.init(frame: CGRect(x: 0, y: (weakSelf?.topImgView.bottom)!, width: (weakSelf?.whiteBGView.width)!, height: (weakSelf?.whiteBGView.height)! - (weakSelf?.topImgView.bottom)!))
        titleLab.font = DEF_FontSize_14
        titleLab.backgroundColor = .clear
        titleLab.textColor = .black
        titleLab.textAlignment = .center
        titleLab.text = "广告说明初版展示"
        titleLab.lineBreakMode = .byWordWrapping
        titleLab.numberOfLines = 0
        return titleLab
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9)
        let btn = UIButton.init(frame: self.bounds)
        self.addSubview(btn)
        btn.addSubview(self.whiteBGView)
        self.whiteBGView.addSubview(self.topImgView)
        self.whiteBGView.addSubview(self.closeBtn)
        self.whiteBGView.addSubview(self.titleLab)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func closeBtnClick(){
        self.homePageADViewDismissBlock?()
    }
    
    func showView(){
        //获取delegate
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        //添加视图
        delegate.window?.addSubview(self)
        UIView.animate(withDuration: 0.15) {
            self.alpha = 1
        }
    }
}
