//
//  WeekDay.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 14.07.2025.
//

enum WeekDay: CaseIterable, Codable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday

    var fullName: String {
        switch self {
        case .monday: return L10n.monday
        case .tuesday: return L10n.tuesday
        case .wednesday: return L10n.wednesday
        case .thursday: return L10n.thursday
        case .friday: return L10n.friday
        case .saturday: return L10n.saturday
        case .sunday: return L10n.sunday
        }
    }

    var shortName: String {
        switch self {
        case .monday: return L10n.mondayShort
        case .tuesday: return L10n.tuesdayShort
        case .wednesday: return L10n.wednesdayShort
        case .thursday: return L10n.thursdayShort
        case .friday: return L10n.fridayShort
        case .saturday: return L10n.saturdayShort
        case .sunday: return L10n.sundayShort
        }
    }
}

import Foundation

extension WeekDay {
    static func from(date: Date) -> WeekDay? {
        let calendar = Calendar.current
        let weekdayNumber = calendar.component(.weekday, from: date)

        switch weekdayNumber {
        case 1: return .sunday
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        default: return nil
        }
    }
}
