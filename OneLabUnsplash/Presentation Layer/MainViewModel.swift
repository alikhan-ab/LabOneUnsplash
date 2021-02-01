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
    private(set) var topics: [Topic] = [Topic(slug: "unsplash-editorial", title: "Editorial", photosURL: URL(string: "https://api.unsplash.com/collections/317099/photos?per_page=1")!)]
    private let postService: PostService = PostServiceImpl()
    private let topicsRequest: ApiRequest = ApiRequest(resource: TopicsResource())
    private var areTopicsFetched: Bool = false

    func fetchPosts() {
        postService.fetchPosts { [weak self] posts in
            self?.posts = posts
            self?.didEndRequest()
        } failure: { [weak self] error in
            self?.didGetError(error)
        }
    }

    func fetchTopics() {
        guard !areTopicsFetched else { return }
        topicsRequest.fetch { [weak self] topics in
            guard let topics = topics else {
                // TODO: - Change/make the error implementation
                return
            }
            self?.areTopicsFetched = true
            self?.topics.append(contentsOf: topics)
            self?.didFetchTopics()
        }
    }

    func updatePostLikeCount(id: String) {
        postService.updatePost(by: id)
    }
}
