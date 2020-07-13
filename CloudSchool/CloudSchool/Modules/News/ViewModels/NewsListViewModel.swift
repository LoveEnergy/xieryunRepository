//
//  NewsListViewModel.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/30.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewsListViewModel: NSObject, ViewControllerBaseInfoProtocol {
    var title: String { return "资讯" }
    let disposeBag: DisposeBag = DisposeBag()
    
    
    var data: Variable<[PageModel]> = Variable([])
    
    override init() {
        super.init()
        loadData()
    }
    
    func loadData() {
        RequestHelper.shared.getPageList(type: 2, pageNo: 1, pageSize: 20)
        .asObservable()
            .subscribe(onNext: { (model) in
                guard let data = model.data?.rows else { return }
                self.data.value = data
            })
        .disposed(by: disposeBag)
    }

}
