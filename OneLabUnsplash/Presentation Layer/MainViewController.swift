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
        viewModel.fetchPosts()
        bindViewModel()
    }
    
    private func configureUI() {
        configureTableView()
    }

    private func bindViewModel() {
        viewModel.didEndRequest = {
            self.tableView.reloadData()
        }
        viewModel.didGetError = { error in
            print(error)
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
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = tableView.tableHeaderView as? StretchyHeaderView else {
            return
        }
        header.scrollViewDidScroll(scrollView: tableView)
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
