//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 11.08.2025.
//

import Foundation
import AppMetricaCore

struct AnalyticsService {
    static let shared = AnalyticsService()
    private init() {}
    
    func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: "8242258f-d4aa-4694-80aa-906bf2b32607") else {
            print("Failed to create AppMetrica configuration")
            return
        }
        
        AppMetrica.activate(with: configuration)
    }
    
    func report(eventName: String, parameters: [AnyHashable: Any]) {
        AppMetrica.reportEvent(name: eventName, parameters: parameters) { error in
            print("Failed to report: \(error.localizedDescription)")
        }
    }
    
    func report(event: AnalyticsEvent, screen: AnalyticsScreen, item: AnalyticsItem? = nil) {
        var parameters: [String: String] = [
            "event": event.rawValue,
            "screen": screen.rawValue
        ]
        
        if let item = item {
            parameters["item"] = item.rawValue
        }
        
        report(eventName: event.rawValue, parameters: parameters)
    }
}

enum AnalyticsEvent: String {
    case open
    case close
    case click
}

enum AnalyticsScreen: String {
    case main
}

enum AnalyticsItem: String {
    case addTrack = "add_track"
    case track
    case filter
    case edit
    case delete
}
