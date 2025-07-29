//
//  NewTrackerFormView.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 10.07.2025.
//

enum TrackerType {
    case habit
    case event
}

enum ParameterCellType: String, CaseIterable {
    case category = "Категория"
    case schedule = "Расписание"
}

import UIKit

final class NewTrackerFormView: UIView {
    private let type: TrackerType
    private let maxCharacterLimit = 38
    private var selectedDays: [WeekDay] = [] {
        didSet {
            tableView.reloadData()
            onFormChanged?()
        }
    }
    
    weak var delegate: NewTrackerDelegate?
    
    var onFormChanged: (() -> Void)?
    
    var isFormValid: Bool {
        let isNameValid = !(trackerName.isEmpty) && (trackerName.count <= maxCharacterLimit)
        let isScheduleValid = type == .event || !selectedSchedule.isEmpty
        return isNameValid && isScheduleValid
    }
    
    var trackerName: String = ""

    var selectedSchedule: [WeekDay] {
        selectedDays
    }
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = .Labels.nameFieldPlaceholder
        textField.backgroundColor = .ypGrayBackground
        textField.layer.cornerRadius = 16
        textField.font = .regular17
        textField.clearButtonMode = .whileEditing
        textField.setLeftPadding(16)
        textField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        return textField
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.font = .regular17
        label.textColor = .ypRed
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.tableHeaderView = UIView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var tableViewHeightConstraint: NSLayoutConstraint!
    
    private var tableItems: [String] {
        let categoryTitle: String = ParameterCellType.category.rawValue
        let scheduleTitle: String = ParameterCellType.schedule.rawValue
        
        return type == .habit ? [categoryTitle, scheduleTitle] : [categoryTitle]
    }
    
    init(type: TrackerType) {
        self.type = type
        
        super.init(frame: .zero)
        
        onFormChanged = { [weak self] in
            self?.delegate?.updateCreateButtonState()
        }
        
        setupUI()
        setupTableView()
        updateTableHeight()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {        
        backgroundColor = .ypWhite
        
        addSubview(stackView)
        addSubview(tableView)
        
        nameTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(trackerNameChanged), for: .editingChanged)
        
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint.isActive = true
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TrackerParameterCell.self, forCellReuseIdentifier: TrackerParameterCell.identifier)
    }
    
    private func updateTableHeight() {
       let rowHeight: CGFloat = 75
       tableViewHeightConstraint.constant = CGFloat(tableItems.count) * rowHeight
   }
    
    @objc private func trackerNameChanged(_ textField: UITextField) {
        trackerName = textField.text ?? ""
        onFormChanged?()
    }
}

extension NewTrackerFormView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackerParameterCell.identifier, for: indexPath) as? TrackerParameterCell else {
            return UITableViewCell()
        }
        
        cell.prepareForReuse()
        
        let title = tableItems[indexPath.row]
        var value: String?

        if title == ParameterCellType.schedule.rawValue {
            value = formattedSchedule(from: selectedDays)
        }

        cell.configure(title: title, value: value)
        
        if indexPath.row == tableItems.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = tableItems[indexPath.row]
        
        switch selectedItem {
        case ParameterCellType.schedule.rawValue:
            let scheduleVC = ScheduleViewController()
            scheduleVC.delegate = self
            
            delegate?.navigationController?.pushViewController(scheduleVC, animated: true)
            
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



extension NewTrackerFormView: ScheduleViewControllerDelegate {
    func didSelectDays(_ selectedDays: [WeekDay]) {
        self.selectedDays = selectedDays
    }
    
    private func formattedSchedule(from days: [WeekDay]) -> String {
        let allDays = WeekDay.allCases

        if days.count == allDays.count {
            return "Каждый день"
        }

        let sorted = allDays.filter { days.contains($0) }

        return sorted.map { $0.shortName }.joined(separator: ", ")
    }

}

extension NewTrackerFormView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text,
              let textRange = Range(range, in: currentText) else { return true }

        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        
        trackerName = updatedText
        onFormChanged?()
        
        errorLabel.isHidden = updatedText.count <= maxCharacterLimit
        return errorLabel.isHidden
    }
}
