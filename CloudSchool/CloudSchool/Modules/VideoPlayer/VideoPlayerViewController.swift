//
//  VideoPlayerViewController.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/27.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import ZFPlayer

class VideoPlayerViewController: UIViewController {

    @IBOutlet weak var playerView: UIView!
    var player: ZFPlayerController!
    var path: String?
    
    var controlView: ZFPlayerControlView = {
        let view = ZFPlayerControlView()
        view.fastViewAnimated = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let manager = ZFAVPlayerManager()
        player = ZFPlayerController(playerManager: manager, containerView: playerView)
        player.controlView = self.controlView
        if let path = path {
            let url = URL(fileURLWithPath: path)
            player.assetURL = url
            player.shouldAutoPlay = true
        }
        
    }

}
