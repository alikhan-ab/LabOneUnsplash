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
    var didFetchTopics: () -> Void = {}
    private(set) var posts: [Photo] = []
    private(set) var topics: [Topic] = []
    private let postService: PostService = PostServiceImpl()
    private let topicsRequest: ApiRequest = ApiRequest(resource: TopicsResource())

    func fetchPosts() {
        postService.fetchPosts { [weak self] posts in
            self?.posts = posts
            self?.didEndRequest()
        } failure: { [weak self] error in
            self?.didGetError(error)
        }
    }

    func fetchTopics() {
        topicsRequest.fetch { [weak self] topics in
            guard let topics = topics else {
                // TODO: - Change/make the error implementation
                return
            }
            self?.topics = topics
            self?.didFetchTopics()
        }
    }

    func updatePostLikeCount(id: String) {
        postService.updatePost(by: id)
    }
}
