//
//  ProductListViewModel.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/14.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift

class ProductListViewModel: NSObject, ViewControllerBaseInfoProtocol {
    var title: String = ""
    let disposeBag = DisposeBag()
    
    init(title: String) {
        self.title = title
    }
    
    func loadData() {
        RequestHelper.shared.getCoursesProductList(id: "", type: "", classType: "", seriesID: "", pageNo: "", pageSize: "")
        .asObservable()
            .subscribe(onNext: { (list) in
                
            }, onError: { (error) in
                
            })
        .disposed(by: disposeBag)
    }

}
