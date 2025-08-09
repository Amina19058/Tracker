//
//  TrackerParameterCell.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 11.07.2025.
//

import UIKit

final class TrackerParameterCell: UITableViewCell {
    static let identifier = "TrackerParameterCell"
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .regular17
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .chevronRight))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .regular17
        label.textColor = .ypGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        valueLabel.text = nil
        contentView.backgroundColor = nil
    }
    
    func configure(title: String, value: String? = nil) {
        titleLabel.text = title

        if let value {
            valueLabel.text = value
            valueLabel.isHidden = false
        } else {
            valueLabel.text = nil
            valueLabel.isHidden = true
        }
    }
    
    private func setupUI() {
        backgroundColor = .ypGrayBackground
        contentView.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.spacing = 2

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueLabel)
        
        contentView.addSubview(arrowImageView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: stackView.topAnchor),

            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 24),
            arrowImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
