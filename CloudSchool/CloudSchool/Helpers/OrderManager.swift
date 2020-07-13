//
//  OrderManager.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/3/16.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OrderManager: NSObject {
    
    var refreshSignal: PublishSubject<Void> = PublishSubject<()>()
    
    static let shared: OrderManager = OrderManager()

}
