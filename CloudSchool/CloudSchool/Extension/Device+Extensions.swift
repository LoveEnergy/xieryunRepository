//
//  Device+Extensions.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/10/28.
//  Copyright © 2018 CEI. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    //return MB
    func getTotalSize() -> Double {
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        guard let last = paths.last else { return 0 }
        do {
            let dic = try FileManager.default.attributesOfFileSystem(forPath: last)
            if let totalSize = dic[FileAttributeKey.systemSize] as? Double {
                return totalSize/1024.0/1024.0
            } else {
                return 0
            }
            
        } catch {
            return 0
        }
    
    }
    
    
    func getFreeSize() -> Double {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        guard let last = paths.last else { return 0 }
        do {
            let dic = try FileManager.default.attributesOfFileSystem(forPath: last)
            if let freeSize = dic[FileAttributeKey.systemFreeSize] as? Double {
                return freeSize/1024.0/1024.0
            } else {
                return 0
            }
            
        } catch {
            return 0
        }
        
    }
}
