//
//  UIDatePicker+Extensions.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 10.08.2025.
//

import UIKit

var DatePicker: UIDatePicker = {
    let datePicker = UIDatePicker()
    datePicker.preferredDatePickerStyle = .compact
    datePicker.datePickerMode = .date
    datePicker.locale = .current
    datePicker.tintColor = .blue
    datePicker.layer.cornerRadius = 8
    datePicker.clipsToBounds = true
    return datePicker
}()
