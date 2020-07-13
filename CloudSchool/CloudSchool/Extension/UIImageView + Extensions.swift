//
//  UIImageView + Extensions.swift
//  CloudSchool
//
//  Created by Maynard on 2018/10/30.
//  Copyright © 2018 CEI. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(string: String?) {
        guard let string = string, let url = URL(string: string) else {
            return
        }
        self.kf.setImage(with: url, placeholder: R.image.default_image())
    }
}
