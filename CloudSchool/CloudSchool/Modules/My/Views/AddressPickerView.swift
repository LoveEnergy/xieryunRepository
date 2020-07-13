//
//  AddressPickerView.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/11/18.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class AddressPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var provinceList: [RegionModel] = AddressManager.shared.provinceList
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return provinceList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return provinceList[row].regionName
    }
    

}
