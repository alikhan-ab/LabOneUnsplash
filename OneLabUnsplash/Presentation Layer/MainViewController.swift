//
//  MainViewController.swift
//  OneLabUnsplash
//
//  Created by Alikhan Abutalipov on 1/14/21.
//

import SnapKit

class MainViewController: UIViewController {
    
    private let viewModel: MainViewModel
    
    private let stretchyHeaderHeight: CGFloat = 350
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        return tableView
    }()

    private lazy var topicsSollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TopicsCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: TopicsCollectionViewCell.self))
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private var topicsCollectionViewHeightConstraint: Constraint?
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadData()
    }

    private func loadData() {
        bindViewModel()
        viewModel.fetchPosts()
        viewModel.fetchTopics()
    }
    
    private func configureUI() {
        configureNavigationBar()
        configureTableView()
        configureTopicsView()
    }

    private func bindViewModel() {
        viewModel.didEndRequest = {
            self.tableView.reloadData()
        }
        viewModel.didGetError = { error in
            print(error)
        }
        viewModel.didFetchTopics = {
            self.topicsSollectionView.reloadData()
            self.topicsSollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
        }
    }

    private func configureNavigationBar() {
        title = "Unsplash"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.isTranslucent = true
    }

    private func configureTopicsView() {
        view.addSubview(topicsSollectionView)
        topicsSollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            self.topicsCollectionViewHeightConstraint = $0.height.equalTo(60).constraint
        }
    }

    private func configureTableView() {
        view.addSubview(tableView)
        let header = StretchyHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: stretchyHeaderHeight))
        header.imageView.image = UIImage(named: "image")
        tableView.tableHeaderView = header
        tableView.dataSource = self
        tableView.delegate = self
        let identifier = String(describing: PhotoTableViewCell.self)
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: identifier)
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = tableView.tableHeaderView as? StretchyHeaderView else {
            return
        }
        header.scrollViewDidScroll(scrollView: tableView)
    }
}

extension MainViewController: UICollectionViewDelegate {

}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.topics.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TopicsCollectionViewCell.self), for: indexPath) as? TopicsCollectionViewCell else { return UICollectionViewCell() }
        cell.textLabel.text = viewModel.topics[indexPath.row].title
        return cell
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return calculateCellHeight(viewModel.posts[indexPath.row].height, viewModel.posts[indexPath.row].width)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: PhotoTableViewCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? PhotoTableViewCell else { return UITableViewCell() }
        cell.url = viewModel.posts[indexPath.row].urls["small"]
        return cell
    }
    
    private func calculateCellHeight(_ photoHeight: Int, _ photoWidth: Int) -> CGFloat{
        return CGFloat(photoHeight) / (CGFloat(photoWidth) / view.frame.width)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = viewModel.posts[indexPath.row]
        viewModel.updatePostLikeCount(id: post.id)
    }
}
