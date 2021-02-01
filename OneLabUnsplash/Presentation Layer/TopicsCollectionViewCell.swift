//
//  TopicsCollectionViewCell.swift
//  OneLabUnsplash
//
//  Created by Alikhan Abutalipov on 2/1/21.
//

import UIKit

class TopicsCollectionViewCell: UICollectionViewCell {

    override var isSelected: Bool {
        didSet {
            underscore.isHidden = !isSelected
        }
    }

    let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    let underscore: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.isHidden = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(textLabel)
        contentView.addSubview(underscore)
        textLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing)
        }
        underscore.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(textLabel.snp.width)
            $0.height.equalTo(2)
        }
        self.snp.makeConstraints {
            $0.height.equalTo(textLabel.snp.height).multipliedBy(2.5)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
