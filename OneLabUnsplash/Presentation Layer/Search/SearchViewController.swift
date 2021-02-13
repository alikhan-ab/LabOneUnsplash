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
        hideKeyboardWhenTappedAround()
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
        tableView.register(CollectionTableViewCell.self)
        tableView.register(UserTableViewCell.self)
        let tableViewTopOffset = searchBar.frame.size.height + segmentedControl.frame.size.height - (navigationController?.navigationBar.frame.size.height)! + 15
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
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    // MARK: User interactions
    
    @objc func segmentedControlDidChange(_ segmentedControl: UISegmentedControl) {
        viewModel.setCurrentCell(selectedSegmentIndex: segmentedControl.selectedSegmentIndex)
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
    
    @objc private func cloaseKeyboardButtonDidPress() {
        searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
    }
    
    @objc func dismissKeyboard() {
        searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
    }
}

// MARK: SearchViewController + UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRowsInSection(section: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.isSearchMode {
            let cell: SearchTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            let cellTitle = viewModel.getSearchCellTitle(indexPath: indexPath)
            cell.titleLabel.text = cellTitle
            return cell
        }
        switch viewModel.currentCell {
        case .photo:
            let cell: PhotoTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            let image = UIImage(named: "image")
            cell.photoImageView.image = image
            return cell
        case .collection:
            let cell: CollectionTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.nameTitle.text = "lunar new year"
            cell.photoImageView.image = UIImage(named: "image")
            return cell
        default:
            let cell: UserTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.photoImageView.image = UIImage(named: "image")
            cell.usernameLabel.text = "Danny Phantom"
            cell.nicknameLabel.text = "phantom14"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.getSectionTitle(section: section)
    }
}

// MARK: SearchViewController + UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if viewModel.isSearchMode {
            print(indexPath)
        } else {
            switch viewModel.currentCell {
            case .photo:
                print("Появятся три точки (Закрузка, +, лайк)")
            case .collection:
                let newViewController = PhotosFromCollectionViewController(viewModel: MainViewModel(), collectionName: "lunar new year", username: "enovaid")
                self.navigationController?.pushViewController(newViewController, animated: true)
            default:
                print("Профайл юзера")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return makeSectionView(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(viewModel.getSectionHeight(section: section))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(viewModel.getCellHeight())
    }
}

// MARK: SearchViewController + UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
            viewModel.isSearchMode = true
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.isSearchMode = false
        viewModel.recentItems.insert(searchBar.text!, at: 0)
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let image = UIImage(systemName: "keyboard.chevron.compact.down")
        filtersButton.setImage(image, for: .normal)
        filtersButton.imageEdgeInsets = UIEdgeInsets(top: 40, left: 30, bottom: 40, right: 30)
        filtersButton.tintColor = .white
        filtersButton.removeTarget(nil, action: nil, for: .allEvents)
        filtersButton.addTarget(self, action: #selector(cloaseKeyboardButtonDidPress), for: .touchUpInside)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        let image = UIImage(named: "filters")
        filtersButton.setImage(image, for: .normal)
        filtersButton.imageEdgeInsets = UIEdgeInsets(top: 40, left: 25, bottom: 40, right: 25)
        filtersButton.removeTarget(nil, action: nil, for: .allEvents)
        filtersButton.addTarget(self, action: #selector(filtersButtonDidPress), for: .touchUpInside)
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
