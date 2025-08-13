//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 27.05.2025.
//

import UIKit

final class TrackersViewController: UIViewController {
    private var selectedDate: Date = Date()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        return collectionView
    }()

    private var helper: SupplementaryCollection?
    private let storage = DataStoreManager.shared
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.text = L10n.trackersTitle
        titleLabel.font = .title
        titleLabel.textColor = .ypBlack
        
        return titleLabel
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        
        searchBar.placeholder = L10n.searchFieldPlaceholder
        searchBar.searchBarStyle = .minimal
        searchBar.layer.cornerRadius = 10
        searchBar.clipsToBounds = true
        
        return searchBar
    }()
    
    private let stubView: StubView = {
        let view = StubView(model: StubModel(
            image: UIImage(named: .Trackers.starStubImage),
            text: L10n.trackersScreenStubText
        ))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var filtersButton: YPButton = {
        let button = YPButton()
        button.setTitle(L10n.filtersButtonTitle, for: .normal)
        button.backgroundColor = .ypBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(filtersTapped), for: .touchUpInside)
        return button
    }()
    
    private var datePicker = DatePicker
    
    private var selectedFilter: Filter {
        get {
            UserDefaultsService.shared.selectedFilter
        }
        set {
            UserDefaultsService.shared.selectedFilter = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AnalyticsService.shared.report(
            event: .open,
            screen: .main
        )
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        AnalyticsService.shared.report(
            event: .close,
            screen: .main
        )
    }

    private func setupUI() {
        view.backgroundColor = .ypWhite
        
        setupNavigationBar()
        setupTitleLabel()
        setupSearchBar()
        setupCollectionView()
        setupStub()
        updateStubVisibility()
        helper?.updateVisibleTrackers(for: selectedDate)
        
        storage.trackerStore.delegate = self
        storage.categoryStore.delegate = self
    }
    
    private func setupNavigationBar() {
        let addButton = UIButton(type: .system)
        addButton.addTarget(self, action: #selector(addTrackerTapped), for: .touchUpInside)
        addButton.setImage(.plusIcon, for: .normal)
        addButton.tintColor = .ypBlack
        addButton.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addButton)
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: datePicker)
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1)
        ])
        
        titleLabel.accessibilityIdentifier = .AccessibilityIdentifiers.trackersTitleLabel
    }
    
    private func setupSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchBar.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        searchBar.accessibilityIdentifier = .AccessibilityIdentifiers.searchBar
    }
    
    private func setupStub() {
        view.addSubview(stubView)

        NSLayoutConstraint.activate([
            stubView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stubView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 220)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .ypWhite
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        view.addSubview(filtersButton)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 24),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            filtersButton.widthAnchor.constraint(equalToConstant: 114),
            filtersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        let params = GeometricParams(cellCount: 2,
                                     leftInset: 16,
                                     rightInset: 16,
                                     cellSpacing: 9)
        self.helper = SupplementaryCollection(using: params, collection: collectionView)
        self.helper?.delegate = self
        
        helper?.updateVisibleTrackers(for: selectedDate)
    }
    
    private func updateStubVisibility() {
        let hasTrackers = helper?.isEmpty == false
        stubView.isHidden = hasTrackers
        filtersButton.isHidden = !hasTrackers
    }
    
    @objc private func addTrackerTapped() {
        AnalyticsService.shared.report(
            event: .click,
            screen: .main,
            item: .addTrack
        )
        
        let createTrackerVC = CreateTrackerViewController()
        createTrackerVC.delegate = self
        
        let nav = UINavigationController(rootViewController: createTrackerVC)
        
        present(nav, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        selectedFilter = .all
        helper?.updateVisibleTrackers(for: selectedDate)
        updateStubVisibility()
    }
    
    @objc func filtersTapped() {
        AnalyticsService.shared.report(
            event: .click,
            screen: .main,
            item: .filter
        )
        
        let filtersVC = FiltersViewController()
        filtersVC.onFiltersChanged = { [weak self] filter in
            guard let self = self else {return}
            
            if filter == Filter.today {
                datePicker.date = Date()
                selectedDate = datePicker.date
            }
            helper?.updateVisibleTrackers(for: selectedDate)
            updateStubVisibility()
        }
        
        let nav = UINavigationController(rootViewController: filtersVC)
        
        present(nav, animated: true)
    }
}

extension TrackersViewController: CreateTrackerViewControllerDelegate {
    func onCreateTracker(tracker: Tracker, categoryTitle: String) {
        let storage = DataStoreManager.shared
        
        let categoryCoreData = storage.categoryStore.coreDataCategory(with: categoryTitle)
            ?? {
                try? storage.categoryStore.addNewCategory(with: categoryTitle)
                return storage.categoryStore.coreDataCategory(with: categoryTitle)
            }()!

        try? storage.trackerStore.addNewTracker(tracker, to: categoryCoreData)
        dismiss(animated: true, completion: nil)
    }
}

extension TrackersViewController: SupplementaryCollectionDelegate {
    func didUpdateTrackers(isEmpty: Bool) {
        stubView.isHidden = !isEmpty
    }
    
    func didRequestEdit(trackerInfo: TrackerInfo) {
        AnalyticsService.shared.report(
            event: .click,
            screen: .main,
            item: .edit
        )
        
        let viewModel = EditTrackerViewModel(
            trackerInfo: trackerInfo,
            trackerStore: DataStoreManager.shared.trackerStore
        )
        let vc = EditTrackerViewController(type: trackerInfo.type, viewModel: viewModel)
        let nav = UINavigationController(rootViewController: vc)
        
        nav.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        nav.navigationBar.shadowImage = UIImage()
        
        present(nav, animated: true)
    }

    func didRequestDelete(trackerInfo: TrackerInfo) {
        AnalyticsService.shared.report(
            event: .click,
            screen: .main,
            item: .delete
        )
        
        let viewModel = EditTrackerViewModel(
            trackerInfo: trackerInfo,
            trackerStore: DataStoreManager.shared.trackerStore
        )
        let alert = UIAlertController(
            title: nil,
            message: L10n.deleteTrackerAlertMessage,
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: L10n.cancelButtonTitle, style: .cancel))
        alert.addAction(UIAlertAction(title: L10n.deleteButtonTitle, style: .destructive) { _ in
            viewModel.deleteTracker()
        })
        present(alert, animated: true)
    }
}


extension TrackersViewController: TrackerStoreDelegate {
    func store(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate) {
        helper?.updateVisibleTrackers(for: selectedDate)
        updateStubVisibility()
        collectionView.reloadData()
    }
}

extension TrackersViewController: CategoryStoreDelegate {
    func storeDidUpdateCategories() {
        helper?.updateVisibleTrackers(for: selectedDate)
        updateStubVisibility()
        collectionView.reloadData()
    }
}
