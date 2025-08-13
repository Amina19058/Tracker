//
//  UIColor+Extensions.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 13.08.2025.
//

import UIKit

extension UIColor {
    static let colorSet: [UIColor] = [
        .selection1, .selection2, .selection3,
        .selection4, .selection5, .selection6,
        .selection7, .selection8, .selection9,
        .selection10, .selection11, .selection12,
        .selection13, .selection14, .selection15,
        .selection16, .selection17, .selection18
    ]
}

import UIKit

extension UIColor {
    func isEqualToColor(_ other: UIColor, tolerance: CGFloat = 0.0) -> Bool {
        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var a1: CGFloat = 0
        
        var r2: CGFloat = 0
        var g2: CGFloat = 0
        var b2: CGFloat = 0
        var a2: CGFloat = 0
        
        guard self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1),
              other.getRed(&r2, green: &g2, blue: &b2, alpha: &a2) else {
            return false
        }
        
        return abs(r1 - r2) <= tolerance &&
               abs(g1 - g2) <= tolerance &&
               abs(b1 - b2) <= tolerance &&
               abs(a1 - a2) <= tolerance
    }
}
