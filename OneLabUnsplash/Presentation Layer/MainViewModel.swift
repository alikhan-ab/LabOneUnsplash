//
//  MainViewModel.swift
//  OneLabUnsplash
//
//  Created by Alikhan Abutalipov on 1/23/21.
//

import UIKit

fileprivate struct TopicPage {
    let topic: Topic
    var curentPage = 1
    var totalItems = 0
    var photos: [Photo]
    var isFetchInProgress = false
    var isFirstFetch = true

    init(topic: Topic) {
        self.topic = topic
        self.photos = []
    }
}

final class MainViewModel {
    // MARK: - Binding methods
    var didEndRequest: () -> Void = { }
    var didGetError: (String) -> Void = { _ in }
    var didFetchTopics: () -> Void = {}
    var didFetchPhotos: (Int, [IndexPath]?) -> Void = { _,_  in }
    var didSwitchTopicTo: (Int) -> Void = { _ in }
    var didDownloadImage: (Int, Int, UIImage) -> Void = { _,_,_ in }


    // MARK: - Other properties
    private(set) var posts: [Photo] = []
    private(set) var topics: [Topic] = []
    fileprivate var topicPages: [TopicPage] = {
        let editorialTopic = Topic(slug: "fashion", title: "Editorial", photosURL: URL(string: "https://api.unsplash.com/collections/317099/photos")!)
        var topicPage = TopicPage(topic: editorialTopic)
        let array = [topicPage]
        return array
    }()
    var currentTopicIndex = 0
    private var areTopicsFetched: Bool = false
    private let postService: PostService = PostServiceImpl()
    private let topicsRequest: ApiRequest = ApiRequest(resource: TopicsResource())
    private let apiService: APIService = APIServiceImpl()

    // MARK: -
    func topicPhotosCount(for topicIndex: Int) -> Int {
        return topicPages[topicIndex].photos.count
    }

    func currentTopicPhotosCount() -> Int {
        return topicPhotosCount(for: currentTopicIndex)
    }

    func totalTopicPhotosCount() -> Int {
        return topicPages[currentTopicIndex].totalItems
    }

    func isTopicPageFirstFetch(for topicIndex: Int) -> Bool {
        return topicPages[topicIndex].isFirstFetch
    }

    func currentTopicPhoto(at index: Int) -> Photo {
        return topicPages[currentTopicIndex].photos[index]
    }

    func switchTopic(to topicIndex: Int) {
        currentTopicIndex = topicIndex
        if topicPages[currentTopicIndex].isFirstFetch {
            fetchPhotos()
        }
        didSwitchTopicTo(topicIndex)
    }

    // MARK: - Fetch Methods
    func fetchPosts() {
        postService.fetchPosts { [weak self] posts in
            self?.posts = posts
            self?.topicPages[0].photos = posts
            self?.didEndRequest()
        } failure: { [weak self] error in
            self?.didGetError(error.localizedDescription)
        }
    }

    func fetchTopics() {
        guard !areTopicsFetched else { return }
        let successClosure: ([Topic], HTTPURLResponse) -> Void = { [weak self] (topics, response) in
            guard let self = self else { return }
            self.areTopicsFetched = true
            topics.forEach {
                self.topicPages.append(TopicPage(topic: $0))
            }
            self.topics.append(contentsOf: topics)
            self.didFetchTopics()
        }
        let errorClosure: (DataResponseError) -> Void = { [weak self] error in
            self?.didGetError(error.reason)
        }

        apiService.fetchTopics(success: successClosure, failure: errorClosure)
    }

    func fetchPhotos() {
        fetchPhotos(for: currentTopicIndex)
    }

    private func fetchPhotos(for topicIndex: Int) {
        guard !topicPages[topicIndex].isFetchInProgress else { return }
        topicPages[topicIndex].isFetchInProgress = true
        let currentPage = topicPages[topicIndex].curentPage

        let successClosure: ([Photo], HTTPURLResponse) -> Void = { [weak self] (photos, response) in
            guard let self = self else { return }

            guard let totalPhotosString = response.allHeaderFields["x-total"] as? String, let totalPhotos = Int(totalPhotosString) else {
                print(response.allHeaderFields)
                self.didGetError(DataResponseError.decodeError.reason)
                return
            }

            self.topicPages[topicIndex].curentPage += 1
            self.topicPages[topicIndex].isFetchInProgress = false
            self.topicPages[topicIndex].photos.append(contentsOf: photos)
            self.topicPages[topicIndex].isFirstFetch = false

            if self.topicPages[topicIndex].curentPage > 2 {
                let indexPathsToReload = self.calculateIndexPathsToReload(forTopicIndex: topicIndex, from: photos)
                self.didFetchPhotos(topicIndex, indexPathsToReload)
            } else {
                self.topicPages[topicIndex].totalItems = totalPhotos
                self.didFetchPhotos(topicIndex, nil)
            }
        }

        let errorClosure: (DataResponseError) -> Void = { [weak self] error in
            self?.topicPages[topicIndex].isFetchInProgress = false
            self?.didGetError(error.reason)
        }
        
        apiService.fetchPhotos(for: topicPages[currentTopicIndex].topic, page: currentPage, success: successClosure, failure: errorClosure)
    }

    // MARK: -
    private func calculateIndexPathsToReload(forTopicIndex topicIndex: Int, from newPhotos: [Photo]) -> [IndexPath] {
        let startIndex = topicPages[topicIndex].photos.count - newPhotos.count
        let endIndex = startIndex + newPhotos.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
