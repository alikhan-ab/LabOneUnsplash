//
//  SearchViewModel.swift
//  OneLabUnsplash
//
//  Created by Айдана on 2/10/21.
//

import Foundation

final class SearchViewModel {
    
    let segmentItems = ["Photos", "Collections", "Users"]
    var trendingItems = ["crepes", "lunar new year", "carnival", "valentine", "wall street"]
    var recentItems = ["abc", "def", "red", "new year"]
    var isSearchMode = true
    
    func removeRecentItems() {
        recentItems.removeAll()
    }
}
