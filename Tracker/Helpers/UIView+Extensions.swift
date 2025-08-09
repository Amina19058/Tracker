//
//  UIView+Extensions.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 08.08.2025.
//

import UIKit
struct StubModel {
    let image: UIImage?
    let text: String
}

final class StubView: UIView {
    private var model: StubModel
    
    private var stubImageView: UIImageView = UIImageView()

    private var stubTextLabel: UILabel = {
        let label = UILabel()
        label.font = .medium12
        label.textColor = .ypBlack
        label.textAlignment = .center
        return label
    }()
    
    init(model: StubModel) {
        self.model = model
        super.init(frame: .zero)
        
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .ypWhite
        stubTextLabel.text = model.text
        stubTextLabel.numberOfLines = 0
        stubImageView.image = model.image
        
        [stubTextLabel, stubImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            stubImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stubImageView.topAnchor.constraint(equalTo: topAnchor),
            stubImageView.widthAnchor.constraint(equalToConstant: 80),
            stubImageView.heightAnchor.constraint(equalToConstant: 80),

            stubTextLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            stubTextLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            stubTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        stubImageView.accessibilityIdentifier = .AccessibilityIdentifiers.stubImage
        stubTextLabel.accessibilityIdentifier = .AccessibilityIdentifiers.stubLabel
    }
}

extension UIView {
    func enableKeyboardDismissOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }
    
    func enableKeyboardDismissOnScroll(for scrollView: UIScrollView) {
        scrollView.keyboardDismissMode = .onDrag
    }

    @objc private func hideKeyboard() {
        endEditing(true)
    }
}
