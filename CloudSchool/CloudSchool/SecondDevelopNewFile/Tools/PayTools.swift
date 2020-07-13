//
//  PayTools.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/6.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class PayTools: NSObject {
    class func getGoodsList(_ result: (Set<String>)->()) {
        result(["cei.studyCard.6", "cei.test.noSubscribe"])
    }
}
