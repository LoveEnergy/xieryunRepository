//
//  CourseCardTableViewCell.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/3/20.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit

class CourseCardTableViewCell: UITableViewCell {
    public var activeCardBlock:(()->())?//激活开课卡
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.addSubview(self.statusBtn)
        //背景左右各距离屏幕11，上下20
        let btnWBorder: CGFloat = 80.0
        let btnYBorder: CGFloat = 30.0
        self.statusBtn.frame = CGRect(x: SCREEN_WIDTH - 11 - 10 - btnWBorder, y: 80, width: btnWBorder, height: btnYBorder)
        self.statusBtn.layer.cornerRadius = 4
        self.statusBtn.layer.masksToBounds = true
        self.statusBtn.isHidden = true
    }
    
    lazy var statusBtn : UIButton = {
        var btn = UIButton.init()
        btn.setTitle("立即激活", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = DEF_FontSize_13
        btn.setBackgroundColor(UIColor.colorWithHex(hex: "0378FD"), forState: .normal)
        btn.addTarget(self, action: #selector(statusBtnClick), for: .touchUpInside)
        return btn
    }()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(model: CardInfo) {
        self.cardNumberLabel.text = model.cardNo
        self.endDateLabel.text = model.createTime
        self.descriptionLabel.text = model.productName
        //status:0未激活、1已激活
//        if model.status == 0 {
//            self.statusBtn.isHidden = true
//        }else{
//            self.statusBtn.isHidden = false
//        }
    }
    
    @objc func statusBtnClick(){
        self.activeCardBlock?()
    }
}
