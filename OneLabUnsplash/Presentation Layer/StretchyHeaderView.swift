//
//  StretchyHeaderView.swift
//  OneLabUnsplash
//
//  Created by Айдана on 1/31/21.
//

import UIKit

final class StretchyHeaderView: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .black
        return imageView
    }()

    let mainLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()

    let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()

    private var containerView = UIView()
    private var imageViewHeightConstraint = NSLayoutConstraint()
    private var imageViewBottomConstraint = NSLayoutConstraint()
    private var containerViewHeightConstraint = NSLayoutConstraint()

    private var photo: Photo?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        configureViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        addSubview(containerView)
        containerView.addSubview(imageView)
    }
    
    func configureViewConstraints() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: containerView.widthAnchor),
            centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
       
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerViewHeightConstraint.isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewBottomConstraint = imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        imageViewBottomConstraint.isActive = true
        imageViewHeightConstraint = imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        imageViewHeightConstraint.isActive = true

    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        containerViewHeightConstraint.constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        imageViewBottomConstraint.constant = offsetY >= 0 ? 0 : -offsetY / 2
        imageViewHeightConstraint.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }

    func configure(with photo: Photo?) {
        self.photo = photo
        if let photo = photo {
//            authorLabel.text = "\(photo.user.firstName) \(photo.user.lastName ?? "")"
            imageView.image = UIImage(blurHash: photo.blurHash, size: CGSize(width: 32, height: 32))
            guard let imageUrl = photo.urls["small"] else {
                return
            }
            ImageDownloadServiceImpl.shared.fetchImage(with: imageUrl) { [weak self] (image, url) in
                if self?.photo?.urls["small"] == url {
                    self?.imageView.image = image
                }
            } failure: { (error) in
                print(error.reason)
            }

        } else {
            imageView.image = nil
        }
        
    }
}
