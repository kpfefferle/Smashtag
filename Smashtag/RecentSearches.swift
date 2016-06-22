//
//  RecentSearches.swift
//  Smashtag
//
//  Created by Kevin Pfefferle on 6/11/16.
//  Copyright © 2016 Kevin Pfefferle. All rights reserved.
//

import Foundation

struct RecentSearches {

    private static let defaults = UserDefaults.standard()
    private static let key = "RecentSearces"
    private static let limit = 100

    static var list: [String] {
        return (defaults.array(forKey: key) as? [String]) ?? []
    }

    static func add(_ term: String) {
        var newArray = list.filter({ term.caseInsensitiveCompare($0) != .orderedSame })
        newArray.insert(term, at: 0)
        while newArray.count > limit {
            newArray.removeLast()
        }
        defaults.set(newArray, forKey: key)
    }

}
