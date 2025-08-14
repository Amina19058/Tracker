//
//  EditTrackerViewController.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 13.08.2025.
//

import UIKit

protocol EditTrackerDelegate: UIViewController {
    func pushVC(_ vc: UIViewController)
    func updateSaveButtonState()
}

final class EditTrackerViewController: UIViewController {
    private let type: TrackerType
    var viewModel: EditTrackerViewModel
    
    private let formView: EditTrackerViewForm
    
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

    private let saveButton: YPButton = {
        let button = YPButton()
        button.setTitle(L10n.saveButtonTitle, for: .normal)
        return button
    }()
    
    init(type: TrackerType, viewModel: EditTrackerViewModel) {
        self.type = type
        self.viewModel = viewModel
        
        formView = EditTrackerViewForm(type: type, viewModel: viewModel)
        
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
        navigationItem.title = L10n.editTrackerTitle
        navigationItem.hidesBackButton = true
        
        setupUI()
    }
    
    private func setupUI() {
        updateSaveButtonState()
        
        formView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(formView)
        
        view.addSubview(cancelButton)
        view.addSubview(saveButton)
        
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -4),

            saveButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            saveButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            
            formView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            formView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            formView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            formView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor)
        ])
    }
    
    @objc
    func cancelTapped() {
        dismiss(animated: true)
    }

    @objc
    func saveTapped() {
        viewModel.trackerInfo.title = formView.trackerName
        viewModel.trackerInfo.emoji = formView.selectedEmoji ?? ""
        viewModel.trackerInfo.color = formView.selectedColor ?? .clear
        viewModel.trackerInfo.schedule = formView.selectedSchedule
        if let category = formView.selectedCategory {
            viewModel.trackerInfo.category = category
        }

        viewModel.saveTracker()
        dismiss(animated: true)
    }
}

extension EditTrackerViewController: EditTrackerDelegate {
    func updateSaveButtonState() {
        let isEnabled = formView.isFormValid
        saveButton.isEnabled = isEnabled
        saveButton.backgroundColor = isEnabled ? .ypBlack : .lightGray
    }
    
    func pushVC(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}
