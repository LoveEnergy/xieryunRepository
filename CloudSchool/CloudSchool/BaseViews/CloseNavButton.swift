//
//  CloseNavButton.swift
//  CloudSchool
//
//  Created by Maynard on 2018/10/10.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class CloseNavButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        baseConfigure()
    }
    
    func baseConfigure() {
        setImage(R.image.common_close(), for: .normal)
        self.addTarget(self, action: #selector(dismissClick), for: .touchUpInside)
    }
    
    @objc func dismissClick() {
        CurrentControllerHelper.currentViewController().dismiss(animated: true, completion: nil)
    }

}
