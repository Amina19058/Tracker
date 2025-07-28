//
//  UITextField+Extensions.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 10.07.2025.
//

import UIKit

extension UITextField {
    func setLeftPadding(_ points: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: points, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
}
