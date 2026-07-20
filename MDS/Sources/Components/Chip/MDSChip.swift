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
            self.applyAppearance(to: &config, isSelected: button.isSelected, isEnabled: button.isEnabled)
            button.configuration = config
        }
    }

    // MARK: - Appearance

    private func applyAppearance(to config: inout UIButton.Configuration, isSelected: Bool, isEnabled: Bool) {
        config.background.backgroundColor = !isEnabled
            ? SemanticColor.Bg.Neutral.ghost
            : isSelected ? SemanticColor.Bg.Neutral.subtle : SemanticColor.Bg.Neutral.ghost

        config.background.strokeColor = !isEnabled
            ? SemanticColor.Stroke.Neutral.Default.disabled
            : isSelected ? SemanticColor.Stroke.Neutral.inverse : SemanticColor.Stroke.Neutral.subtle
        config.background.strokeWidth = 1

        let textColor = !isEnabled
            ? SemanticColor.Fg.Neutral.ghost
            : isSelected ? SemanticColor.Fg.Neutral.bold : SemanticColor.Fg.Neutral.default

        let typography = chipSize.typography
        config.attributedTitle = AttributedString(
            NSAttributedString(
                string: chipTitle ?? "",
                attributes: typography.attributedStringAttributes(foregroundColor: textColor)
            )
        )
    }
}
