//
//  TypographyTokenCell.swift
//  MDSStoryBook
//
//  Created by 강윤서 on 5/8/26.
//

import UIKit
import MDS

final class TypographyTokenCell: UITableViewCell {
    static let reuseIdentifier = "TypographyTokenCell"

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let previewLabel: UILabel = {
        let label = UILabel()
        label.text = "다람쥐 헌 쳇바퀴에 타고파"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let propsLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedSystemFont(ofSize: 11, weight: .regular)
        label.textColor = .tertiaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupLayout() {
        [nameLabel, previewLabel, propsLabel].forEach { contentView.addSubview($0) }

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            previewLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            previewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            previewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            propsLabel.topAnchor.constraint(equalTo: previewLabel.bottomAnchor, constant: 6),
            propsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            propsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            propsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }

    func configure(with item: TypographyTokenItem) {
        nameLabel.text = item.name

        let mdsFont = item.mdsFont
        previewLabel.font = mdsFont.font

        // letterSpacing을 % 로 역산
        let letterSpacingPercent = mdsFont.font.pointSize > 0
            ? mdsFont.letterSpacing / mdsFont.font.pointSize * 100
            : 0

        propsLabel.text = String(
            format: "size: %.0fpx   lineHeight: %.0fpx\nletterSpacing: %.0f%%",
            mdsFont.font.pointSize,
            mdsFont.lineHeight,
            letterSpacingPercent
        )
    }
}
