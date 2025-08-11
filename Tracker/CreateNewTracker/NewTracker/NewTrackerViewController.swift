//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 13.07.2025.
//

import UIKit

protocol NewTrackerDelegate: UIViewController {
    func pushVC(_ vc: UIViewController)
    func updateCreateButtonState()
}

final class NewTrackerViewController: UIViewController {
    private let type: TrackerType
    private let formView: NewTrackerFormView
    private weak var delegate: CreateTrackerViewControllerDelegate?
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.cancelButtonTitle, for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let createButton: YPButton = {
        let button = YPButton()
        button.setTitle(L10n.createButtonTitle, for: .normal)
        return button
    }()
    
    
    init(type: TrackerType, createTrackerDelegate: CreateTrackerViewControllerDelegate?) {
        self.type = type
        delegate = createTrackerDelegate
        formView = NewTrackerFormView(type: type)
        super.init(nibName: nil, bundle: nil)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        formView.delegate = self
        
        view.backgroundColor = .ypWhite
        navigationItem.title = type == .event ? L10n.newEventTitle : L10n.newHabitTitle
        navigationItem.hidesBackButton = true
        
        setupUI()
    }

    private func setupUI() {
        updateCreateButtonState()
        
        formView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(formView)
        
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -4),

            createButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            createButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            
            formView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            formView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            formView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            formView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor)
        ])
    }
    
    @objc private func createTapped() {
        let name = formView.trackerName
        let schedule = formView.selectedSchedule
        
        guard
            let emoji = formView.selectedEmoji,
            let color = formView.selectedColor
        else { return }
        
        let tracker = Tracker(
            id: UUID(),
            title: name,
            color: color,
            emoji: emoji,
            schedule: schedule
        )

        guard let category = formView.selectedCategory else { return }

        delegate?.onCreateTracker(tracker: tracker, categoryTitle: category.title)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func cancelTapped() {
        navigationController?.popViewController(animated: true)
    }

}

extension NewTrackerViewController: NewTrackerDelegate {
    func updateCreateButtonState() {
        let isEnabled = formView.isFormValid
        createButton.isEnabled = isEnabled
        createButton.backgroundColor = isEnabled ? .ypBlack : .lightGray
    }
    
    func pushVC(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}
