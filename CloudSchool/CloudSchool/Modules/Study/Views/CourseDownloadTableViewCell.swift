//
//  CourseDownloadTableViewCell.swift
//  CloudSchool
//
//  Created by Maynard on 2019/1/2.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import Tiercel

class CourseDownloadTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    
    var task: TRTask? {
        didSet {
            self.task?.progress({ (t) in
                print("下载进行")
                self.statusLabel.text =
                    String(format: "%.2f %%", Float(t.progress.fractionCompleted * 100))
                self.statusLabel.isHidden = false
                self.downloadButton.isHidden = true
            })
            self.task?.success({ (t) in
                print("下载成功")
                self.statusLabel.text = "已下载"
                self.statusLabel.isHidden = false
                self.downloadButton.isHidden = true
            })
            self.task?.failure({ (t) in
                print("下载失败")
            })
            
            guard let t = self.task else {
                self.statusLabel.isHidden = true
                self.downloadButton.isHidden = false
                return
            }
            switch t.status {
            case .completed:
                self.statusLabel.text = "已下载"
                self.statusLabel.isHidden = false
                self.downloadButton.isHidden = true
            default:
                self.statusLabel.text = "已下载"
                self.statusLabel.isHidden = true
                self.downloadButton.isHidden = false
                break
            }
        }
    }
    
    var model: CourseWareModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseConfigure()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func baseConfigure() {
        downloadButton.addTarget(self, action: #selector(downloadButtonClick), for: .touchUpInside)
    }
    
    @objc func downloadButtonClick() {
        guard let model = self.model else {
            return
        }
        guard let url = URL(string: model.standardVideUrl) else {
            return
        }
        self.task = DownloadManager.shared.addDownloadTask(url: url.absoluteString, model: model)
        if model.standardVideUrl.isEmpty {
            self.task = DownloadManager.shared.addDownloadTask(url: URL(string: model.highVideUrl ?? "")!.absoluteString, model: model)
        }
    }
    
    
    func configure(model: CourseWareModel) {
        self.model = model
        self.nameLabel.text = model.coursewareName
        self.timeLabel.text = model.duration
        if model.playbackCourseID != 0 {
            self.nameLabel.text = model.playbackCourseName
        }
        self.task = DownloadManager.shared.downloadManager.fetchTask(model.standardVideUrl)
        if model.standardVideUrl.isEmpty {
            self.task = DownloadManager.shared.downloadManager.fetchTask(model.highVideUrl)
        }
        
    }
}
