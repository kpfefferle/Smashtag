//
//  RecentSearches.swift
//  Smashtag
//
//  Created by Kevin Pfefferle on 6/11/16.
//  Copyright © 2016 Kevin Pfefferle. All rights reserved.
//

import Foundation

struct RecentSearches {

    private static let defaults = NSUserDefaults.standardUserDefaults()
    private static let key = "RecentSearces"
    private static let limit = 100

    static var list: [String] {
        return (defaults.objectForKey(key) as? [String]) ?? []
    }

    static func add(term: String) {
        var newArray = list.filter({ term.caseInsensitiveCompare($0) != .OrderedSame })
        newArray.insert(term, atIndex: 0)
        while newArray.count > limit {
            newArray.removeLast()
        }
        defaults.setObject(newArray, forKey: key)
    }

}
