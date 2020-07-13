//
//  SearchHelper.swift
//  CloudSchool
//
//  Created by Maynard on 2018/12/11.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class SearchHelper: NSObject {
    
    class func histories() -> [String] {
        if let array = UserDefaults.User.array(forKey: .searchHistory) {
            return array
        }
        return []
    }
    
    class func addWord(_ word: String) {
        var array = self.histories()
        if array.contains(word) {
            array = array.filter({ (text) -> Bool in
                return text != word
            })
        }
        array.insert(word, at: 0)
        UserDefaults.User.set(array, forKey: .searchHistory)
    }
    
    class func clear() {
        UserDefaults.User.set([], forKey: .searchHistory)
    }
    

}
