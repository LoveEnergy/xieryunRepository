//
//  IMConversationModel.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/2/14.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit
import Foundation
class IMConversationModel: NSObject {
    var emModel : EMConversation
    var name : String = ""
    init(aModel : EMConversation) {
        self.emModel = aModel
        self.name = aModel.conversationId
        super.init()
        
    }
    
}
