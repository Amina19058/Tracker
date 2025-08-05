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
        categoryStore.delegate = self
        recordStore.delegate = self
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
        currentDate = date
        guard let currentWeekDay = WeekDay.from(date: date) else { return }

        let completed = recordStore.records
        
        let updatedCategories = categoryStore.categories.map { category in
            let visibleTrackers = category.trackers.filter { tracker in
                let isCompletedToday = completed.contains {
                    $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: date)
                }

                if tracker.schedule.isEmpty {
                    return !completed.contains { $0.trackerId == tracker.id } || isCompletedToday
                } else {
                    return tracker.schedule.contains(currentWeekDay)
                }
            }
            return TrackerCategory(title: category.title, trackers: visibleTrackers)
        }.filter { !$0.trackers.isEmpty }

        self.categories = updatedCategories
        collection.reloadData()
        print("Fetched completed records:", recordStore.records.map { "\($0.trackerId) - \($0.date)" })

        delegate?.didUpdateTrackers(isEmpty: isEmpty)
    }
}

// MARK: - UICollectionViewDataSource

extension SupplementaryCollection: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count
    }
        
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier,
                                                            for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        cell.prepareForReuse()
        
        let tracker = categories[indexPath.section].trackers[indexPath.row]
        let completed = recordStore.records
        
        let isCompleted = completed.contains {
            $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: currentDate)
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


extension SupplementaryCollection: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = CollectionHeader.identifier
        default:
            id = ""
        }
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: id, for: indexPath) as? CollectionHeader else {
            return UICollectionReusableView()
        }
        
        let title = categories[indexPath.section].title
        view.configure(title: title)
        
        return view
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SupplementaryCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = collectionView.frame.width - params.cellSpacing
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth,
                      height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        params.cellSpacing
    }
}

extension SupplementaryCollection: TrackerCellDelegate {
    func didTapTrackerCellButton(for tracker: Tracker, in cell: TrackerCell) {
        guard Calendar.current.startOfDay(for: currentDate) <= Calendar.current.startOfDay(for: Date()) else {
            return
        }
        
        let record = TrackerRecord(trackerId: tracker.id, date: currentDate)

        let isCompleted = recordStore.records.contains {
            $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: currentDate)
        }

        if isCompleted {
            try? recordStore.removeRecord(record)
        } else {
            recordStore.addNewRecord(record)
        }
        
        collection.reloadData()
    }
}

extension SupplementaryCollection: CategoryStoreDelegate {
    func storeDidUpdateCategories() {
        updateVisibleTrackers(for: currentDate)
    }
}

extension SupplementaryCollection: RecordStoreDelegate {
    func storeDidUpdateRecords() {
        updateVisibleTrackers(for: currentDate)
    }
}
