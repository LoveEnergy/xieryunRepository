//
//  UmengHelper.swift
//  CloudSchool
//
//  Created by Maynard on 2019/4/24.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit

class UmengHelper: NSObject {
    static func configure() {
        #if DEBUG
        UMConfigure.initWithAppkey(AppID.UMeng.appKey, channel: "Debug")
        #else
        UMConfigure.initWithAppkey(AppID.UMeng.appKey, channel: "App Store")
        #endif
        
    }
}
