//
//  AddressManager.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/11/11.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift

class AddressManager: NSObject {
    static let shared: AddressManager = AddressManager()
    var provinceList: [RegionModel] = []
    let disposeBag: DisposeBag = DisposeBag()
    
    override init() {
        super.init()
        UserHelper.shared.getProvinceList()
        .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                self.provinceList = list.data
            })
        .disposed(by: disposeBag)
    }
    
    func getProvinceList() -> [RegionModel] {
        return provinceList
    }
    
    func showActionSheet() {
        
    }
    
    func getRegionList(regionID: String) {
        UserHelper.shared.getCityList(regionID: regionID)
        .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                
            })
        .disposed(by: disposeBag)
    }
}
