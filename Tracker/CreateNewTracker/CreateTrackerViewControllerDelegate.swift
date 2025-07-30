//
//  CreateTrackerViewControllerDelegate.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 09.07.2025.
//

protocol CreateTrackerViewControllerDelegate: AnyObject {
    func onCreateTracker(tracker: Tracker, categoryTitle: String)
}
