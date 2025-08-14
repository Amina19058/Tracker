//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 08.08.2025.
//

import UIKit

enum CategoryEditingMode: Equatable {
    case create
    case edit(index: Int, oldTitle: String)
}

final class NewCategoryViewController: UIViewController {
    private let viewModel: CategoryViewModel
    private let mode: CategoryEditingMode
    
    private let nameTextField = YPPlaceholderTextField()
    private let doneButton = YPButton()

    init(viewModel: CategoryViewModel, mode: CategoryEditingMode = .create) {
        self.viewModel = viewModel
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch mode {
        case .create:
            navigationItem.title = L10n.newCategoryTitle
        case .edit(_, let oldTitle):
            navigationItem.title = L10n.editCategoryTitle
            nameTextField.text = oldTitle
        }
        
        navigationItem.hidesBackButton = true
        view.backgroundColor = .ypWhite
        
        setupUI()
    }

    private func setupUI() {
        updateButtonState()
        
        nameTextField.placeholder = L10n.categoryNamePlaceholder
        nameTextField.addTarget(self, action: #selector(categoryNameChanged), for: .editingChanged)

        doneButton.setTitle(L10n.doneButtonTitle, for: .normal)
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        
        view.enableKeyboardDismissOnTap()

        view.addSubview(nameTextField)
        view.addSubview(doneButton)

        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func categoryNameChanged(_ textField: UITextField) {
        updateButtonState()
    }
    
    private func updateButtonState() {
        let categoryName = nameTextField.text ?? ""
        let isEnabled = !categoryName.isEmpty
        
        doneButton.isEnabled = isEnabled
        doneButton.backgroundColor = isEnabled ? .ypBlack : .lightGray
    }

    @objc private func doneTapped() {
        guard let title = nameTextField.text else { return }
        
        switch mode {
        case .create:
            viewModel.addCategory(title: title)
        case let .edit(index, _):
            viewModel.updateCategoryTitle(at: index, newTitle: title)
        }
        
        navigationController?.popViewController(animated: true)
    }
}
