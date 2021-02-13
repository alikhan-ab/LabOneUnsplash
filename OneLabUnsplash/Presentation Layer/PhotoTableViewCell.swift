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
    
    var url: String? {
        didSet {
            let data = try? Data(contentsOf: URL(string: url!)!)
            photoImageView.image = UIImage(data: data!)
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

    func configure(with photo: Photo?) {
        if let photo = photo {
            photoImageView.image = UIImage(blurHash: photo.blurHash, size: CGSize(width: 32, height: 32))
            authorLabel.text = "Photo by author"
        } else {
            photoImageView.image = nil
            authorLabel.text = "Photo by"
        }
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
}


