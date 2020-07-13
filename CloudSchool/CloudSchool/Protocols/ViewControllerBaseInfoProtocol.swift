//
//  ViewControllerBaseInfoProtocol.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/13.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

protocol ViewControllerBaseInfoProtocol {
    var title: String { get }
    var backgroudColor: UIColor { get }
}

extension ViewControllerBaseInfoProtocol {
    var backgroudColor: UIColor { return UIColor.backgroundColor }
}
