//
//  SearchViewModel.swift
//  OneLabUnsplash
//
//  Created by Айдана on 2/10/21.
//

import Foundation

enum ResultItem {
    case photo
    case collection
    case user
}
final class SearchViewModel {
    
    let segmentItems = ["Photos", "Collections", "Users"]
    var trendingItems = ["crepes", "lunar new year", "carnival", "valentine", "wall street"]
    var isSearchMode = true
    let userDefaults = UserDefaults.standard
    
    var currentItem: ResultItem = .photo
    
    func removeRecentItems() {
        userDefaults.removeObject(forKey: "recentItemsKey")
    }
    func addRecentItem(item: String) {
        var recentItems = userDefaults.object(forKey: "recentItemsKey") as? [String] ?? []
        recentItems.insert(item, at: 0)
        userDefaults.set(recentItems, forKey: "recentItemsKey")
    }
    
    func getRecentItems() -> [String] {
        return userDefaults.object(forKey: "recentItemsKey") as? [String] ?? []
    }
}
