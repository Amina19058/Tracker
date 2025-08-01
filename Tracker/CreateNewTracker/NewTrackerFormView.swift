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

enum PickerItem: Int, CaseIterable {
    case emoji = 0
    case color
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
        let isEmojiSelected = selectedEmoji != nil
        let isColorSelected = selectedColor != nil
        
        return isNameValid && isScheduleValid && isEmojiSelected && isColorSelected
    }
    
    var trackerName: String = ""

    var selectedSchedule: [WeekDay] {
        selectedDays
    }
    
    var selectedEmoji: String?
    var selectedColor: UIColor?
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
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
    private var collectionViewHeightConstraint: NSLayoutConstraint!

    private var tableItems: [String] {
        let categoryTitle: String = ParameterCellType.category.rawValue
        let scheduleTitle: String = ParameterCellType.schedule.rawValue
        
        return type == .habit ? [categoryTitle, scheduleTitle] : [categoryTitle]
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪",
    ]
    
    private let colors: [UIColor] = [
        .selection1, .selection2, .selection3,
        .selection4, .selection5, .selection6,
        .selection7, .selection8, .selection9,
        .selection10, .selection11, .selection12,
        .selection13, .selection14, .selection15,
        .selection16, .selection17, .selection18
    ]
    
    init(type: TrackerType) {
        self.type = type
        
        super.init(frame: .zero)
        
        onFormChanged = { [weak self] in
            self?.delegate?.updateCreateButtonState()
        }
       
        setupUI()
        setupTableView()
        setupCollectionView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionViewHeight()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {        
        backgroundColor = .ypWhite
        
        nameTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(trackerNameChanged), for: .editingChanged)
        
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(errorLabel)
        
        contentStackView.addArrangedSubview(stackView)
        contentStackView.addArrangedSubview(tableView)
        contentStackView.addArrangedSubview(collectionView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint.isActive = true
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
        collectionViewHeightConstraint.isActive = true
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TrackerParameterCell.self, forCellReuseIdentifier: TrackerParameterCell.identifier)
        
        updateTableHeight()
    }
    
    private func updateTableHeight() {
        let rowHeight: CGFloat = 75
        tableViewHeightConstraint.constant = CGFloat(tableItems.count) * rowHeight
    }
    
    private func updateCollectionViewHeight() {
        collectionView.layoutIfNeeded()
        collectionViewHeightConstraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    @objc private func trackerNameChanged(_ textField: UITextField) {
        trackerName = textField.text ?? ""
        onFormChanged?()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identifier)
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
        collectionView.register(CollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeader.identifier)
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

extension NewTrackerFormView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return PickerItem.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case PickerItem.emoji.rawValue:
            return emojis.count
        case PickerItem.color.rawValue:
            return colors.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case PickerItem.emoji.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.identifier, for: indexPath) as! EmojiCell
            cell.configure(with: emojis[indexPath.item])
            return cell
            
        case PickerItem.color.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as! ColorCell
            cell.configure(with: colors[indexPath.item])
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = CollectionHeader.identifier
        default:
            id = ""
        }
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: id, for: indexPath) as? CollectionHeader else {
            return UICollectionReusableView()
        }
        
        if indexPath.section == PickerItem.emoji.rawValue {
            view.configure(title: "Emoji")
        } else if indexPath.section == PickerItem.color.rawValue {
            view.configure(title: "Цвет")
        }
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 18 * 2
        return CGSize(width: width / 6, height: width / 6)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 0, bottom: 40, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.indexPathsForSelectedItems?.filter({ $0.section == indexPath.section }).forEach({ collectionView.deselectItem(at: $0, animated: false) })
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case PickerItem.emoji.rawValue:
            selectedEmoji = emojis[indexPath.item]
        case PickerItem.color.rawValue:
            selectedColor = colors[indexPath.item]
        default:
            break
        }
        onFormChanged?()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

    }
}
