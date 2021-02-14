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
            authorLabel.text = "\(photo.user.firstName) \(photo.user.lastName ?? "")"
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

extension UIImage {
    func addGradient() -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        let context = UIGraphicsGetCurrentContext()
        self.draw(at: CGPoint(x: 0, y: 0))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations:[CGFloat] = [0.7, 1.0]
        let bottom = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        let top = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        let colors = [top, bottom] as CFArray
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)
        let startPoint = CGPoint(x: self.size.width/2, y: 0)
        let endPoint = CGPoint(x: self.size.width / 2, y: self.size.height)
        context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return UIImage()
        }
        UIGraphicsEndImageContext()
        return image
    }
}


