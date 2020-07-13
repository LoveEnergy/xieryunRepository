//
//  UIView + Additions.swift
//  NewVersionTest-Swift
//
//  Created by ENERGY on 2019/12/2.
//  Copyright © 2019 ENERGY. All rights reserved.
//

import Foundation

import UIKit

//
//extension UIView {
//    public var left: CGFloat{
//        get{
//            return self.frame.origin.x
//        }
//        set{
//            var frame = self.frame
//            frame.origin.x = newValue
//            self.frame = frame
//        }
//    }
//
//    public var top: CGFloat{
//        get{
//            return self.frame.origin.y
//        }
//        set{
//            var frame = self.frame
//            frame.origin.y = newValue
//            self.frame = frame
//        }
//    }
//    public var right: CGFloat{
//        get{
//            return self.frame.origin.x + self.frame.size.width;
//        }
//        set{
//            var frame = self.frame
//            frame.origin.x = newValue - frame.size.width;
//            self.frame = frame
//        }
//    }
//
//    public var bottom: CGFloat{
//        get{
//            return self.frame.origin.y + self.frame.size.height;
//        }
//        set{
//            var frame = self.frame
//            frame.origin.y = newValue - frame.size.height;
//            self.frame = frame
//        }
//    }
//    
//    public var centerX: CGFloat{
//        get{
//            return self.center.x;
//        }
//        set{
//            var center = self.center
//            center.x = newValue
//            self.center = center
//        }
//    }
//    
//    public var centerY: CGFloat{
//        get{
//            return self.center.y;
//        }
//        set{
//            var center = self.center
//            center.y = newValue
//            self.center = center
//        }
//    }
//
//    public var width: CGFloat{
//        get{
//            return self.frame.size.width;
//        }
//        set{
//            var frame = self.frame
//            frame.size.width = newValue;
//            self.frame = frame
//        }
//    }
//
//    public var height: CGFloat{
//        get{
//            return self.frame.size.height;
//        }
//        set{
//            var frame = self.frame
//            frame.size.height = newValue;
//            self.frame = frame
//        }
//    }
//
//    public var origin: CGPoint{
//        get{
//            return self.frame.origin
//        }
//        set{
//            var frame = self.frame
//            frame.origin = newValue;
//            self.frame = frame
//        }
//    }
//
//    public var size: CGSize{
//        get{
//            return self.frame.size
//        }
//        set{
//            var frame = self.frame
//            frame.size = newValue;
//            self.frame = frame
//        }
//    }
//
//    func removeAllSubviews(){
//        while self.subviews.count > 0 {
//            let subView = self.subviews.first
//            subView?.removeFromSuperview()
//        }
//    }
//}
