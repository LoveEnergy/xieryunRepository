//
//  LiveTableViewCell.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/7/7.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit

class LiveTableViewCell: UITableViewCell, CellMappable {
    public var goForfrequencyClickBlock:(()->())?
    public var goForFillSchoolRollBlock:(()->())?
    public var goForChangeInfoBlock:(()->())?
    public var playBackBlock:(()->())?
    
    var isFillSchoolRoll: Bool = false
    func configure(model: ClassModel) {
        thumbImageView.loadImage(string: model.thumbnailUrl)
        nameLabel.text = model.productName
        endTimeLabel.text = model.closeTime;
        progressTitleLabel.text = ""
        self.fillInSchoolRoll.isHidden = true
        self.playBackBtnLeft.constant = -70
        let btnW = self.playBackBtn.width
        if model.isNeedSchoolRoll == true && model.isHasSchoolRoll == false{//等于0需要填写学籍
            self.isFillSchoolRoll = true
        }else{
            if model.isNeedSchoolRoll == true && model.isHasSchoolRoll == true {
                self.fillInSchoolRoll.isHidden = false
                self.playBackBtnLeft.constant = 10
                self.playBackBtn.width = btnW
            }
            self.isFillSchoolRoll = false
        }
    }
    
    typealias Model = ClassModel
    @IBOutlet weak var progressTitleLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var fillInSchoolRoll: UIButton!//修改学籍
    @IBOutlet weak var goForStudy: UIButton!
    
    @IBOutlet weak var playBackBtnLeft: NSLayoutConstraint!
    @IBOutlet weak var playBackBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.fillInSchoolRoll.layer.borderWidth = 0.8
        self.fillInSchoolRoll.layer.borderColor = UIColor.colorWithHex(hex: "20a2f9").cgColor
        self.fillInSchoolRoll.layer.cornerRadius = 2
        self.fillInSchoolRoll.layer.masksToBounds = true
        self.fillInSchoolRoll.setTitleColor(UIColor.colorWithHex(hex: "20a2f9"), for: .normal)
        self.fillInSchoolRoll.addTarget(self, action: #selector(fillInSchoolRollBtnClick), for: .touchUpInside)
        self.goForStudy.addTarget(self, action: #selector(goForStudyBtnClick), for: .touchUpInside)
        
        self.playBackBtn.layer.borderWidth = 0.8
        self.playBackBtn.layer.borderColor = UIColor.colorWithHex(hex: "20a2f9").cgColor
        self.playBackBtn.layer.cornerRadius = 2
        self.playBackBtn.layer.masksToBounds = true
        self.playBackBtn.setTitleColor(UIColor.colorWithHex(hex: "20a2f9"), for: .normal)
        self.playBackBtn.addTarget(self, action: #selector(playBackBtnClick), for: .touchUpInside)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            super.setSelected(false, animated: true)
        }
    }
    
    @objc func fillInSchoolRollBtnClick(){
        self.goForChangeInfoBlock?()
    }
    
    @objc func goForStudyBtnClick(){
        if self.isFillSchoolRoll == false {
            self.goForfrequencyClickBlock?()
        }else{
            self.goForFillSchoolRollBlock?()
        }
    }
    
    @objc func playBackBtnClick(){
        self.playBackBlock?()
    }
}
