//
//  AliPlayerViewController.swift
//  CloudSchool
//
//  Created by Maynard on 2018/12/18.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import AliyunPlayerSDK

class AliPlayerViewController: UIViewController {
    
    @IBOutlet weak var playerContentView: UIView!
    var player: AliVcMediaPlayer = AliVcMediaPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.player.create(self.playerContentView)
//        self.player.mediaType = MediaType_AUTO
//        self.player.timeout = 2000
//        self.player.dropBufferDuration = 8000
//        let error = self.player.prepare(toPlay: URL(string: "http://video.cei.net.cn/771e29c0ab0b408f83ab72fb042a76bb/736a323c12774923ace51b7dcd15c98d-e50b0a8fe1da4c7a705908640ff51788-ld.mp4")!)
//        self.player.play()
        // Do any additional setup after loading the view.
    }

}
