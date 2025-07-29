//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 09.07.2025.
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    weak var delegate: CreateTrackerViewControllerDelegate?

    private let titleLabel: YPLabel = {
        let label = YPLabel()
        label.text = .Labels.createTrackerTitle
        return label
    }()

    private let habitButton: UIButton = {
        let button = UIButton()
        button.setTitle(.Labels.habitButtonTitle, for: .normal)
        return button
    }()

    private let eventButton: UIButton = {
        let button = UIButton()
        button.setTitle(.Labels.eventButtonTitle, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        setupUI()
    }

    private func setupUI() {
        view.addSubview(titleLabel)
        
        [habitButton, eventButton].forEach {
            $0.titleLabel?.font = .medium16
            $0.titleLabel?.textColor = .ypWhite
            $0.backgroundColor = .ypBlack
            $0.layer.cornerRadius = 16
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        habitButton.addTarget(self, action: #selector(createHabit), for: .touchUpInside)
        eventButton.addTarget(self, action: #selector(createEvent), for: .touchUpInside)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            habitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            eventButton.heightAnchor.constraint(equalToConstant: 60),
            eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            eventButton.leadingAnchor.constraint(equalTo: habitButton.leadingAnchor),
            eventButton.trailingAnchor.constraint(equalTo: habitButton.trailingAnchor)
        ])
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
