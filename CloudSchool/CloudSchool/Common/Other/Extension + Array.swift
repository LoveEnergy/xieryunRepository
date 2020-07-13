//
//  Extension + Array.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/1/29.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

extension Array {
    
    // 去重
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}
