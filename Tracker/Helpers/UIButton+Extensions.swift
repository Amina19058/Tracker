//
//  UIButton+Extensions.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 08.08.2025.
//

import UIKit

final class YPButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(.ypWhite, for: .normal)
        setTitleColor(.white, for: .disabled)
        titleLabel?.font = .medium16
        backgroundColor = isEnabled ? .ypBlack : .ypGray
        layer.cornerRadius = 16
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 60).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
