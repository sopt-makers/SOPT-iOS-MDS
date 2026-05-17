//
//  ColorTokenCell.swift
//  MDSStoryBook
//
//  Created by 강윤서 on 5/8/26.
//

import UIKit

final class ColorTokenCell: UITableViewCell {
    static let reuseIdentifier = "ColorTokenCell"

    private let swatchView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.separator.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let tokenPathLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedSystemFont(ofSize: 11, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupLayout() {
        [swatchView, nameLabel, tokenPathLabel].forEach { contentView.addSubview($0) }

        NSLayoutConstraint.activate([
            swatchView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            swatchView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            swatchView.widthAnchor.constraint(equalToConstant: 40),
            swatchView.heightAnchor.constraint(equalToConstant: 40),

            nameLabel.leadingAnchor.constraint(equalTo: swatchView.trailingAnchor, constant: 12),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: tokenPathLabel.leadingAnchor, constant: -8),

            tokenPathLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tokenPathLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    func configure(with item: ColorTokenItem) {
        swatchView.backgroundColor = item.color
        nameLabel.text = item.name
        tokenPathLabel.text = item.baseTokenPath
    }
}
