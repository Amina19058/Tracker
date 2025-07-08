//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 27.05.2025.
//

import UIKit

class TrackersViewController: UIViewController {
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        return collectionView
    }()

    private var helper: SupplementaryCollection?
//    = {
//        let params = GeometricParams(cellCount: 3,
//                                     leftInset: 10,
//                                     rightInset: 10,
//                                     cellSpacing: 10)
//        let helper = SupplementaryCollection(using: params, collection: collectionView)
//        return helper
//    }()
    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        let addButton = UIButton(type: .roundedRect, primaryAction: UIAction(title: "Add color", handler: { [weak self] _ in
            let colors: [UIColor] = [
                .black, .blue, .brown,
                .cyan, .green, .orange,
                .red, .purple, .yellow
            ]
            
            let selectedColors = (0..<2).map { _ in colors[Int.random(in: 0..<colors.count)] }
            self?.helper?.add(colors: selectedColors)
        }))
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.7),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        let params = GeometricParams(cellCount: 2,
                                     leftInset: 16,
                                     rightInset: 16,
                                     cellSpacing: 9)
        self.helper = SupplementaryCollection(using: params, collection: collectionView)
        
//        setupUI()
    }

    private func setupUI() {
//        setupNavigationBar()
//        setupTitleLabel()
//        setupSearchBar()
//        setupStub()
        setupCollectionView()
    }
    
    private func setupNavigationBar() {
        let addButton = UIButton(type: .system)
        addButton.setImage(.plusIcon, for: .normal)
        addButton.tintColor = .ypBlack
        addButton.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addButton)
        
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_CH")
        datePicker.tintColor = .ypBlack
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

        view.addSubview(stubImageView)
        view.addSubview(stubTextLabel)
        
        NSLayoutConstraint.activate([
            stubImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stubImageView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 220),
            stubImageView.heightAnchor.constraint(equalToConstant: 80),
            stubImageView.widthAnchor.constraint(equalToConstant: 80),
            stubTextLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stubTextLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
        ])
        
        stubImageView.accessibilityIdentifier = .AccessibilityIdentifiers.stubImage
        stubTextLabel.accessibilityIdentifier = .AccessibilityIdentifiers.stubLabel
    }
    
    private func setupCollectionView() {
//        view.addSubview(collectionView)
//        
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 24),
//            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
//        ])
    }
    
    func setupAddButton() {

    }
    
    @objc private func addTrackerTapped() {

    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
}
