//
//  PostDataProvider.swift
//  OneLabUnsplash
//
//  Created by Айдана on 1/31/21.
//

import Foundation

protocol PostDataProvider {
    func fetchPosts(success: @escaping ([Photo]) -> Void, failure: @escaping (Error) -> Void)
}

final class PostNetworkDataProvider: PostDataProvider {
    func fetchPosts(success: @escaping ([Photo]) -> Void, failure: @escaping (Error) -> Void) {
        guard let key = getPlist()?["Access Key"] else { return }
        let urlString = "https://api.unsplash.com/photos/random/?count=30&client_id=\(key)"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                failure(error)
            } else if let data = data {
                do {
                    let posts = try JSONDecoder().decode([Photo].self, from: data)
                    DispatchQueue.main.async {
                        success(posts)
                    }
                } catch {
                    failure(error)
                }
            }
        }.resume()
    }
    
    private func getPlist() -> NSDictionary? {
        let path = Bundle.main.path(forResource: "UnsplashKeys", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        return dict
    }

}

