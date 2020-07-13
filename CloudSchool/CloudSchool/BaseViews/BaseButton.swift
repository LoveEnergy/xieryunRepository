//
//  BaseButton.swift
//  CloudSchool
//
//  Created by Maynard on 2018/10/11.
//  Copyright © 2018 CEI. All rights reserved.
//

import Foundation
import UIKit

struct Size {
    static func scale(size: CGFloat) -> CGFloat {
        if UIScreen.main.scale == 3 {
            return size
        }
        return size * 0.86
    }
}

enum ButtonSize: Int {
    case small
    case normal
    case large
    case extraLarge
    
    var height: CGFloat {
        switch self {
        case .small: return Size.scale(size: 32)
        case .normal: return Size.scale(size: 44)
        case .large: return  Size.scale(size: 50)
        case .extraLarge: return Size.scale(size: 64)
        }
    }
}

enum ButtonStyle: Int {
    case solid
    case squared
    case border
    case borderless
    
    var backgroundColor: UIColor {
        switch self {
        case .solid, .squared: return Colors.blue
        case .border, .borderless: return .white
        }
    }
    
    var backgroundColorHighlighted: UIColor {
        switch self {
        case .solid, .squared: return Colors.blue
        case .border: return Colors.blue
        case .borderless: return .white
        }
    }
    
    var backgroundColorDisabled: UIColor {
        return Colors.darkGray
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .solid, .border: return 5
        case .squared, .borderless: return 0
        }
    }
    
    var font: UIFont {
        switch self {
        case .solid,
             .squared,
             .border,
             .borderless:
            return UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .solid, .squared: return .white
        case .border, .borderless: return Colors.blue
        }
    }
    
    var textColorHighlighted: UIColor {
        switch self {
        case .solid, .squared: return UIColor(white: 1, alpha: 0.8)
        case .border: return .white
        case .borderless: return Colors.blue
        }
    }
    
    var borderColor: UIColor {
        switch self {
        case .solid, .squared, .border: return Colors.blue
        case .borderless: return .clear
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .solid, .squared, .borderless: return 0
        case .border: return 1
        }
    }
}

class BaseButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        apply(size: .normal, style: .solid)
    }
    
    func apply(size: ButtonSize, style: ButtonStyle) {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: size.height),
            ])
        
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius
        layer.borderColor = style.borderColor.cgColor
        layer.borderWidth = style.borderWidth
        layer.masksToBounds = true
        titleLabel?.textColor = style.textColor
        titleLabel?.font = style.font
        setTitleColor(style.textColor, for: .normal)
        setTitleColor(style.textColorHighlighted, for: .highlighted)
        setBackgroundColor(style.backgroundColorHighlighted, forState: .highlighted)
        setBackgroundColor(style.backgroundColorHighlighted, forState: .selected)
        setBackgroundColor(style.backgroundColorDisabled, forState: .disabled)
        
        contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
}


extension UIButton {
    func setBackgroundColor(_ color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
}
