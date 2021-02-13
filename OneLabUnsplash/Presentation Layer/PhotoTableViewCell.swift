//
//  PhotoTableViewCell.swift
//  OneLabUnsplash
//
//  Created by Айдана on 1/31/21.
//

import SnapKit

final class PhotoTableViewCell: UITableViewCell {

    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()

    var photo: Photo? {
        didSet {
            guard let oldPhoto = oldValue, let oldUrl = oldPhoto.urls["small"] else { return }
            ImageDownloadServiceImpl.shared.cancelImageFetch(for: oldUrl)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configurePhotoImageView()
        configureAuthorLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configurePhotoImageView() {
        contentView.addSubview(photoImageView)
        photoImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(0)
            $0.top.equalToSuperview().offset(0)
            $0.right.equalToSuperview().offset(0)
            $0.bottom.equalToSuperview().offset(0)
        }
    }

    private func configureAuthorLabel() {
        contentView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.lessThanOrEqualToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }

    func configure(with photo: Photo?) {
        self.photo = photo
        if let photo = photo {
            authorLabel.text = "\(photo.user.firstName) \(photo.user.lastName)"
            photoImageView.image = UIImage(blurHash: photo.blurHash, size: CGSize(width: 32, height: 32))
            guard let imageUrl = photo.urls["small"] else {
                return
            }
            ImageDownloadServiceImpl.shared.fetchImage(with: imageUrl) { [weak self] (image, url) in
                if self?.photo?.urls["small"] == url {
                    self?.photoImageView.image = image
                }
            } failure: { (error) in
                print(error.reason)
            }

        } else {
            photoImageView.image = nil
            authorLabel.text = "Photo by"
        }
    }
}


