//
//  DownloadingTableViewCell.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/10/29.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DownloadingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet var sizeLabel: UILabel!
    @IBOutlet var progressBar: UIProgressView!
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        model.progress.asObservable()
            .subscribe(onNext: {[weak self] (value) in
                guard let `self` = self else { return }
                self.progressBar.progress = value
                print("进度\(value)")
            })
            .disposed(by: disposeBag)
        
        model.speed.asObservable()
            .subscribe(onNext: {[weak self] (value) in
                guard let `self` = self else { return }
                self.stateLabel.text = value
            })
            .disposed(by: disposeBag)
        
        model.totalSize.asObservable()
            .subscribe(onNext: {[weak self] (value) in
                guard let `self` = self else { return }
                self.sizeLabel.text = value
            })
        .disposed(by: disposeBag)
        
        if let dataModel = DownloadManager.shared.getModelInfo(url: model.request.URLString) {
            thumbImageView.loadImage(string: dataModel.thumbnailUrl)
            
        }
    }
}
