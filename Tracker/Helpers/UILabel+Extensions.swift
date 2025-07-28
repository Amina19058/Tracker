//
//  UILabel+Extensions.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 10.07.2025.
//

import UIKit

final class YPLabel: UILabel {
    init() {
        super.init(frame: .zero)
        self.font = .medium16
        self.textColor = .ypBlack
        self.textAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
