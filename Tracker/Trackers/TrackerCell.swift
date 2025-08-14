//
//  TrackerCell.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 12.06.2025.
//

import UIKit

final class TrackerCell: UICollectionViewCell {
    static let identifier = "TrackerCell"
    
    private var isCompletedToday = false
    private var color: UIColor?
    private var daysCount: Int = 0
    
    weak var delegate: TrackerCellDelegate?
    private var tracker: Tracker?
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .medium12
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emojiBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white.withAlphaComponent(0.3)
        backgroundView.layer.cornerRadius = 12
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        return backgroundView
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .medium16
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .medium12
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.plusIcon, for: .normal)
        button.imageView?.tintColor = .ypWhite
        button.layer.cornerRadius = 17
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.imageView?.contentMode = .center
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        emojiLabel.text = nil
        quantityLabel.text = nil
        cardView.backgroundColor = nil
        isCompletedToday = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        backgroundColor: UIColor,
        emoji: String,
        title: String,
        daysCount: Int,
        isCompletedToday: Bool,
        tracker: Tracker)
    {
        self.tracker = tracker
        self.daysCount = daysCount
        self.isCompletedToday = isCompletedToday
        self.color = backgroundColor
        
        cardView.backgroundColor = backgroundColor
        emojiLabel.text = emoji
        titleLabel.text = title
        
        updateQuantityLabel()
        setupButton(isCompleted: isCompletedToday)
    }
    
    func increaseDayCount() {
        daysCount += 1
        updateQuantityLabel()
        setupButton(isCompleted: true)
    }

    func decreaseDayCount() {
        daysCount -= 1
        updateQuantityLabel()
        setupButton(isCompleted: false)
    }
    
    func setupButton(isCompleted: Bool) {
        isCompletedToday = isCompleted
        
        let config = UIImage.SymbolConfiguration(pointSize: 11, weight: .medium)
        let image = isCompleted ? UIImage(systemName: "checkmark", withConfiguration: config) :
                                  UIImage(systemName: "plus", withConfiguration: config)
        plusButton.setImage(image, for: .normal)

        plusButton.tintColor = .white
        plusButton.backgroundColor = isCompletedToday ? color?.withAlphaComponent(0.3) : color
    }
    
    @objc private func plusButtonTapped() {
        AnalyticsService.shared.report(
            event: .click,
            screen: .main,
            item: .track
        )
        
        guard let tracker else { return }
        delegate?.didTapTrackerCellButton(for: tracker, in: self)
    }
    
    private func updateQuantityLabel() {
        quantityLabel.text = String.localizedStringWithFormat(
            NSLocalizedString("days_count_text", comment: ""),
            daysCount
        )
    }
    
    private func setupUI() {
        contentView.addSubview(cardView)
        
        cardView.addSubview(emojiBackgroundView)
        emojiBackgroundView.addSubview(emojiLabel)
        
        cardView.addSubview(titleLabel)
        
        contentView.addSubview(quantityLabel)
        contentView.addSubview(plusButton)
        
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),

            emojiBackgroundView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiBackgroundView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            emojiBackgroundView.widthAnchor.constraint(equalToConstant: 24),
            emojiBackgroundView.heightAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            
            quantityLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16),
            quantityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),

            plusButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
}
