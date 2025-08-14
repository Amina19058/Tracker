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
        static let selectedFilterKey = "selectedFilter"
    }

    var hasSeenOnboarding: Bool {
        get { defaults.bool(forKey: Key.hasSeenOnboardingKey) }
        set { defaults.set(newValue, forKey: Key.hasSeenOnboardingKey) }
    }
    
    var selectedFilter: Filter {
        get {
            guard let data = defaults.data(forKey: Key.selectedFilterKey),
                  let record = try? JSONDecoder().decode(Filter.self, from: data) else {
                return .all
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            defaults.set(data, forKey: Key.selectedFilterKey)
        }
    }
}
