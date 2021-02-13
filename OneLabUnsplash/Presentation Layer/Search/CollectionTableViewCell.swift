//
//  CollectionTableViewCell.swift
//  OneLabUnsplash
//
//  Created by Айдана on 2/12/21.
//

import SnapKit

class CollectionTableViewCell: UITableViewCell {
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let tintView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        return view
    }()
    
    let nameTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"HelveticaNeue-Medium", size: 20.0)
        label.numberOfLines = 1
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .black
        selectionStyle = .none
        configurePhotoImageView()
        configureNameTitle()
        configureTintView()
    }
    
    private func configurePhotoImageView() {
        contentView.addSubview(photoImageView)
        photoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.bottom.equalToSuperview().offset(-4)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
    }
    
    private func configureTintView() {
        photoImageView.addSubview(tintView)
        tintView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureNameTitle() {
        tintView.addSubview(nameTitle)
        nameTitle.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
