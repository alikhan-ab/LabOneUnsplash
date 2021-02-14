//
//  PhotoViewController.swift
//  OneLabUnsplash
//
//  Created by Айдана on 14.02.2021.
//

import SnapKit

class PhotoViewController: UIViewController {
    
    var usernameTitle: String = ""
    var imageName: String = ""
    
    private let navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.barStyle = .default
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.transparentNavigationBar()
        navigationBar.tintColor = .white
        return navigationBar
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var unsplashPhoto: UnsplashPhoto! {
        didSet {
            let photoUrl = unsplashPhoto.urls["regular"]
            guard let imageURL = photoUrl, let url = URL(string: imageURL) else { return }
            imageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    private let infoButton: UIButton = {
        let button = UIButton(frame: CGRect(x:0, y:0, width: 100, height:100))
        button.setImage(UIImage(named: "info"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        view.backgroundColor = .black
    }
    
    private func configureUI() {
        configureNavigationBar()
        configureImageView()
        configureInfoButton()
    }
    
    private func configureInfoButton() {
        view.addSubview(infoButton)
        infoButton.frame.size.height = 200
        infoButton.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
    
    private func configureNavigationBar() {
        navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44)
        view.addSubview(navigationBar)
        let navItem = UINavigationItem(title: usernameTitle)
        navItem.leftBarButtonItem = UIBarButtonItem(title: "✕", style: .done, target: self, action: #selector(closeButtonDidPress))
        navItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonDidPress))
        navigationBar.setItems([navItem], animated: false)
        navigationBar.snp.makeConstraints {
                    $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                    $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
                    $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
    }
    
    private func configureImageView() {
        view.addSubview(imageView)
        if !imageName.isEmpty {
            imageView.image = UIImage(named: imageName)
        }
        imageView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc private func shareButtonDidPress() {
    }
    
    @objc private func closeButtonDidPress() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UINavigationBar {
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}
