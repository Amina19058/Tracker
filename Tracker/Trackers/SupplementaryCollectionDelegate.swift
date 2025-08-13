//
//  SupplementaryCollectionDelegate.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 24.07.2025.
//

protocol SupplementaryCollectionDelegate: AnyObject {
    func didUpdateTrackers(isEmpty: Bool)
    func didRequestEdit(trackerInfo: TrackerInfo)
    func didRequestDelete(trackerInfo: TrackerInfo)
}
