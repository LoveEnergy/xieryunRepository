////
////  AliyunPlayerViewControlView.swift
////  CloudSchool
////
////  Created by Maynard on 2018/12/29.
////  Copyright © 2018 CEI. All rights reserved.
////
//
//import UIKit
//import AliyunPlayerSDK
//import AliyunVodPlayerSDK
//
//class AliyunPlayerViewControlView: UIView {
//    
//    var topView: AliyunPlayerViewTopView = AliyunPlayerViewTopView()
//    var bottomView: AliyunPlayerViewBottomView = AliyunPlayerViewBottomView()
//    var gestureView: AliyunPlayerViewGestureView = AliyunPlayerViewGestureView()
//    
//    var isHiddenView: Bool = false
//    
//    var lockButton: UIButton = {
//        let button = UIButton(type: .custom)
//        return button
//    }()
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        baseConfigure()
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        baseConfigure()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func baseConfigure() {
//        addSubview(topView)
//        addSubview(bottomView)
//        
//        topView.snp.makeConstraints { (make) in
//            make.left.top.right.equalTo(self)
//            make.height.equalTo(60)
//        }
//        
//        bottomView.snp.makeConstraints { (make) in
//            make.right.bottom.left.equalTo(self)
//            make.height.equalTo(60)
//        }
//    }
//    
//    func updateViewWithPlayerState(state: AliyunVodPlayerState, isScreenLocked: Bool, fixedPortrait: Bool) {
//        switch state {
//        case .idle, .loading:
//            self.gestureView.enableGesture = false
//        default:
//            self.gestureView.enableGesture = true
//        }
//        if isScreenLocked || fixedPortrait {
//            self.gestureView.enableGesture = false
//        }
//        self.bottomView.updateView(state: state)
//    }
//    
//}
//
//
