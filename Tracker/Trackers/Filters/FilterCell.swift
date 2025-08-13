//
//  FilterCell.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 12.08.2025.
//

import UIKit

final class FilterCell: UITableViewCell {
    static let identifier = "FilterCell"

    private let titleLabel = UILabel()
    private let checkmarkView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .ypGrayBackground
        selectionStyle = .none

        titleLabel.font = .regular17
        titleLabel.textColor = .ypBlack

        checkmarkView.image = UIImage(systemName: "checkmark")
        checkmarkView.tintColor = .systemBlue
        checkmarkView.isHidden = true

        contentView.addSubview(titleLabel)
        contentView.addSubview(checkmarkView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        checkmarkView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            checkmarkView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkmarkView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkView.widthAnchor.constraint(equalToConstant: 20),
            checkmarkView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        checkmarkView.isHidden = !isSelected
    }
}
