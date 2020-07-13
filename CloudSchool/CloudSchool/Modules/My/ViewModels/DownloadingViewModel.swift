//
//  DownloadingViewModel.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/23.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import Tiercel

class DownloadingViewModel: NSObject {
    let disposeBag = DisposeBag()
    
    var data: Variable<[DownloadInfoModel]> = Variable([])
    
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
        let array = DownloadManager.shared.downloadingArray
        self.data.value = DownloadManager.shared.downloadingArray.map({ (object) -> DownloadInfoModel in
            return DownloadInfoModel(task: object)
        })
        print(self.data.value)
    }
    
}

class DownloadInfoModel: NSObject {
    var progress: Variable<Float> = Variable(0)
    var speed: Variable<String> = Variable("")
    var totalSize: Variable<String> = Variable("")
    let disposeBag: DisposeBag = DisposeBag()
    
    var path: String? {
        return DownloadManager.shared.downloadManager.cache.filePtah(URLString: self.request.url.absoluteString)
    }
    
    var request: TRTask
    
    init(task: TRTask) {
        self.request = task
        super.init()
        self.progress.value = Float(task.progress.fractionCompleted)
        self.totalSize.value = task.progress.totalUnitCount.tr.convertBytesToString()
        task.progress {[weak self] (t) in
            guard let `self` = self else { return }
            self.progress.value = Float(t.progress.fractionCompleted)
            self.speed.value = t.speed.tr.convertSpeedToString()
            self.totalSize.value = t.progress.totalUnitCount.tr.convertBytesToString()
        }
        self.totalSize.value = task.progress.totalUnitCount.tr.convertBytesToString()
        DownloadManager.shared.updateDownloadModel
            .asObservable()
            .subscribe(onNext: {[weak self] (value) in
                guard let `self` = self else { return }
                guard let value = value else { return }
                self.updateModel(model: value)
            })
            .disposed(by: disposeBag)
    }
    
    func updateModel(model: TRTask) {
        guard self.request == model else {
            return
        }
    }
    
    
    
    
}


enum ValidatedType {
    
    case email
    
    case phoneNumber
    
    var pattern: String {
        switch self {
        case .email:
            return "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        case .phoneNumber:
            return "^1[0-9]{10}$"
        }
    }
    
}

extension String {
    func isValidate(_ type: ValidatedType) -> Bool {
        do {
            
            let pattern: String = type.pattern
            let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            
            let matches = regex.matches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, self.count))
            
            return matches.count > 0
            
        }
            
        catch {
            
            return false
            
        }
    }
}
