//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 27.05.2025.
//

import UIKit

class StatisticsViewController: UIViewController {
    private var viewModel: StatisticsViewModel
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.text = L10n.statisticsTitle
        titleLabel.font = .title
        titleLabel.textColor = .ypBlack
        
        return titleLabel
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var tableViewHeightConstraint: NSLayoutConstraint!

    private let stubView: StubView = {
        let view = StubView(model: StubModel(
            image: UIImage(resource: .statisticsStub),
            text: L10n.statisticsScreenStubText
        ))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(viewModel: StatisticsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.recalculateNow()
    }

    private func setupUI() {
        view.backgroundColor = .ypWhite
        
        setupTitleLabel()
        setupTableView()
        setupStub()
        updateStubVisibility()
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44)
        ])
        
        titleLabel.accessibilityIdentifier = .AccessibilityIdentifiers.trackersTitleLabel
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StatisticsCell.self, forCellReuseIdentifier: StatisticsCell.identifier)

        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 77),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        setupStub()
        updateStubVisibility()
    }
    
    private func setupStub() {
        view.addSubview(stubView)

        NSLayoutConstraint.activate([
            stubView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stubView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 246)
        ])
    }
    
    private func updateStubVisibility() {
        stubView.isHidden = viewModel.statistics.count > 0
    }

    private func bindViewModel() {
        viewModel.onStatisticsChanged = {
            self.tableView.reloadData()
            self.updateStubVisibility()
        }
    }
}

// MARK: - UITableViewDelegate
extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        102
    }
}

// MARK: - UITableViewDataSource
extension StatisticsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.statistics.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let statisticsCell = tableView.dequeueReusableCell(
            withIdentifier: StatisticsCell.identifier,
            for: indexPath) as? StatisticsCell
        else {
            return UITableViewCell()
        }
        let item = viewModel.statistics[indexPath.row]
        statisticsCell.configure(title: item.title, count: item.value)
        return statisticsCell
    }
}

