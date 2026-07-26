//
//  MDSChip.swift
//  MDS
//

import UIKit

public final class MDSChip: UIControl {

    // MARK: - Properties

    public var chipTitle: String? {
        didSet { updateAppearance() }
    }

    public var prefixIcon: MDSIcon? {
        didSet { updateAppearance() }
    }

    public var suffixIcon: MDSIcon? {
        didSet { updateAppearance() }
    }

    public override var isSelected: Bool {
        didSet { updateAppearance() }
    }

    public override var isEnabled: Bool {
        didSet { updateAppearance() }
    }

    private let chipSize: Size
    private let chipType: ChipType

    // MARK: - Subviews

    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let prefixImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()

    private let titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.textAlignment = .center
        return view
    }()

    private let suffixImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()

    // MARK: - Init

    public init(
        size: Size = .medium,
        type: ChipType = .outlined,
        prefixIcon: MDSIcon? = nil,
        suffixIcon: MDSIcon? = nil
    ) {
        self.chipSize = size
        self.chipType = type
        self.prefixIcon = prefixIcon
        self.suffixIcon = suffixIcon
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        setupHierarchy()
        setupLayout()
        updateAppearance()
    }

    private func setupHierarchy() {
        addSubview(contentStackView)
        contentStackView.addArrangedSubview(prefixImageView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(suffixImageView)
    }

    private func setupLayout() {
        let insets = chipSize.contentInsets
        let iconSize = chipSize.iconSize
        contentStackView.spacing = chipSize.iconGap

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.leading),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.trailing),

            prefixImageView.widthAnchor.constraint(equalToConstant: iconSize),
            prefixImageView.heightAnchor.constraint(equalToConstant: iconSize),
            suffixImageView.widthAnchor.constraint(equalToConstant: iconSize),
            suffixImageView.heightAnchor.constraint(equalToConstant: iconSize),
        ])
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }

    // MARK: - Appearance

    private func updateAppearance() {
        let colorToken = ColorToken(type: chipType, isSelected: isSelected, isEnabled: isEnabled)

        layer.masksToBounds = true
        layer.borderWidth = colorToken.stroke == nil ? 0 : 1
        layer.borderColor = colorToken.stroke?.cgColor
        backgroundColor = colorToken.background

        titleLabel.attributedText = NSAttributedString(
            string: chipTitle ?? "",
            attributes: chipSize.typography.attributedStringAttributes(foregroundColor: colorToken.foreground)
        )

        prefixImageView.image = prefixIcon?.image.withRenderingMode(.alwaysTemplate)
        prefixImageView.isHidden = prefixIcon == nil
        prefixImageView.tintColor = colorToken.foreground

        suffixImageView.image = suffixIcon?.image.withRenderingMode(.alwaysTemplate)
        suffixImageView.isHidden = suffixIcon == nil
        suffixImageView.tintColor = colorToken.foreground
    }
}

// MARK: - Color Token

private extension MDSChip {

    struct ColorToken {
        let background: UIColor
        let foreground: UIColor
        let stroke: UIColor?

        init(type: MDSChip.ChipType, isSelected: Bool, isEnabled: Bool) {
            guard isEnabled else {
                background = SemanticColor.Bg.Neutral.ghost
                foreground = SemanticColor.Fg.Neutral.ghost
                stroke = type == .outlined ? SemanticColor.Stroke.Neutral.Default.disabled : nil
                return
            }

            switch type {
            case .outlined:
                background = isSelected ? SemanticColor.Bg.Neutral.subtle : SemanticColor.Bg.Neutral.ghost
                foreground = isSelected ? SemanticColor.Fg.Neutral.bold : SemanticColor.Fg.Neutral.default
                stroke = isSelected ? SemanticColor.Stroke.Neutral.inverse : SemanticColor.Stroke.Neutral.subtle
            case .solid:
                background = isSelected ? SemanticColor.Bg.Neutral.inverse : SemanticColor.Bg.Neutral.ghost
                foreground = isSelected ? SemanticColor.Fg.Neutral.inverse : SemanticColor.Fg.Neutral.default
                stroke = nil
            }
        }
    }
}
