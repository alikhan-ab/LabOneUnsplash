//
//  UserTableViewCell.swift
//  OneLabUnsplash
//
//  Created by Айдана on 2/12/21.
//

import SnapKit

class UserTableViewCell: UITableViewCell {
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 40
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
        return label
    }()
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray2
        label.font = UIFont(name:"HelveticaNeue", size: 15.0)
        return label
    }()
    
    private var sizeConstraint: Constraint?
    
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
        makeSeparator()
        configureLabels()
    }
    
    private func configurePhotoImageView() {
        contentView.addSubview(photoImageView)
        photoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-20)
            $0.leading.equalToSuperview().offset(20)
            self.sizeConstraint = $0.width.equalTo(80).constraint
        }
    }
    
    private func configureLabels() {
        let stackView = UIStackView()
        contentView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.addArrangedSubview(usernameLabel)
        stackView.addArrangedSubview(nicknameLabel)
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.bottom.equalToSuperview().offset(-35)
            $0.leading.equalTo(photoImageView.snp.trailing).offset(20)
        }
    }
    
    private func makeSeparator() {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 17.0, y: 119, width:  UIScreen.main.bounds.width, height: 1)
        bottomBorder.backgroundColor = UIColor.darkGray2.cgColor
        self.contentView.layer.addSublayer(bottomBorder)
    }
}
