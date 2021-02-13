//
//  SearchViewModel.swift
//  OneLabUnsplash
//
//  Created by Айдана on 2/10/21.
//

import Foundation

enum ResultCell {
    case photo
    case collection
    case user
}
final class SearchViewModel {
    
    let segmentItems = ["Photos", "Collections", "Users"]
    var trendingItems = ["crepes", "lunar new year", "carnival", "valentine", "wall street"]
    var recentItems = ["abc", "def", "red", "new year"]
    var isSearchMode = true
    
    var currentCell: ResultCell = .photo
    
    func removeRecentItems() {
        recentItems.removeAll()
    }
    
    func setCurrentCell(selectedSegmentIndex: Int) {
        switch selectedSegmentIndex {
        case 0:
            currentCell = .photo
        case 1:
            currentCell = .collection
        default:
            currentCell = .user
        }
    }
    
    func getCellHeight() -> Int {
        if isSearchMode {
            return 45
        }
        switch currentCell {
        case .photo:
            return 350
        case .collection:
            return 230
        default:
            return 120
        }
    }
    
    func getSectionHeight(section: Int) -> Int {
        if section == 0 && recentItems.count == 0 || !isSearchMode {
            return 0
        }
        return 50
    }
    
    func getSectionTitle(section: Int) -> String? {
        if isSearchMode {
            switch section {
            case 0:
                guard !recentItems.isEmpty else { return nil }
                return "Recent"
            case 1:
                guard !trendingItems.isEmpty else { return nil }
                return "Trending"
            default:
                return nil
            }
        }
        return nil
    }
    
    func getNumberOfRowsInSection(section: Int) -> Int {
        if isSearchMode {
            switch section {
            case 0:
                return recentItems.count
            default:
                return trendingItems.count
            }
        }
        switch currentCell {
        case .photo:
            return 10
        case .collection:
            return 10
        default:
            return 10
        }
    }
    
    func getNumberOfSections() -> Int {
        if isSearchMode {
            return 2
        }
        return 1
    }
    
    func getSearchCellTitle(indexPath: IndexPath) -> String {
        var item: String
        switch indexPath.section {
        case 0:
            item = recentItems[indexPath.row]
        default:
            item = trendingItems[indexPath.row]
        }
        return item
    }
    
}
