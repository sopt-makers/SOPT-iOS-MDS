//
//  SpacingTokenCell.swift
//  MDSStoryBook
//
//  Created by 강윤서 on 5/8/26.
//

import UIKit

final class SpacingTokenCell: UITableViewCell {
    static let reuseIdentifier = "SpacingTokenCell"

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let barView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var barWidthConstraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupLayout() {
        [nameLabel, valueLabel, barView].forEach { contentView.addSubview($0) }

        let barWidth = barView.widthAnchor.constraint(equalToConstant: 0)
        barWidthConstraint = barWidth

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: 40),

            valueLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            valueLabel.widthAnchor.constraint(equalToConstant: 52),

            barView.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor, constant: 12),
            barView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            barView.heightAnchor.constraint(equalToConstant: 4),
            barWidth,
        ])
    }

    func configure(name: String, value: CGFloat, maxValue: CGFloat) {
        nameLabel.text = name
        valueLabel.text = "\(Int(value))px"

        let maxBarWidth = contentView.bounds.width - 16 - 40 - 8 - 52 - 12 - 16
        let ratio = maxValue > 0 ? value / maxValue : 0
        barWidthConstraint?.constant = max(ratio * maxBarWidth, value == 0 ? 0 : 4)
    }
}
