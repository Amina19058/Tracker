//
//  TrackersCategoryHeader.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 12.06.2025.
//

import UIKit

class TrackersCategoryHeader: UICollectionReusableView {
    static let identifier = "header"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .bold19
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant:  12),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
