//
//  IMCustomOptionView.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/2/19.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class IMCustomOptionView: UIView {
    public var IMCustomOptionViewDismissBlock:(()->())?
    public var noTalkBlock:(()->())?
    lazy var whiteBGView : UIView = {
        let viewH = 100/WIDTH_6_SCALE
        let viewY = SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT) - viewH
        var whiteBGView = UIView.init(frame: CGRect(x: 0, y: viewY, width: SCREEN_WIDTH, height: viewY))
        whiteBGView.backgroundColor = .white
        return whiteBGView
    }()
    lazy var noTalkBtn : UIButton = {
        var noTalkBtn = UIButton.init(frame: CGRect(x: 20/WIDTH_6_SCALE, y: 20/WIDTH_6_SCALE, width: 90/WIDTH_6_SCALE, height: 40/WIDTH_6_SCALE))
        noTalkBtn.setTitle("禁言", for: .normal)
        noTalkBtn.setTitleColor(UIColor.white, for: .normal)
        noTalkBtn.titleLabel?.font = DEF_FontSize_14
        noTalkBtn.setBackgroundColor(UIColor.colorWithHex(hex: "778692"), forState: .normal)
        noTalkBtn.layer.cornerRadius = 6
        noTalkBtn.layer.masksToBounds = true
        noTalkBtn.addTarget(self, action: #selector(noTalkBtnClick), for: .touchUpInside)
        return noTalkBtn
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        let btn = UIButton.init(frame: self.bounds)
        btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        self.addSubview(btn)
        self.addSubview(self.whiteBGView)
        self.backgroundColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9)
        self.whiteBGView.addSubview(self.noTalkBtn)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func btnClick(btn:UIButton){
        self.dismissView()
    }
    func dismissView(){
        self.IMCustomOptionViewDismissBlock!()
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
    @objc func noTalkBtnClick(){
        self.noTalkBlock?()
    }
}
