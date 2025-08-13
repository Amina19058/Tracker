//
//  SupplementaryCollection.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 06.07.2025.
//

import UIKit

struct GeometricParams {
    let cellCount: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let cellSpacing: CGFloat
    let paddingWidth: CGFloat
    
    init(cellCount: Int, leftInset: CGFloat, rightInset: CGFloat, cellSpacing: CGFloat) {
        self.cellCount = cellCount
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.cellSpacing = cellSpacing
        self.paddingWidth = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpacing
    }
}

final class SupplementaryCollection: NSObject {
    weak var delegate: SupplementaryCollectionDelegate?
    
    private var categories = [TrackerCategory]()

    private var currentDate: Date = Date()
    
    private let params: GeometricParams
    private let collection: UICollectionView
    
    private let categoryStore: TrackerCategoryStore = DataStoreManager.shared.categoryStore
    private let recordStore: TrackerRecordStore = DataStoreManager.shared.recordStore
    
    var isEmpty: Bool {
        return categories.allSatisfy { $0.trackers.isEmpty }
    }

    init(using params: GeometricParams, collection: UICollectionView) {
        self.params = params
        self.collection = collection
        super.init()
        
        configureStores()
        configureCollectionView()
    }

    private func configureStores() {
        categoryStore.delegate = self
        recordStore.delegate = self
    }

    private func configureCollectionView() {
        collection.allowsMultipleSelection = false
        collection.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identifier)
        collection.register(CollectionHeader.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: CollectionHeader.identifier)
        collection.delegate = self
        collection.dataSource = self
        collection.reloadData()
    }

    func updateVisibleTrackers(for date: Date) {
        switch UserDefaultsService.shared.selectedFilter {
        case .completed: categories = filter(completed: true, date: date)
            break
        case .incomplete: categories = filter(completed: false, date: date)
            break
        default: categories = filterBy(date: date)
        }

        collection.reloadData()
        delegate?.didUpdateTrackers(isEmpty: isEmpty)
    }
    
    private func filterBy(date: Date) -> [TrackerCategory] {
        currentDate = date
        let completed = recordStore.records
        guard let weekday = WeekDay.from(date: date) else { return [] }
        
        return categoryStore.categories.compactMap { category in
            let trackersForDay = category.trackers.filter { tracker in
                let isCompletedToday = completed.contains {
                    $0.trackerId == tracker.id &&
                    Calendar.current.isDate($0.date, inSameDayAs: date)
                }
                if tracker.schedule.isEmpty {
                    return !completed.contains { $0.trackerId == tracker.id } || isCompletedToday
                } else {
                    return tracker.schedule.contains(weekday)
                }
            }
            return trackersForDay.isEmpty ? nil : TrackerCategory(title: category.title, trackers: trackersForDay)
        }
    }

    private func filter(completed: Bool, date: Date) -> [TrackerCategory] {
        let completedRecords = recordStore.records
        let allForDate = filterBy(date: date)
        
        return allForDate.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                let isCompletedToday = completedRecords.contains {
                    $0.trackerId == tracker.id &&
                    Calendar.current.isDate($0.date, inSameDayAs: date)
                }
                return completed ? isCompletedToday : !isCompletedToday
            }
            return filteredTrackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filteredTrackers)
        }
    }

}

// MARK: - UICollectionViewDataSource

extension SupplementaryCollection: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        categories.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories[section].trackers.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCell.identifier,
            for: indexPath
        ) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        cell.prepareForReuse()
        
        let tracker = categories[indexPath.section].trackers[indexPath.item]
        let completed = recordStore.records
        
        let isCompleted = completed.contains {
            $0.trackerId == tracker.id &&
            Calendar.current.isDate($0.date, inSameDayAs: currentDate)
        }
        
        let daysCount = completed.filter { $0.trackerId == tracker.id }.count
        
        cell.delegate = self
        cell.configure(
            backgroundColor: tracker.color,
            emoji: tracker.emoji,
            title: tracker.title,
            daysCount: daysCount,
            isCompletedToday: isCompleted,
            tracker: tracker
        )

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SupplementaryCollection: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CollectionHeader.identifier,
            for: indexPath
        ) as? CollectionHeader else {
            return UICollectionReusableView()
        }

        let title = categories[indexPath.section].title
        headerView.configure(title: title)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint)
    -> UIContextMenuConfiguration? {
        
        let tracker = categories[indexPath.section].trackers[indexPath.item]
        let daysCount = recordStore.records.filter { $0.trackerId == tracker.id }.count
        let trackerType: TrackerType = tracker.schedule.isEmpty ? .event : .habit
        
        let trackerInfo = TrackerInfo(
            id: tracker.id,
            title: tracker.title,
            color: tracker.color,
            emoji: tracker.emoji,
            schedule: tracker.schedule,
            daysCount: daysCount,
            category: categories[indexPath.section],
            type: trackerType
        )
        
        let editAction = UIAction(title: L10n.editButtonTitle) { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.didRequestEdit(trackerInfo: trackerInfo)
        }

        let deleteAction = UIAction(
            title: L10n.deleteButtonTitle,
            attributes: .destructive
        ) { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.didRequestDelete(trackerInfo: trackerInfo)
        }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(title: "", children: [editAction, deleteAction])
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SupplementaryCollection: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 46)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = collectionView.frame.width - params.cellSpacing
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: 148)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        params.cellSpacing
    }
}

// MARK: - TrackerCellDelegate

extension SupplementaryCollection: TrackerCellDelegate {
    
    func didTapTrackerCellButton(for tracker: Tracker, in cell: TrackerCell) {
        let today = Calendar.current.startOfDay(for: Date())
        let selectedDay = Calendar.current.startOfDay(for: currentDate)
        
        guard selectedDay <= today else { return }

        let record = TrackerRecord(trackerId: tracker.id, date: currentDate)
        
        let isCompleted = recordStore.records.contains {
            $0.trackerId == tracker.id &&
            Calendar.current.isDate($0.date, inSameDayAs: currentDate)
        }

        if isCompleted {
            try? recordStore.removeRecord(record)
        } else {
            recordStore.addNewRecord(record)
        }

        collection.reloadData()
    }
}

// MARK: - CategoryStoreDelegate

extension SupplementaryCollection: CategoryStoreDelegate {
    func storeDidUpdateCategories() {
        updateVisibleTrackers(for: currentDate)
    }
}

// MARK: - RecordStoreDelegate

extension SupplementaryCollection: RecordStoreDelegate {
    func storeDidUpdateRecords() {
        updateVisibleTrackers(for: currentDate)
    }
}
