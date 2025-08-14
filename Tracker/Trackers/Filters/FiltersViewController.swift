//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 12.08.2025.
//

import UIKit

enum Filter: Codable {
    case all
    case today
    case completed
    case incomplete
    
    var title: String {
        switch self {
        case .all:
            return L10n.filterAll
        case .today:
            return L10n.filterToday
        case .completed:
            return L10n.filterCompleted
        case .incomplete:
            return L10n.filterIncomplete
        }
    }
}

final class FiltersViewController: UIViewController {
    private let tableView = UITableView(frame: .zero)
    
    private let filters: [Filter] = [.all, .today, .completed, .incomplete]
    
    var onFiltersChanged: ((Filter) -> ())?
    
    private var selectedFilter: Filter {
        get {
            UserDefaultsService.shared.selectedFilter
        }
        set {
            UserDefaultsService.shared.selectedFilter = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        navigationItem.title = L10n.filtersTitle
        navigationItem.hidesBackButton = true
        view.backgroundColor = .ypWhite
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FilterCell.self, forCellReuseIdentifier: FilterCell.identifier)
        
        tableView.backgroundColor = .ypWhite
        tableView.separatorColor = .ypGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.tableHeaderView = UIView(frame: .zero)
        tableView.layer.cornerRadius = 16
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * filters.count))
        ])
    }

}

// MARK: - UITableViewDataSource
extension FiltersViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FilterCell.identifier,
            for: indexPath) as? FilterCell
        else {
            return UITableViewCell()
        }
        
        let isSelected = filters[indexPath.row] == selectedFilter
        
        cell.configure(title: filters[indexPath.row].title, isSelected: isSelected)
        
        if indexPath.row == filters.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        
        return cell
    }

}

// MARK: - UITableViewDelegate
extension FiltersViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFilter = filters[indexPath.row]
        onFiltersChanged?(selectedFilter)
        dismiss(animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }

}
