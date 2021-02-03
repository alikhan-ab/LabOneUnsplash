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
    
    var url: String? {
        didSet {
            let data = try? Data(contentsOf: URL(string: url!)!)
            photoImageView.image = UIImage(data: data!)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configurePhotoImageView()
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
}


