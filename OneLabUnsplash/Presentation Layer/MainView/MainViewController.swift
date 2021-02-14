//
//  MainViewController.swift
//  OneLabUnsplash
//
//  Created by Alikhan Abutalipov on 1/14/21.
//

import SnapKit

class MainViewController: UIViewController {
    private let viewModel: MainViewModel

    private let spinnerView = UIActivityIndicatorView(style: .large)
    private let mainSpinnerView = UIActivityIndicatorView(style: .large)
    private let stretchyHeaderHeight: CGFloat = 350

    private lazy var header: StretchyHeaderView = {
        let header =  StretchyHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.stretchyHeaderHeight))
        header.backgroundColor = UIColor.darkGray3
        return header
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        return tableView
    }()

    private lazy var topicsCollectionView: UICollectionView = {
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
    private var photosContentOffsets = [Int: CGPoint]()
    
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


    // MARK: - Configure Methods
    private func configureUI() {
        view.backgroundColor = UIColor.darkGray3
        configureNavigationBar()
        configureSpinnerView()
        configureTableView()
        configureTopicsView()
        configureMainSpinner()
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

    private func configureSpinnerView() {
        spinnerView.hidesWhenStopped = true
        view.addSubview(spinnerView)
        spinnerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.edges.equalToSuperview()
        }
    }

    private func configureTopicsView() {
        view.addSubview(topicsCollectionView)
        topicsCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            self.topicsCollectionViewHeightConstraint = $0.height.equalTo(60).constraint
        }
    }

    private func configureTableView() {
        view.addSubview(tableView)
//        let header = StretchyHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: stretchyHeaderHeight))
        let header = self.header
        header.configure(with: nil)
        tableView.tableHeaderView = header
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        tableView.isHidden = true
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.clear
        let identifier = String(describing: PhotoTableViewCell.self)
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: identifier)
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    private func configureMainSpinner() {
        view.addSubview(spinnerView)
        spinnerView.isHidden = false
        spinnerView.startAnimating()
        spinnerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func loadData() {
        bindViewModel()
        viewModel.initialFetch()
    }

    // MARK: - View Model Binding
    private func bindViewModel() {
        viewModel.didEndRequest = {
            self.tableView.reloadData()
        }
        viewModel.didGetError = { error in
            print(error)
        }
        viewModel.didFetchTopics = { [unowned self] in
            self.mainSpinnerView.stopAnimating()
            self.topicsCollectionView.reloadData()
            self.topicsCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
            self.switchTopic(to: 0)

        }
        viewModel.didFetchPhotos = { [unowned self] (topicIndex, indexPaths) in
            guard topicIndex == self.topicsCollectionView.indexPathsForSelectedItems?[0].row else {
                return
            }

            guard let newIndexPathsToReload = indexPaths else {
                // Photos for the topic at topicIndex is loading for the first time.
                self.spinnerView.stopAnimating()
                self.tableView.isHidden = false
                self.tableView.reloadData()
                return
            }

            let indexPathsToReload = self.visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
            self.tableView.reloadRows(at: indexPathsToReload, with: .automatic)
        }
        viewModel.didFetchPhotoOfTheDay = { [unowned self] photo in
            self.header.configure(with: photo)
        }
        viewModel.didSwitchTopicTo = { [unowned self] topicIndex in
            if topicIndex == 0 {
                self.tableView.tableHeaderView = header
            } else if self.tableView.tableHeaderView == self.header {
                var frame = CGRect.zero
                frame.size.height = topicsCollectionView.frame.height
                self.tableView.tableHeaderView = UIView(frame: frame)
            }

            if !viewModel.isTopicPageFirstFetch(for: topicIndex) {
                self.tableView.isHidden = false
                self.spinnerView.stopAnimating()
            }
            self.tableView.reloadData()
        }
    }

    // MARK: -
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = tableView.tableHeaderView as? StretchyHeaderView else {
            return
        }
        header.scrollViewDidScroll(scrollView: tableView)
    }

    private func switchTopic(to topicIndex: Int) {
        if viewModel.isTopicPageFirstFetch(for: topicIndex) {
            spinnerView.startAnimating()
            tableView.isHidden = true
        }
        viewModel.switchTopic(to: topicIndex)
    }
}

// MARK: - UICollectionView Delegate and DataSource
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        photosContentOffsets[indexPath.row] = tableView.contentOffset
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row != viewModel.currentTopicIndex else { return }
        switchTopic(to: indexPath.row)
    }
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

// MARK: - UITableView Delegate and DataSource
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoadingCell(for: indexPath) {
            return view.frame.width
        } else {
            return calculateCellHeight(viewModel.currentTopicPhoto(at: indexPath.row).height, viewModel.currentTopicPhoto(at: indexPath.row).width)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalTopicPhotosCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: PhotoTableViewCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? PhotoTableViewCell else { return UITableViewCell() }

        if isLoadingCell(for: indexPath) {
            cell.configure(with: nil)
        } else {
            cell.configure(with: viewModel.currentTopicPhoto(at: indexPath.row))
        }
        return cell
    }
    
    private func calculateCellHeight(_ photoHeight: Int, _ photoWidth: Int) -> CGFloat{
        return CGFloat(photoHeight) / (CGFloat(photoWidth) / view.frame.width)
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension MainViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchPhotos()
        }
    }
}

private extension MainViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentTopicPhotosCount()
    }

    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

