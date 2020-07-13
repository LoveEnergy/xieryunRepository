//
//  DownloadedViewModel.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/27.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MZDownloadManager

class DownloadedViewModel: NSObject {
    var downloadedFilesArray : Variable<[String]> = Variable([])
    
    var data: Variable<[DownloadInfoModel]> = Variable([])
    let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        
        self.update()
        DownloadManager.shared.refreshSignal
            .asObservable()
            .subscribe(onNext: {[weak self] () in
                guard let `self` = self else { return }
                self.update()
            })
            .disposed(by: disposeBag)
    }
    
    func update() {
        data.value = DownloadManager.shared.downloadedArray.map({ (task) -> DownloadInfoModel in
            return DownloadInfoModel(task: task)
        })
        print(data.value)
    }
}
