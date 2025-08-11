//
//  UserDefaultsService.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 10.08.2025.
//

import Foundation

final class UserDefaultsService {
    static let shared = UserDefaultsService()
    private let defaults = UserDefaults.standard

    private init() {}

    private enum Key {
        static let hasSeenOnboardingKey = "hasSeenOnboarding"
    }

    var hasSeenOnboarding: Bool {
        get { defaults.bool(forKey: Key.hasSeenOnboardingKey) }
        set { defaults.set(newValue, forKey: Key.hasSeenOnboardingKey) }
    }
}
