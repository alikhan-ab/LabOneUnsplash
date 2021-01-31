//
//  PostService.swift
//  OneLabUnsplash
//
//  Created by Айдана on 1/31/21.
//

import Foundation

protocol PostService {
    func fetchPosts(success: @escaping ([Photo]) -> Void, failure: @escaping (Error) -> Void)
    func updatePost(by id: String)
    func removePost(by id: String)
    func obtainPosts() -> [Photo]
}

final class PostServiceImpl: PostService {

    private let dataProvider: PostDataProvider = PostNetworkDataProvider()

    func fetchPosts(success: @escaping ([Photo]) -> Void, failure: @escaping (Error) -> Void) {
            dataProvider.fetchPosts { posts in
                success(posts)
            } failure: { error in
                failure(error)
            }
    }
    
    func updatePost(by id: String) {
        print(id)
    }

    func removePost(by id: String) {
    }

    func obtainPosts() -> [Photo] {
        return []
    }
}
