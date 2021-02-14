//
//  SearchTableViewCell.swift
//  Lesson2-UIScrollView
//
//  Created by admin on 12/22/20.
//

import SnapKit

final class SearchTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
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
        configureTitleLabel()
        configureSelectedBackgroundView()
        makeSeparator()
    }
    
    private func configureSelectedBackgroundView() {
        let SelectedColorView = UIView()
        SelectedColorView.backgroundColor = UIColor.darkGray2
        selectedBackgroundView = SelectedColorView
    }
    
    private func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func makeSeparator() {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 17.0, y: frame.height, width:  UIScreen.main.bounds.width, height: 1)
        bottomBorder.backgroundColor = UIColor.darkGray2.cgColor
        self.contentView.layer.addSublayer(bottomBorder)
    }
}

