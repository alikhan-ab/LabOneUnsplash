//
//  FiltersTableViewCell.swift
//  OneLabUnsplash
//
//  Created by Айдана on 2/8/21.
//

import SnapKit

final class FiltersTableViewCell: UITableViewCell {
    
    var colorName: String? {
        didSet {
            configureContentViews()
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
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
        configureSelectedBackgroundView()
        makeSeparator()
        backgroundColor = .darkGray2
        tintColor = .white
    }
    
    private func configureSelectedBackgroundView() {
        let SelectedColorView = UIView()
        SelectedColorView.backgroundColor = UIColor.lightGray2
        selectedBackgroundView = SelectedColorView
    }
    
    private func configureContentViews() {
        guard let colorName = colorName, titleLabel.text != "Any" else {
            configureTitleLabel()
            return
        }
        configureColorViewAndTitleLabel(colorName: colorName)
    }
    
    private func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func configureColorViewAndTitleLabel(colorName: String) {
        let RoundColorView = UIView()
        contentView.addSubview(RoundColorView)
        RoundColorView.backgroundColor = .blue
        RoundColorView.frame.size.width = 30
        RoundColorView.layer.cornerRadius = 9
        if colorName == "Black and White" {
            RoundColorView.backgroundColor = .white
        } else {
            guard let color = Color(rawValue: colorName) else { return }
            RoundColorView.backgroundColor = color.makeColor
        }
        RoundColorView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(13)
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-13)
            self.sizeConstraint = $0.width.equalTo(19).constraint
        }
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(RoundColorView.snp.trailing).offset(10)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func makeSeparator() {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 17.0, y: 45.0, width: UIScreen.main.bounds.width, height: 0.5)
        bottomBorder.backgroundColor = UIColor.darkGray.cgColor
        contentView.layer.addSublayer(bottomBorder)
    }
}

enum Color: String {
    case White
    case Black
    case Yellow
    case Orange
    case Red
    case Purple
    case Magenta
    case Green
    case Teal
    case Blue
    
    var makeColor: UIColor {
        switch self {
        case .White:
            return UIColor.white
        case .Black:
            return UIColor.black
        case .Yellow:
            return UIColor.yellow
        case .Orange:
            return UIColor.orange
        case .Red:
            return UIColor.red
        case .Purple:
            return UIColor.systemPurple
        case .Magenta:
            return UIColor.magenta
        case .Green:
            return UIColor.green
        case .Teal:
            return UIColor.systemTeal
        case .Blue:
            return UIColor.systemBlue
        }
    }
}

