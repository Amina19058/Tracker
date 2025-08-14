//
//  StatisticsCell.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 12.08.2025.
//

import UIKit

final class StatisticsCell: UITableViewCell {
    static let identifier = "StatisticsCell"
    
    private enum Constants {
        static let cornerRadius: CGFloat = 16
        static let borderWidth: CGFloat = 1
        static let horizontalPadding: CGFloat = 12
        static let verticalSpacing: CGFloat = 12
        static let quantityHeight: CGFloat = 41
        static let titleHeight: CGFloat = 34
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypWhite
        view.layer.cornerRadius = Constants.cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .title
        label.textColor = .ypBlack
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .medium12
        label.textColor = .ypBlack
        return label
    }()

    private let gradientBorder = CAGradientLayer()
    private let shapeLayer = CAShapeLayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradient()
    }
    
    func configure(title: String, count: Int) {
        titleLabel.text = title
        quantityLabel.text = "\(count)"
    }
    
    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(containerView)
        
        setupGradient()
        
        [quantityLabel, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalSpacing),

            quantityLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.horizontalPadding),
            quantityLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.horizontalPadding),
            quantityLabel.heightAnchor.constraint(equalToConstant: Constants.quantityHeight),
            quantityLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.verticalSpacing),

            titleLabel.leadingAnchor.constraint(equalTo: quantityLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: quantityLabel.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.titleHeight),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.verticalSpacing)
        ])
    }
    
    private func setupGradient() {
        gradientBorder.colors = [
            UIColor.selection1.cgColor,
            UIColor.selection9.cgColor,
            UIColor.selection3.cgColor
        ]
        gradientBorder.startPoint = CGPoint(x: 0, y: 0.5)
        gradientBorder.endPoint = CGPoint(x: 1, y: 0.5)
        
        gradientBorder.mask = shapeLayer
        containerView.layer.insertSublayer(gradientBorder, at: 0)
    }
    
    private func updateGradient() {
        gradientBorder.frame = containerView.bounds
        
        let outerPath = UIBezierPath(
            roundedRect: containerView.bounds,
            cornerRadius: Constants.cornerRadius
        )
        
        let innerPath = UIBezierPath(
            roundedRect: containerView.bounds.insetBy(dx: Constants.borderWidth, dy: Constants.borderWidth),
            cornerRadius: Constants.cornerRadius - Constants.borderWidth
        )
        
        outerPath.append(innerPath)
        outerPath.usesEvenOddFillRule = true
        
        shapeLayer.path = outerPath.cgPath
        shapeLayer.fillRule = .evenOdd
    }
}
