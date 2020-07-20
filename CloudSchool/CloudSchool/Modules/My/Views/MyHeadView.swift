//
//  MyHeadView.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/10/18.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyHeadView: UIView {
    
    @IBOutlet weak var avatorImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var myVIPSign: UIImageView!
    @IBOutlet weak var yellowBGView: UIImageView!
    @IBOutlet weak var vipBtn: UIButton!
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromNib()
    }
    
    private func initViewFromNib(){
        // 需要这句代码，不能直接写UINib(nibName: "MyView", bundle: nil)，不然不能在storyboard中显示
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "MyHeadView", bundle: bundle)
        self.view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        self.view.frame = bounds
        self.addSubview(view)
        baseConfigure()
//        baseConfigure()
        // Do any additional setup after loading the view.
    }
    
    func baseConfigure() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapView))
        self.addGestureRecognizer(tap)
        vipBtn.addTarget(self, action: #selector(vipBtnClick), for: .touchUpInside)
        LoginHelper.shared.currentUser
        .asObservable()
            .subscribe(onNext: {[weak self] (info) in
                guard let `self` = self else { return }
                guard let info = info else {
                    self.loginButton.isHidden = false
                    self.avatorImageView.image = R.image.my_head()
                    self.nickNameLabel.isHidden = true
                    self.myVIPSign.isHidden = true
                    self.yellowBGView.image = UIImage.init(named: "my_no_vip_zone_bg")
                    return
                }
                self.loginButton.isHidden = true
                self.avatorImageView.loadImage(string: info.headUrl)
                self.nickNameLabel.isHidden = false
                self.myVIPSign.isHidden = true
                self.yellowBGView.image = UIImage.init(named: "my_no_vip_zone_bg")
                self.nickNameLabel.text = info.nickName
                if info.isMember == 1{
                    //是会员
                    self.myVIPSign.isHidden = false
                    self.yellowBGView.image = UIImage.init(named: "my_vip_zone_bg")
                }
            })
        .disposed(by: disposeBag)
    }
    
    @objc func tapView() {
        LoginHelper.checkLoginStatus {
            let vc = R.storyboard.my.userInfoViewController()!
            CurrentControllerHelper.pushViewController(viewController: vc)
        }
    }
    
    @objc func vipBtnClick(){
        LoginHelper.checkLoginStatus {
            let vc = MemberPublicityViewController.init()
            CurrentControllerHelper.pushViewController(viewController: vc)
        }
    }
}
