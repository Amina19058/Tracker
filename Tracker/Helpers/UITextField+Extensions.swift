//
//  UITextField+Extensions.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 10.07.2025.
//

import UIKit

final class YPPlaceholderTextField: UITextField {
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        textColor = .ypBlack
        backgroundColor = .ypGrayBackground
        layer.cornerRadius = 16
        font = .regular17
        clearButtonMode = .whileEditing
        setLeftPadding(16)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 75).isActive = true
    }
}

extension UITextField {
    func setLeftPadding(_ points: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: points, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
}
