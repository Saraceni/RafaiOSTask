//
//  Prefs.swift
//  RafaiOSTask
//
//  Created by Saraceni on 3/8/16.
//  Copyright © 2016 rafa. All rights reserved.
//

import Foundation

class Prefs {
    
    // MARK: - Window Variables
    static let WindowKey = "window"
    static let WindowDay = "day"
    static let WindowWeek = "week"
    static let WindowMonth = "month"
    static let WindowYear = "year"
    static let WindowAll = "all"
    
    // MARK: - Sort Variables
    static let SortKey = "sort"
    static let SortViral = "viral"
    static let SortTop = "top"
    static let SortTime = "time"
    static let SortRising = "rising"
    
    //MARK: - ShowViral Variables
    static let ShowViralKey = "showViral"
    
    static func getPrefs() -> NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    static func getWindow() -> String? {
        let prefs = getPrefs()
        return prefs.stringForKey(WindowKey)
    }
    
    static func setWindow(window: String) -> Bool {
        let prefs = getPrefs()
        prefs.setValue(window, forKey: WindowKey)
        return prefs.synchronize()
    }
    
    static func getSort() -> String? {
        let prefs = getPrefs()
        return prefs.stringForKey(SortKey)
    }
    
    static func setSort(sort: String?) -> Bool {
        let prefs = getPrefs()
        prefs.setValue(sort, forKey: SortKey)
        return prefs.synchronize()
    }
    
    static func getShowViral() -> Bool {
        let prefs = getPrefs()
        return prefs.boolForKey(ShowViralKey)
    }
    
    static func setShowViral(showViral: Bool) -> Bool {
        let prefs = getPrefs()
        prefs.setValue(showViral, forKey: ShowViralKey)
        return prefs.synchronize()
    }
    
}













