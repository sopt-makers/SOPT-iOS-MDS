//
//  MDSChip.swift
//  MDS
//

import UIKit

public final class MDSChip: UIButton {

    // MARK: - Properties

    public var chipTitle: String? {
        didSet { setNeedsUpdateConfiguration() }
    }

    private let chipSize: Size

    // MARK: - Init

    public init(size: Size = .medium) {
        self.chipSize = size
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        var config = UIButton.Configuration.plain()
        config.contentInsets = chipSize.contentInsets
        config.cornerStyle = .capsule
        configuration = config

        configurationUpdateHandler = { [weak self] button in
            guard let self, var config = button.configuration else { return }
            self.applyAppearance(to: &config, isSelected: button.isSelected)
            button.configuration = config
        }
    }

    // MARK: - Appearance

    private func applyAppearance(to config: inout UIButton.Configuration, isSelected: Bool) {
        config.background.backgroundColor = isSelected
            ? SemanticColor.Bg.Neutral.subtle
            : SemanticColor.Bg.Neutral.ghost

        config.background.strokeColor = isSelected
            ? SemanticColor.Stroke.Neutral.inverse
            : SemanticColor.Stroke.Neutral.subtle
        config.background.strokeWidth = 1

        let textColor = isSelected
            ? SemanticColor.Fg.Neutral.bold
            : SemanticColor.Fg.Neutral.subtle

        let typography = chipSize.typography
        config.attributedTitle = AttributedString(
            NSAttributedString(
                string: chipTitle ?? "",
                attributes: [
                    .font: typography.font,
                    .kern: typography.letterSpacing,
                    .foregroundColor: textColor
                ]
            )
        )
    }
}
