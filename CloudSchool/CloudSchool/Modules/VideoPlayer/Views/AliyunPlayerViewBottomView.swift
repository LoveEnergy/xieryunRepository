////
////  AliyunPlayerViewBottomView.swift
////  CloudSchool
////
////  Created by Maynard on 2018/12/29.
////  Copyright © 2018 CEI. All rights reserved.
////
//
//import UIKit
//import SnapKit
//import AliyunVodPlayerSDK
//import AliyunPlayerSDK
//
//protocol AliyunVodBottomViewDelegate {
//    func aliyunVodBottomViewDragProgress(bottomView: AliyunPlayerViewBottomView, progress: Float, event: UIControl.Event)
//    
//    func aliyunVodBottomViewClickPlayButton(bottomView: AliyunPlayerViewBottomView)
//    
//    func aliyunVodBottomViewClickFullScreenButton(bottomView: AliyunPlayerViewBottomView)
//}
//
//class AliyunPlayerViewBottomView: UIView {
//
//    var playButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.setImage(R.image.player_play_btn(), for: .normal)
//        button.setImage(R.image.player_pause_btn(), for: .normal)
//        return button
//    }()
//    
//    var fullButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.setImage(R.image.player_full_btn(), for: .normal)
//        button.setImage(R.image.player_small_btn(), for: .normal)
//        button.addTarget(self, action: #selector(clickFullScreen), for: .touchUpInside)
//        return button
//    }()
//    
//    var slider: UISlider = {
//        let slider = UISlider()
//        return slider
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
//        addSubview(playButton)
//        addSubview(fullButton)
//        addSubview(slider)
//        
//        playButton.snp.makeConstraints { (make) in
//            make.left.top.bottom.equalTo(self)
//            make.width.equalTo(60)
//        }
//        
//        fullButton.snp.makeConstraints { (make) in
//            make.right.top.bottom.equalTo(self)
//            make.width.equalTo(60)
//        }
//        
//        slider.snp.makeConstraints { (make) in
//            make.left.equalTo(playButton.snp.right)
//            make.right.equalTo(fullButton.snp.left)
//            make.top.bottom.equalTo(self)
//        }
//    }
//    
//    func updateView(state: AliyunVodPlayerState) {
//        
//    }
//    
//    @objc func clickFullScreen() {
//        
//    }
//    
//
//}
