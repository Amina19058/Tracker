//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 07.08.2025.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func didSelectCategory(_ selectedCategory: TrackerCategory)
}

final class CategoryViewController: UIViewController {
    weak var delegate: CategoryViewControllerDelegate?
    
    private let tableView = UITableView(frame: .zero)
    private let addButton = YPButton()
    private var stubView = UIView()
    
    private let viewModel: CategoryViewModel
    
    private var tableViewHeightConstraint: NSLayoutConstraint!
    
    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        updateStubVisibility()
        updateTableHeight()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateTableHeight()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.onCategoriesChanged = { [weak self] _ in
            self?.tableView.reloadData()
            self?.updateStubVisibility()
        }

        viewModel.onSelectionChanged = { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    private func setupUI() {
        navigationItem.title = .Labels.categoryTitle
        navigationItem.hidesBackButton = true
        view.backgroundColor = .ypWhite
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .ypWhite
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.tableHeaderView = UIView(frame: .zero)
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identifier)
        tableView.layer.cornerRadius = 16

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        addButton.setTitle(.Labels.addCategoryButtonTitle, for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

        view.addSubview(addButton)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: .zero)
        tableViewHeightConstraint.isActive = true
        
        setupStub()
        updateStubVisibility()
    }
    
    private func updateTableHeight() {
        tableViewHeightConstraint.constant = CGFloat(viewModel.numberOfCategories) * 75
    }
    
    private func setupStub() {
        stubView = StubView(model: StubModel(
            image: UIImage(named: .Trackers.starStubImage),
            text: .Labels.categoryScreenStubText
        ))
        stubView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stubView)

        NSLayoutConstraint.activate([
            stubView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stubView.topAnchor.constraint(
                equalTo: navigationItem.titleView?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor,
                constant: 232
            )
        ])
    }
    
    private func updateStubVisibility() {
        stubView.isHidden = viewModel.numberOfCategories > 0
    }
    
    @objc private func addButtonTapped() {
        let viewController = NewCategoryViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - TableView

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCategories
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }

        let title = viewModel.categoryTitle(at: indexPath.row)
        let isSelected = viewModel.selectedCategory?.title == title
        cell.configure(title: title, isSelected: isSelected)
        
        if indexPath.row == viewModel.numberOfCategories - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }

        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = viewModel.categories[indexPath.row]
        delegate?.didSelectCategory(category)
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint)
    -> UIContextMenuConfiguration? {
        let editAction = UIAction(title: .Labels.editButtonTitle) { [weak self] _ in
            guard let self = self else { return }
            
            let vc = NewCategoryViewController(
                viewModel: self.viewModel,
                mode: .edit(index: indexPath.row, oldTitle: self.viewModel.categoryTitle(at: indexPath.row))
            )
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let deleteAction = UIAction(
            title: .Labels.deleteButtonTitle,
            attributes: .destructive
        ) { [weak self] _ in
            guard let self = self else { return }
            
            self.showDeleteAlert(for: indexPath)
        }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(title: "", children: [editAction, deleteAction])
        }
    }
    
    private func showDeleteAlert(for indexPath: IndexPath) {
        let alert = UIAlertController(title: nil,
                                      message: .Labels.deleteCategoryAlertMessage,
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: .Labels.cancelButtonTitle, style: .cancel))
        alert.addAction(UIAlertAction(title: .Labels.deleteButtonTitle, style: .destructive, handler: { [weak self] _ in
            self?.viewModel.deleteCategory(at: indexPath.row)
        }))
        present(alert, animated: true)
    }
}
