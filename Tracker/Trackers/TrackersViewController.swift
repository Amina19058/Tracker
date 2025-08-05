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
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.text = .Labels.trackersTitle
        titleLabel.font = .title
        titleLabel.textColor = .ypBlack
        
        return titleLabel
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        
        searchBar.placeholder = .Labels.searchFieldPlaceholder
        searchBar.searchBarStyle = .minimal
        searchBar.layer.cornerRadius = 10
        searchBar.clipsToBounds = true
        
        return searchBar
    }()
    
    private let stubView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupUI()
    }

    private func setupUI() {
        setupNavigationBar()
        setupTitleLabel()
        setupSearchBar()
        setupCollectionView()
        setupStub()
        updateStubVisibility()
        helper?.updateVisibleTrackers(for: selectedDate)
    }
    
    private func setupNavigationBar() {
        let addButton = UIButton(type: .system)
        addButton.addTarget(self, action: #selector(addTrackerTapped), for: .touchUpInside)
        addButton.setImage(.plusIcon, for: .normal)
        addButton.tintColor = .ypBlack
        addButton.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addButton)
        
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_CH")
        datePicker.tintColor = .blue
        datePicker.layer.cornerRadius = 8
        datePicker.clipsToBounds = true
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
        let stubImageView = UIImageView(image: UIImage(named: .Trackers.starStubImage))
        let stubTextLabel = UILabel()
        stubTextLabel.text = .Labels.stubText
        stubTextLabel.font = .medium12
                
        stubImageView.translatesAutoresizingMaskIntoConstraints = false
        stubTextLabel.translatesAutoresizingMaskIntoConstraints = false

        stubView.addSubview(stubImageView)
        stubView.addSubview(stubTextLabel)
        view.addSubview(stubView)

        NSLayoutConstraint.activate([
            stubView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stubView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 220),
            
            stubImageView.centerXAnchor.constraint(equalTo: stubView.centerXAnchor),
            stubImageView.topAnchor.constraint(equalTo: stubView.topAnchor),
            stubImageView.widthAnchor.constraint(equalToConstant: 80),
            stubImageView.heightAnchor.constraint(equalToConstant: 80),

            stubTextLabel.centerXAnchor.constraint(equalTo: stubView.centerXAnchor),
            stubTextLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            stubTextLabel.bottomAnchor.constraint(equalTo: stubView.bottomAnchor)
        ])
        
        stubImageView.accessibilityIdentifier = .AccessibilityIdentifiers.stubImage
        stubTextLabel.accessibilityIdentifier = .AccessibilityIdentifiers.stubLabel

    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 24),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
    }
    
    @objc private func addTrackerTapped() {
        let createTrackerVC = CreateTrackerViewController()
        createTrackerVC.delegate = self
        
        let nav = UINavigationController(rootViewController: createTrackerVC)
        
        present(nav, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        helper?.updateVisibleTrackers(for: selectedDate)
        updateStubVisibility()
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
        
        updateStubVisibility()
        
        dismiss(animated: true, completion: nil)
        
        
    }
}

extension TrackersViewController: SupplementaryCollectionDelegate {
    func didUpdateTrackers(isEmpty: Bool) {
        stubView.isHidden = !isEmpty
    }
}

