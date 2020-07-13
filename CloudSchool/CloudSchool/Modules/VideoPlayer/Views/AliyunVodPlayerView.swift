////
////  AliyunVodPlayerView.swift
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
//class AliyunVodPlayerView: UIView {
//
//    var aliPlayer: AliyunVodPlayer = AliyunVodPlayer()
//    var coverImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
//    
//    var controlView: AliyunPlayerViewControlView = AliyunPlayerViewControlView()
//    var loadingView: AlilyunViewLoadingView = AlilyunViewLoadingView()
//    
//    var saveFrame: CGRect!
//    
//    var timer: Timer!
//    var currentDuration: TimeInterval!
//    var currentMediaTitle: String!
//    
//    var isProtrait: Bool = true
//    var isRetry: Bool = true
//    
//    var saveCurrentTime: Float!
//    var progressCanUpdate: Bool = false
//    
//    var currentPlayStatus: AliyunVodPlayerState = .loading
//    
//    
//    override var frame: CGRect {
//        didSet {
//            super.frame = frame
//            
//        }
//    }
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        baseConfigure()
//    }
//    
//    func baseConfigure() {
//        addSubview(self.aliPlayer.playerView)
//        addSubview(controlView)
//        
//        self.aliPlayer.delegate = self
//        self.aliPlayer.timeout = 2000
//        self.aliPlayer.dropBufferDuration = 8000
//        self.aliPlayer.isAutoPlay = true
//        self.aliPlayer.prepare(with: URL(string: "http://video.cei.net.cn/771e29c0ab0b408f83ab72fb042a76bb/736a323c12774923ace51b7dcd15c98d-e50b0a8fe1da4c7a705908640ff51788-ld.mp4")!)
//        
//    }
//    
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.aliPlayer.playerView.frame = self.bounds
//        controlView.frame = self.bounds
//    }
//    
//    func updateVodPlayerView(event: AliyunVodPlayerEvent, vodPlayer: AliyunVodPlayer) {
//        
//    }
//
//}
//
//extension AliyunVodPlayerView: AliyunVodPlayerDelegate {
//    func vodPlayer(_ vodPlayer: AliyunVodPlayer!, onEventCallback event: AliyunVodPlayerEvent) {
//        self.updateVodPlayerView(event: event, vodPlayer: vodPlayer)
//    }
//    
//    func vodPlayer(_ vodPlayer: AliyunVodPlayer!, playBack errorModel: AliyunPlayerVideoErrorModel!) {
//        
//    }
//    
//    
//}
