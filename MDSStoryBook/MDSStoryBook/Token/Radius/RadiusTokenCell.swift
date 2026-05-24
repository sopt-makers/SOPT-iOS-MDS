//
//  RadiusTokenCell.swift
//  MDSStoryBook
//
//  Created by Codex on 5/24/26.
//

import UIKit

final class RadiusTokenCell: UITableViewCell {
    static let reuseIdentifier = "RadiusTokenCell"

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

    private let previewView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.separator.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupLayout() {
        [nameLabel, valueLabel, previewView].forEach { contentView.addSubview($0) }

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: 48),

            valueLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            valueLabel.widthAnchor.constraint(equalToConstant: 72),

            previewView.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor, constant: 12),
            previewView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            previewView.widthAnchor.constraint(equalToConstant: 48),
            previewView.heightAnchor.constraint(equalToConstant: 32),
        ])
    }

    func configure(name: String, value: CGFloat) {
        nameLabel.text = name
        valueLabel.text = value >= 9999 ? "full" : "\(Int(value))px"
        previewView.layer.cornerRadius = min(value, 16)
    }
}
