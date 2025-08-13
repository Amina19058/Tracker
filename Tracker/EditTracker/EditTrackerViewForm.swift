//
//  EditTrackerViewForm.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 13.08.2025.
//

import UIKit

final class EditTrackerViewForm: UIView {
    private let viewModel: EditTrackerViewModel
    
    private let type: TrackerType
    private let maxCharacterLimit = 38
    
    private var selectedDays: [WeekDay] = [] {
        didSet {
            tableView.reloadData()
            onFormChanged?()
        }
    }
    
    var selectedCategory: TrackerCategory? {
        didSet {
            tableView.reloadData()
            onFormChanged?()
        }
    }
    
    weak var delegate: EditTrackerDelegate?
    
    var onFormChanged: (() -> Void)?
    
    var isFormValid: Bool {
        let isNameValid = !(trackerName.isEmpty) && (trackerName.count <= maxCharacterLimit)
        let isScheduleValid = type == .event || !selectedSchedule.isEmpty
        let isEmojiSelected = selectedEmoji != nil
        let isColorSelected = selectedColor != nil
        let isCategorySelected = selectedCategory != nil
        
        return isNameValid && isScheduleValid && isEmojiSelected && isColorSelected && isCategorySelected
    }
    
    var trackerName: String = ""

    var selectedSchedule: [WeekDay] {
        selectedDays
    }
    
    var selectedEmoji: String? {
        didSet {
            collectionView.reloadData()
            onFormChanged?()
        }
    }
    
    var selectedColor: UIColor? {
        didSet {
            collectionView.reloadData()
            onFormChanged?()
        }
    }
    
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
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .bold32
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: 70).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTextField = YPPlaceholderTextField()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.trackerNameLimitErrorMessage
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
        tableView.separatorColor = .ypGray
        tableView.tableHeaderView = UIView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var tableViewHeightConstraint: NSLayoutConstraint!
    private var collectionViewHeightConstraint: NSLayoutConstraint!

    private var tableItems: [String] {
        let categoryTitle: String = ParameterCellType.category.title
        let scheduleTitle: String = ParameterCellType.schedule.title
        
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
    
    private let emojis = String.emojiSet
    private let colors = UIColor.colorSet
    
    init(type: TrackerType, viewModel: EditTrackerViewModel) {
        self.type = type
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        trackerName = viewModel.trackerInfo.title
        selectedEmoji = viewModel.trackerInfo.emoji
        selectedColor = viewModel.trackerInfo.color
        selectedDays = viewModel.trackerInfo.schedule
        selectedCategory = viewModel.trackerInfo.category

        onFormChanged = { [weak self] in
            self?.delegate?.updateSaveButtonState()
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
        
        quantityLabel.isHidden = type == .event
        updateQuantityLabel()
        
        nameTextField.placeholder = L10n.trackerNamePlaceholder
        nameTextField.text = trackerName
        nameTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(trackerNameChanged), for: .editingChanged)
        
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        enableKeyboardDismissOnTap()
        enableKeyboardDismissOnScroll(for: scrollView)
        
        contentStackView.addArrangedSubview(quantityLabel)
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

            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8),
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
    
    private func updateQuantityLabel() {
        quantityLabel.text = String.localizedStringWithFormat(
            NSLocalizedString("days_count_text", comment: ""),
            viewModel.daysCount
        )
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

extension EditTrackerViewForm: UITableViewDelegate, UITableViewDataSource {
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

        if title == ParameterCellType.schedule.title {
            value = formattedSchedule(from: selectedDays)
        } else if title == ParameterCellType.category.title {
            value = selectedCategory?.title
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
        case ParameterCellType.schedule.title:
            let scheduleVC = ScheduleViewController()
            scheduleVC.delegate = self
            
            delegate?.navigationController?.pushViewController(scheduleVC, animated: true)
            
        case ParameterCellType.category.title:
            let store = DataStoreManager.shared.categoryStore
            let categoryVM = CategoryViewModel(store: store, selectedCategory: selectedCategory)
            let categoryVC = CategoryViewController(viewModel: categoryVM)
            categoryVC.delegate = self

            categoryVM.onSelectionChanged = { [weak self] selected in
                guard let self, let selected else { return }
                self.selectedCategory = selected
                if let index = self.tableItems.firstIndex(of: ParameterCellType.category.title) {
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                }
                self.delegate?.navigationController?.popViewController(animated: true)
            }

            delegate?.navigationController?.pushViewController(categoryVC, animated: true)

            
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension EditTrackerViewForm: ScheduleViewControllerDelegate {
    func didSelectDays(_ selectedDays: [WeekDay]) {
        self.selectedDays = selectedDays
    }
    
    private func formattedSchedule(from days: [WeekDay]) -> String {
        let allDays = WeekDay.allCases

        if days.count == allDays.count {
            return L10n.everyDayScheduleValue
        }

        let sorted = allDays.filter { days.contains($0) }

        return sorted.map { $0.shortName }.joined(separator: ", ")
    }
}

extension EditTrackerViewForm: CategoryViewControllerDelegate {
    func didSelectCategory(_ selectedCategory: TrackerCategory) {
        self.selectedCategory = selectedCategory
        if let index = tableItems.firstIndex(of: ParameterCellType.category.title) {
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }
}

extension EditTrackerViewForm: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text,
              let textRange = Range(range, in: currentText) else { return true }

        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        
        trackerName = updatedText
        onFormChanged?()
        
        errorLabel.isHidden = updatedText.count <= maxCharacterLimit
        return errorLabel.isHidden
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditTrackerViewForm: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
            setSelectedAppearance(indexPath: indexPath, cell: cell)
            return cell
            
        case PickerItem.color.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as! ColorCell
            cell.configure(with: colors[indexPath.item])
            setSelectedAppearance(indexPath: indexPath, cell: cell)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    private func setSelectedAppearance(indexPath: IndexPath, cell: UICollectionViewCell) {
        if indexPath.section == PickerItem.emoji.rawValue,
           emojis[indexPath.item] == selectedEmoji {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            cell.isSelected = true
        }

        if indexPath.section == PickerItem.color.rawValue,
           colors[indexPath.item].isEqualToColor(selectedColor ?? .clear) {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            cell.isSelected = true
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
            view.configure(title: L10n.emojiSectionTitle)
        } else if indexPath.section == PickerItem.color.rawValue {
            view.configure(title: L10n.colorSectionTitle)
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets { UIEdgeInsets(top: 24, left: 0, bottom: 40, right: 0) }

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
        switch indexPath.section {
        case PickerItem.emoji.rawValue:
            selectedEmoji = nil
        case PickerItem.color.rawValue:
            selectedColor = nil
        default:
            break
        }
        onFormChanged?()
    }
}
