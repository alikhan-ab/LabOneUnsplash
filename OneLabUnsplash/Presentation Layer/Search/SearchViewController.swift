//
//  SearchViewController.swift
//  OneLabUnsplash
//
//  Created by Айдана on 2/4/21.
//

import SnapKit

class SearchViewController: UIViewController {
    
    private let viewModel: SearchViewModel
    
    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search photos"
        searchBar.sizeToFit()
        searchBar.barTintColor = .black
        searchBar.searchTextField.backgroundColor = .darkGray2
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.leftView?.tintColor = .lightGray
        return searchBar
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: viewModel.segmentItems)
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
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .black
        tableView.sectionFooterHeight = 5
        tableView.separatorColor = .clear
        return tableView
    }()
    
    private let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.sizeToFit()
        return view
    }()
    
    private let filtersButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "filters")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(filtersButtonDidPress), for: .touchUpInside)
        return button
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 3
        stackView.axis = .horizontal
        return stackView
    }()
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: Configure layout
    
    private func configureUI() {
        configureTableView()
        configureTitleView()
        configureStackView()
        configureSegmentedControl()
    }
    
    private func configureTitleView() {
        view.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
    }
    
    private func configureSegmentedControl() {
        titleView.addSubview(segmentedControl)
        segmentedControl.frame = CGRect(x: 0, y: 0, width: (self.view.frame.width - 20), height: 70)
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalToSuperview().offset(-17)
            $0.bottom.equalToSuperview().offset(-5)
        }
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchTableViewCell.self)
        tableView.register(PhotoTableViewCell.self)
        let tableViewTopOffset = searchBar.frame.size.height + segmentedControl.frame.size.height - (navigationController?.navigationBar.frame.size.height)!
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(tableViewTopOffset)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func configureStackView() {
        titleView.addSubview(titleStackView)
        titleStackView.addArrangedSubview(searchBar)
        titleStackView.addArrangedSubview(filtersButton)
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-22)
        }
    }
    
    private func makeSectionView(section: Int) -> UIView {
        let sectionView = UIView()
        sectionView.backgroundColor = .black
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 22.0)
        label.text = self.tableView(tableView, titleForHeaderInSection: section)
        sectionView.addSubview(label)
        label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview()
        }
        
        if section == 0 && viewModel.recentItems.count != 0 {
            let clearButton = UIButton(type: .system)
            clearButton.setTitle("Clear", for: .normal)
            clearButton.setTitleColor(.white, for: .normal)
            clearButton.addTarget(self, action: #selector(clearButtonDidPress), for: .touchUpInside)
            sectionView.addSubview(clearButton)
            clearButton.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.trailing.equalToSuperview().offset(-20)
                $0.bottom.equalToSuperview()
            }
        }
        return sectionView
    }
    
    // MARK: User interactions
    
    @objc func segmentedControlDidChange(_ segmentedControl: UISegmentedControl) {
        tableView.reloadData()
    }
    
    @objc private func clearButtonDidPress() {
        viewModel.removeRecentItems()
        tableView.reloadData()
    }
    
    @objc private func filtersButtonDidPress() {
        let filtersViewController = FiltersViewController()
        self.present(filtersViewController, animated: true, completion: nil)
    }
}

// MARK: SearchViewController + UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isSearchMode {
            switch section {
            case 0:
                return viewModel.recentItems.count
            default:
                return viewModel.trendingItems.count
            }
        }
       return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.isSearchMode {
           return 2
        }
       return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.isSearchMode {
            var item: String
            switch indexPath.section {
            case 0:
                item = viewModel.recentItems[indexPath.row]
            default:
                item = viewModel.trendingItems[indexPath.row]
            }
            let cell: SearchTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLabel.text = item
            return cell
        } else {
            let cell: PhotoTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.photoImageView.image = UIImage(named: "image")
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if viewModel.isSearchMode {
            switch section {
            case 0:
                guard !viewModel.recentItems.isEmpty else { return nil }
                return "Recent"
            case 1:
                guard !viewModel.trendingItems.isEmpty else { return nil }
                return "Trending"
            default:
                return nil
            }
        }
        return nil
    }
}

// MARK: SearchViewController + UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = makeSectionView(section: section)
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && viewModel.recentItems.count == 0 || !viewModel.isSearchMode {
            return 0
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.isSearchMode {
            return 45
        }
        return 350
    }
}

// MARK: SearchViewController + UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if searchText.isEmpty {
            viewModel.isSearchMode = true
        } else {
            viewModel.isSearchMode = false
        }
        tableView.reloadData()
    }
}

// MARK: UIColor + extension

extension UIColor {
    static let lightGray2 = UIColor(red: 128 / 255, green: 128 / 255, blue: 128 / 255, alpha: 1)
    static let darkGray2 = UIColor(red: 39 / 255, green: 36 / 255, blue: 41 / 255, alpha: 1)
    static let darkGray3 = UIColor(red: 26 / 255, green: 25 / 255, blue: 28 / 255, alpha: 1)
}

// MARK: UITableView + extension

extension UITableView {
    func register<T: UITableViewCell>(_ cell: T.Type) {
        let identifier = String(describing: T.self)
        register(T.self, forCellReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError()
        }
        return cell
    }
}
