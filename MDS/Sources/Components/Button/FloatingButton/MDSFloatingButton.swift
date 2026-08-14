//
//  MDSFloatingButton.swift
//  MDS
//
//  Created by yungu0010 on 5/31/26.
//

import UIKit

public final class MDSFloatingButton: UIControl {

    // MARK: - Properties

    public var icon: MDSIcon? {
        didSet { updateAppearance() }
    }

    public var iconTint: MDSIcon.Tint {
        didSet { updateAppearance() }
    }

    public var label: String? {
        didSet { updateAppearance() }
    }

    public override var isHighlighted: Bool {
        didSet { updateAppearance() }
    }

    public override var isEnabled: Bool {
        didSet { updateAppearance() }
    }

    private let size: Size

    // MARK: - Subviews

    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        return view
    }()

    // MARK: - Init

    public init(
        size: Size = .default,
        icon: MDSIcon? = nil,
        iconTint: MDSIcon.Tint = .automatic,
        label: String? = nil
    ) {
        self.size = size
        self.icon = icon
        self.iconTint = iconTint
        self.label = label
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
        let sizeToken = SizeToken(size: size)
        layer.cornerRadius = sizeToken.cornerRadius
        layer.masksToBounds = true

        contentStackView.spacing = sizeToken.iconGap
        contentStackView.addArrangedSubview(iconImageView)
        contentStackView.addArrangedSubview(titleLabel)
        addSubview(contentStackView)
    }

    private func setupLayout() {
        let sizeToken = SizeToken(size: size)
        let insets = sizeToken.contentInsets
        let iconSize = sizeToken.iconSize

        titleLabel.setContentHuggingPriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 48),

            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
            contentStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentStackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: insets.leading),
            contentStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -insets.trailing),

            iconImageView.widthAnchor.constraint(equalToConstant: iconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: iconSize),
        ])

        [
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.leading),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.trailing),
        ].forEach {
            $0.priority = .defaultHigh
            $0.isActive = true
        }

        if size == .default {
            NSLayoutConstraint.activate([
                widthAnchor.constraint(equalToConstant: 48),
            ])
        }
    }

    // MARK: - Appearance

    private func updateAppearance() {
        let colorToken = ColorToken(isHighlighted: isHighlighted, isEnabled: isEnabled)
        let sizeToken = SizeToken(size: size)

        backgroundColor = colorToken.background
        iconImageView.setIcon(icon, tint: iconTint, tintColor: colorToken.foreground)

        let hasLabel = !(label?.isEmpty ?? true)
        titleLabel.isHidden = (size == .default) || !hasLabel

        titleLabel.attributedText = NSAttributedString(
            string: label ?? "",
            attributes: sizeToken.typography.attributedStringAttributes(foregroundColor: colorToken.foreground)
        )
    }
}

// MARK: - Size Token

private extension MDSFloatingButton {

    struct SizeToken {
        let cornerRadius: CGFloat
        let contentInsets: NSDirectionalEdgeInsets
        let iconSize: CGFloat
        let iconGap: CGFloat
        let typography: MDSFont

        init(size: MDSFloatingButton.Size) {
            cornerRadius = BaseRadius.Base.r16
            switch size {
            case .default:
                contentInsets = NSDirectionalEdgeInsets(top: BaseSpacing.Base.s10, leading: BaseSpacing.Base.s10, bottom: BaseSpacing.Base.s10, trailing: BaseSpacing.Base.s10)
                iconSize = 28
                iconGap = BaseSpacing.Base.s0
                typography = Typography.label1
            case .extended:
                contentInsets = NSDirectionalEdgeInsets(top: BaseSpacing.Base.s12, leading: BaseSpacing.Base.s14, bottom: BaseSpacing.Base.s12, trailing: BaseSpacing.Base.s14)
                iconSize = 24
                iconGap = BaseSpacing.Base.s4
                typography = Typography.label1
            }
        }
    }
}

// MARK: - Color Token

private extension MDSFloatingButton {

    struct ColorToken {
        let background: UIColor
        let foreground: UIColor

        init(isHighlighted: Bool, isEnabled: Bool) {
            guard isEnabled else {
                background = SemanticColor.Bg.Neutral.Default.disabled
                foreground = SemanticColor.Fg.Neutral.Default.disabled
                return
            }
            background = isHighlighted
                ? SemanticColor.Bg.Neutral.Inverse.hover
                : SemanticColor.Bg.Neutral.inverse
            foreground = SemanticColor.Fg.Neutral.inverse
        }
    }
}
