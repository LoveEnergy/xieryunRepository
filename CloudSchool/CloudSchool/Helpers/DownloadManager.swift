//
//  DownloadManager.swift
//  CloudSchool
//
//  Created by Maynard on 2018/3/1.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Tiercel
import ObjectMapper

class DownloadManager: NSObject {
    static let shared: DownloadManager = DownloadManager()
    
    var downloadingNumber: Variable<Int> = Variable(0)
    var downloadedNumber: Variable<Int> = Variable(0)
    var refreshSignal: PublishSubject<Void> = PublishSubject<()>()
    
    
    private let downloadArrayKey: String = "VideoDownloadArray"
    
//    let myDownloadPath = MZUtility.baseFilePath + "/Downloads"
    
    lazy var downloadManager: TRManager = {
        return TRManager("video", MaximumRunning: 3, isStoreInfo: true)
    }()
    
    var downloadingArray: [TRTask] {
        return downloadManager.tasks.filter({ (task) -> Bool in
            return task.status == TRStatus.running || task.status == TRStatus.suspend
        })
    }
    
    var downloadedArray: [TRTask] {
        return downloadManager.tasks.filter({ (task) -> Bool in
            return task.status == TRStatus.completed
        })
    }

    var updateDownloadModel: Variable<TRTask?> = Variable(nil)
    
    override init() {
        super.init()
        self.updateNumber()
//        createDirectory()
    }
    
//    private func createDirectory() {
//        if !FileManager.default.fileExists(atPath: myDownloadPath) {
//            try! FileManager.default.createDirectory(atPath: myDownloadPath, withIntermediateDirectories: true, attributes: nil)
//        }
//        debugPrint("custom download path: \(myDownloadPath)")
//    }
    
    func updateNumber() {
        self.downloadedNumber.value = self.downloadedArray.count
    }
    
    func suspendTask(task: TRTask) {
        downloadManager.suspend(task.URLString)
    }
    
    func startTask(task: TRTask) {
        downloadManager.start(task.URLString)
    }
    
    func addDownloadTask(url: String, model: CourseWareModel) -> TRTask? {
        var fileName : NSString = (url as NSString).lastPathComponent as NSString
        if var dic = UserDefaults.standard.dictionary(forKey: self.downloadArrayKey) {
            dic[url] = model.toJSONString() ?? ""
            UserDefaults.standard.set(dic, forKey: self.downloadArrayKey)
        } else {
            var dic: [String: String] = [:]
            dic[url] = model.toJSONString() ?? ""
            UserDefaults.standard.set(dic, forKey: self.downloadArrayKey)
        }
        
        return downloadManager.download(url)
    }
    
    func getModelInfo(url: String) -> CourseWareModel? {
        if var dic = UserDefaults.standard.dictionary(forKey: self.downloadArrayKey) {
            if let jsonString = dic[url] as? String, let model = CourseWareModel(JSONString: jsonString) {
                return model
            }
        }
        return nil
    }
    
    func removeFile(task: TRTask) {
        self.downloadManager.remove(task.URLString, completely: true)
        self.refreshSignal.onNext(())
    }
}


