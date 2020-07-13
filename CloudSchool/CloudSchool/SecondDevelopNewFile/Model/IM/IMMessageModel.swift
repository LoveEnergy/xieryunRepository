//
//  IMMessageModel.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/2/14.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit
import Foundation

enum EMMessageType {
    case EMMessageTypeText
    case EMMessageTypeImage
    case EMMessageTypeVideo
    case EMMessageTypeLocation
    case EMMessageTypeVoice
    case EMMessageTypeFile
    case EMMessageTypeCmd
    case EMMessageTypeExtGif
    case EMMessageTypeExtRecall
    case EMMessageTypeExtCall
}

class IMMessageModel: NSObject {
    
    var readReceiptCount = ""
    var emModel: EMMessage
    var direction: EMMessageDirection
    var type: EMMessageType
    var isPlaying: Bool = true
    init(aMsg: EMMessage) {
        self.emModel = aMsg
        self.direction = aMsg.direction
        if aMsg.body.type == EMMessageBodyTypeText {
            var extGif = 0
            var extRecall = 0
            var conferenceId = ""
            if aMsg.ext != nil{
                for (key, value) in aMsg.ext {
                    if key as! String == "em_is_big_expression" {
                        if let extGifTemp = aMsg.ext["em_is_big_expression"]{
                            extGif = extGifTemp as! Int
                        }
                    }
                    if key as! String == "em_recall"{
                        if let extRecallTemp = aMsg.ext["em_recall"]{
                            extRecall = extRecallTemp as! Int
                        }
                    }
                    if key as! String == "em_conference_id"{
                        if let conferenceIdTemp = aMsg.ext["em_conference_id"]{
                            conferenceId = conferenceIdTemp as! String
                        }
                    }
                }
            }
            
            if extGif != 0 {
                self.type = EMMessageType.EMMessageTypeExtGif
            }else if extRecall != 0{
                self.type = EMMessageType.EMMessageTypeExtRecall
            }else{
                if conferenceId.count == 0 {
//                    conferenceId = aMsg.ext[MSG_EXT_CALLID] as? String ?? ""
                    conferenceId = ""
                }
                if conferenceId.count > 0{
                    self.type = EMMessageType.EMMessageTypeExtCall
                }else{
                    self.type = EMMessageType.EMMessageTypeText
                }
            }
        }else{
            self.type = EMMessageType.EMMessageTypeImage
        }
        super.init()
    }
}
