//
//  MainViewModel.swift
//  OneLabUnsplash
//
//  Created by Alikhan Abutalipov on 1/23/21.
//

import Foundation

final class MainViewModel {
    var didEndRequest: () -> Void = { }
    var didGetError: (Error) -> Void = { _ in }
    private(set) var posts: [Photo] = []
    private let postService: PostService = PostServiceImpl()

    func fetchPosts() {
        postService.fetchPosts { [weak self] posts in
            self?.posts = posts
            self?.didEndRequest()
        } failure: { [weak self] error in
            self?.didGetError(error)
        }
    }

    func updatePostLikeCount(id: String) {
        postService.updatePost(by: id)
    }
}
