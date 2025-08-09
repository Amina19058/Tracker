//
//  ScheduleDayCell.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 14.07.2025.
//

import UIKit

final class ScheduleDayCell: UITableViewCell {
    static let identifier = "ScheduleDayCell"

    private let dayLabel = UILabel()
    private let toggleSwitch = UISwitch()

    var toggleSwitchChanged: ((Bool) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, isSelected: Bool) {
        dayLabel.text = title
        toggleSwitch.isOn = isSelected
    }

    private func setupUI() {
        backgroundColor = .ypGrayBackground
        selectionStyle = .none

        dayLabel.font = .regular17
        dayLabel.textColor = .ypBlack
        dayLabel.translatesAutoresizingMaskIntoConstraints = false

        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.onTintColor = .systemBlue
        toggleSwitch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)

        contentView.addSubview(dayLabel)
        contentView.addSubview(toggleSwitch)

        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    @objc private func switchToggled() {
        toggleSwitchChanged?(toggleSwitch.isOn)
    }
}
