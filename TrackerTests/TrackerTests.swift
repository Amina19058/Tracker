//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Amina Khusnutdinova on 11.08.2025.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testTrackersLightScreen() {
        let vc = TrackersViewController()
        
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testTrackersDarkScreen() {
        let vc = TrackersViewController()
        
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }

}
