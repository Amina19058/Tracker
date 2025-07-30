//
//  TrackerCellDelegate.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 28.07.2025.
//

protocol TrackerCellDelegate: AnyObject {
    func didTapTrackerCellButton(for tracker: Tracker, in cell: TrackerCell)
}
