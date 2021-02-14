//
//  FiltersViewController.swift
//  OneLabUnsplash
//
//  Created by Айдана on 2/7/21.
//

import SnapKit

class FiltersViewController: UIViewController {
    
    private let sortByItems = ["Relevance", "Newest"]
    private let orientationItems = ["Any", "Portrait", "Landscape", "Square"]
    private let colorItems = ["Any", "Black and White", "White", "Black", "Yellow", "Orange", "Red", "Purple", "Magenta", "Green", "Teal", "Blue"]
    
    private let cellHeight = 45
    
    private let scrollView = UIScrollView()
    private let sortByTableView = UITableView()
    private let orientationTableView = UITableView()
    private let colorTableView = UITableView()
    
    private let navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.barTintColor = .darkGray2
        navigationBar.barStyle = .default
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        return navigationBar
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 30
        stackView.axis = .vertical
        return stackView
    }()
    
    private let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray3
        view.sizeToFit()
        return view
    }()
    
    private let applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apply Filters", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private var sizeConstraint: Constraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: Configure layout
    
    private func configureUI() {
        view.backgroundColor = .darkGray3
        configureNavigationBar()
        configureScrollView()
        configureMainStackView()
        configureTableViews()
        configureFooterView()
        configureApplyButton()
    }
    
    private func configureNavigationBar() {
        let navigationItem = UINavigationItem(title: "Filters")
        let resetButton = UIBarButtonItem(title: "Reset", style: .done, target: self, action: #selector(resetButtonDidPress))
        resetButton.tintColor = .white
        navigationItem.rightBarButtonItem = resetButton
        let closeButton = UIBarButtonItem(title: "✕", style: .done, target: self, action: #selector(closeButtonDidPress))
        closeButton.tintColor = .white
        navigationItem.leftBarButtonItem = closeButton
        navigationBar.setItems([navigationItem], animated: false)
        navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44)
        view.addSubview(navigationBar)
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(24)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func configureMainStackView() {
        scrollView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalToSuperview().offset(-17)
            $0.bottom.equalToSuperview().offset(-90)
        }
        let stackView1 = makeFilterStackView(tableView: sortByTableView, title: "SORT BY")
        let stackView2 = makeFilterStackView(tableView: orientationTableView, title: "ORIENTATION")
        let stackView3 = makeFilterStackView(tableView: colorTableView, title: "COLOR")
        mainStackView.addArrangedSubview(stackView1)
        mainStackView.addArrangedSubview(stackView2)
        mainStackView.addArrangedSubview(stackView3)
    }
    
    private func configureTableViews() {
        sortByTableView.snp.makeConstraints {
            self.sizeConstraint = $0.width.equalTo(view.frame.width - 34).constraint
        }
        configureFilterTableView(tableView: sortByTableView, arrayOfItems: sortByItems)
        configureFilterTableView(tableView: orientationTableView, arrayOfItems: orientationItems)
        configureFilterTableView(tableView: colorTableView, arrayOfItems: colorItems)
    }
    
    private func configureFilterTableView(tableView: UITableView, arrayOfItems: [String]) {
        tableView.layer.borderWidth = 0
        tableView.layer.cornerRadius = 10
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FiltersTableViewCell.self)
        tableView.snp.makeConstraints {
            self.sizeConstraint = $0.height.equalTo(arrayOfItems.count * cellHeight).constraint
        }
    }
    
    private func configureFooterView() {
        view.addSubview(footerView)
        footerView.backgroundColor = .darkGray3
        footerView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        let border = CALayer()
        border.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0.7)
        border.backgroundColor = UIColor.white.cgColor
        footerView.layer.addSublayer(border)
    }
    
    private func configureApplyButton() {
        footerView.addSubview(applyButton)
        applyButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview().offset(-15)
            self.sizeConstraint = $0.height.equalTo(50).constraint
        }
        applyButton.layer.borderWidth = 0.7
        applyButton.layer.borderColor = UIColor.lightGray2.cgColor
        applyButton.layer.cornerRadius = 10
        applyButton.addTarget(self, action: #selector(applyButtonnDidPress), for: .touchUpInside)
    }
    
    private func makeFilterStackView(tableView: UITableView, title: String) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.addArrangedSubview(makeLabel(title: title))
        stackView.addArrangedSubview(tableView)
        return stackView
    }
    
    private func makeLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = .lightGray2
        label.font = UIFont.systemFont(ofSize: 15.0)
        return label
    }
    
    // MARK: User interactions
    
    @objc private func resetButtonDidPress() {
    }
    
    @objc private func closeButtonDidPress() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func applyButtonnDidPress() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: SearchViewController + UITableViewDataSource

extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FiltersTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.selectionStyle = .none
        if let selectedRows = tableView.indexPathsForSelectedRows, selectedRows.contains(indexPath) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        if tableView == sortByTableView {
            cell.titleLabel.text = sortByItems[indexPath.row]
            cell.colorName = nil
        } else if tableView == orientationTableView {
            cell.titleLabel.text = orientationItems[indexPath.row]
            cell.colorName = nil
        } else {
            cell.titleLabel.text = colorItems[indexPath.row]
            cell.colorName = colorItems[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == sortByTableView {
            return sortByItems.count
        } else if tableView == orientationTableView{
            return orientationItems.count
        } else{
            return colorItems.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
    }
}

// MARK: SearchViewController + UITableViewDelegate

extension FiltersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}

