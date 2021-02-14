//
//  PhotosFromCollectionViewController.swift
//  OneLabUnsplash
//
//  Created by Айдана on 2/13/21.
//

import SnapKit

class PhotosFromCollectionViewController: UIViewController {
    
    private let viewModel: MainViewModel
    private let collectionName: String
    private let username: String
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private let titleView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    init(viewModel: MainViewModel, collectionName: String, username: String) {
        self.viewModel = viewModel
        self.collectionName = collectionName
        self.username = username
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func configureUI() {
        configureTableView()
        configureNavigationBar()
        configureTitleView()
    }
    
    private func configureTitleView() {
        let titleLabel = UILabel()
        titleLabel.text = collectionName
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name:"HelveticaNeue-Medium", size: 16.0)
        titleLabel.textAlignment = .center
        let curatedByLabel = UILabel()
        curatedByLabel.text = "Curated by " + username
        curatedByLabel.textColor = .lightGray2
        curatedByLabel.font = UIFont(name:"HelveticaNeue", size: 12.0)
        curatedByLabel.textAlignment = .center
        titleView.addArrangedSubview(titleLabel)
        titleView.addArrangedSubview(curatedByLabel)
        navigationItem.titleView = titleView
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PhotoTableViewCell.self)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonDidPress))
        navigationItem.rightBarButtonItem!.tintColor = UIColor.white
    }
    
    @objc private func shareButtonDidPress() {
    }
}

extension PhotosFromCollectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = PhotoViewController()
        viewController.imageName = "image"
        viewController.usernameTitle = "Aidana"
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
}

extension PhotosFromCollectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PhotoTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let image = UIImage(named: "image")
        cell.photoImageView.image = image
        return cell
    }
    
    
}
