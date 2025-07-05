//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 27.05.2025.
//

import UIKit

class TrackersViewController: UIViewController {
    
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
        
        setupUI()
    }

    private func setupUI() {
        setupNavigationBar()
        setupTitleLabel()
        setupSearchBar()
        setupStub()
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
        stubTextLabel.font = .medium
                
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
    
    @objc private func addTrackerTapped() {

    }
    
    @objc private func datePickerTapped() {

    }
}
