//
//  ColorCell.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 31.07.2025.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    static let identifier = "ColorCell"
    
    private let colorView = UIView()
    private var color: UIColor

    override init(frame: CGRect) {
        color = .clear
        
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        self.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        setupColorView()
    }

    override var isSelected: Bool {
        didSet {
            contentView.layer.borderWidth = isSelected ? 3 : 0
            contentView.layer.borderColor = isSelected ? color.withAlphaComponent(0.3).cgColor : nil
        }
    }
    
    func setupColorView() {
        colorView.layer.cornerRadius = 8
        colorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorView)

        NSLayoutConstraint.activate([
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
        

    func configure(with color: UIColor) {
        self.color = color
        colorView.backgroundColor = color
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
