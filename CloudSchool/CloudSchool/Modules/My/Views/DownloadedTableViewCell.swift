//
//  DownloadedTableViewCell.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/27.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwipeCellKit

class DownloadedTableViewCell: SwipeTableViewCell {
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var sizeLabel: UILabel!
    
    let disposeBag: DisposeBag = DisposeBag()
    var model: DownloadInfoModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            super.setSelected(false, animated: true)
        }
        // Configure the view for the selected state
    }
    
    func configure(model: DownloadInfoModel) {
        self.model = model
        //        stateLabel.text = model.model.status
        //        if model.model.status == "Downloading", let speed = model.model.speed {
        //            stateLabel.text = String(format: "%.2f %@", speed.speed, speed.unit)
        //        }
        //        if let size = model.model.file {
        //            sizeLabel.text = String(format: "%.2f %@", size.size, size.unit)
        //        }
        //
        //        progressBar.progress = model.model.progress
        model.totalSize.asObservable()
            .subscribe(onNext: {[weak self] (value) in
                guard let `self` = self else { return }
                self.sizeLabel.text = value
            })
            .disposed(by: disposeBag)
        
        if let dataModel = DownloadManager.shared.getModelInfo(url: model.request.URLString) {
            thumbImageView.loadImage(string: dataModel.thumbnailUrl)
            nameLabel.text = dataModel.coursewareName
            
        }
        
    }
    
    func delete() {
        if let model = self.model {
            DownloadManager.shared.removeFile(task: model.request)
            HUD.showText(text: "删除成功")
        }
        
    }
    
}

extension DownloadedTableViewCell: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .default, title: "删除") {[weak self] action, indexPath in
            self?.delete()
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        deleteAction.backgroundColor = UIColor.mainRedColor
        deleteAction.textColor = UIColor.white
        return [deleteAction]
    }
    
    
    
}
