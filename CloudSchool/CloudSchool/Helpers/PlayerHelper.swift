//
//  PlayerHelper.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/27.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import ZFPlayer

class PlayerHelper: NSObject {
    class func playFile(path: String) {
        let vc = R.storyboard.videoPlayer.videoPlayerViewController()!
        CurrentControllerHelper.pushViewController(viewController: vc)
        vc.path = path
    }
}
