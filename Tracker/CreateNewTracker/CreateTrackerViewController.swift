//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 09.07.2025.
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    weak var delegate: CreateTrackerViewControllerDelegate?

    private let titleLabel = YPLabel(with: L10n.createTrackerTitle)

    private let habitButton: YPButton = {
        let button = YPButton()
        button.setTitle(L10n.habitButtonTitle, for: .normal)
        return button
    }()

    private let eventButton: YPButton = {
        let button = YPButton()
        button.setTitle(L10n.eventButtonTitle, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        setupUI()
    }

    private func setupUI() {        
        [titleLabel, habitButton, eventButton].forEach {
            view.addSubview($0)
        }
        
        habitButton.addTarget(self, action: #selector(createHabit), for: .touchUpInside)
        eventButton.addTarget(self, action: #selector(createEvent), for: .touchUpInside)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            habitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            habitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            eventButton.leadingAnchor.constraint(equalTo: habitButton.leadingAnchor),
            eventButton.trailingAnchor.constraint(equalTo: habitButton.trailingAnchor)
        ])
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    @objc private func createHabit() {
        let habbitVC = NewTrackerViewController(type: .habit, createTrackerDelegate: self.delegate)
        self.navigationController?.pushViewController(habbitVC, animated: true)
    }

    @objc private func createEvent() {
        let eventVC = NewTrackerViewController(type: .event, createTrackerDelegate: self.delegate)
        self.navigationController?.pushViewController(eventVC, animated: true)
    }
}
