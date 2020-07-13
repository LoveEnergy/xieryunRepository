//
//  GenderViewModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/11/17.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift

enum Gender: String {
    case male = "男"
    case female = "女"
    
}

class GenderViewModel: NSObject, BaseActionSheetViewDelegate {
    var gender: Variable<Gender> = Variable(Gender.male)
    
    override init() {
        super.init()
        
    }
    
    func clickToChange() {
        let action = BaseActionSheetView.loadXib()
        action.title = "性别"
        action.actionTitles = ["男", "女"]
        action.delegate = self
        action.popShow()
        
    }
    
    func baseActionSheetDidSelect(index: Int) {
        gender.value = index == 0 ? Gender.male : Gender.female
    }
}
