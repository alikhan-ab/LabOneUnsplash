//
//  UserProfileViewController.swift
//  OneLabUnsplash
//
//  Created by Айдана on 14.02.2021.
//

import SnapKit

class UserProfileViewController: UIViewController {
    private var sizeConstraint: Constraint?
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "image")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 40
        return imageView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Photos", "Likes", "Collections"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .darkGray2
        segmentedControl.selectedSegmentTintColor = .lightGray2
        segmentedControl.tintColor = .white
        let titleColor = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleColor, for: .selected)
        segmentedControl.setTitleTextAttributes(titleColor, for: .normal)
        segmentedControl.addTarget(self, action: #selector(segmentedControlDidChange(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 290))
        headerView.backgroundColor = .black
        headerView.addSubview(photoImageView)
        photoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(13)
            $0.top.equalToSuperview().offset(100)
            self.sizeConstraint = $0.size.equalTo(80).constraint
        }
        tableView.tableHeaderView = headerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func configureUI() {
        configureNavigationBar()
        configureTableView()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(downloadButtonDidPress))
        navigationItem.rightBarButtonItem!.tintColor = UIColor.white
        navigationItem.title = "Secret User"
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium", size: 17)!]
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
    
    @objc private func downloadButtonDidPress() {
        
    }
    
    @objc func segmentedControlDidChange(_ segmentedControl: UISegmentedControl) {
        tableView.reloadData()
    }
}

extension UserProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = PhotoViewController()
        viewController.imageName = "image"
        viewController.usernameTitle = "username"
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
}

extension UserProfileViewController: UITableViewDataSource {
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
