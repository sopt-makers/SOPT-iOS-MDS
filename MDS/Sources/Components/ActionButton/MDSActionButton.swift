//
//  MDSActionButton.swift
//  MDS
//
//  Created by yungu0010 on 5/25/26.
//

import UIKit

public final class MDSActionButton: UIControl {

    // MARK: - Properties

    public var title: String? {
        didSet { updateAppearance() }
    }

    public var prefixIcon: UIImage? {
        didSet {
            prefixImageView.image = prefixIcon?.withRenderingMode(.alwaysTemplate)
            prefixImageView.isHidden = prefixIcon == nil
        }
    }

    public var suffixIcon: UIImage? {
        didSet {
            suffixImageView.image = suffixIcon?.withRenderingMode(.alwaysTemplate)
            suffixImageView.isHidden = suffixIcon == nil
        }
    }

    public override var isHighlighted: Bool {
        didSet { updateAppearance() }
    }

    public override var isEnabled: Bool {
        didSet { updateAppearance() }
    }

    private let variant: Variant
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

    private let prefixImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()

    private let titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.numberOfLines = 1
        return view
    }()

    private let suffixImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()

    // MARK: - Init

    public init(variant: Variant = .primary, size: Size = .large) {
        self.variant = variant
        self.size = size
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        let sizeToken = SizeToken(size: size)

        layer.cornerRadius = sizeToken.cornerRadius
        layer.masksToBounds = true

        contentStackView.spacing = sizeToken.iconGap
        contentStackView.addArrangedSubview(prefixImageView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(suffixImageView)
        addSubview(contentStackView)

        let insets = sizeToken.contentInsets
        let iconSize = sizeToken.iconSize

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: sizeToken.height),

            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.leading),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.trailing),

            prefixImageView.widthAnchor.constraint(equalToConstant: iconSize),
            prefixImageView.heightAnchor.constraint(equalToConstant: iconSize),
            suffixImageView.widthAnchor.constraint(equalToConstant: iconSize),
            suffixImageView.heightAnchor.constraint(equalToConstant: iconSize),
        ])

        updateAppearance()
    }

    // MARK: - Appearance

    private func updateAppearance() {
        let colorToken = ColorToken(variant: variant, isHighlighted: isHighlighted, isEnabled: isEnabled)
        let sizeToken = SizeToken(size: size)

        backgroundColor = colorToken.background

        titleLabel.attributedText = NSAttributedString(
            string: title ?? "",
            attributes: [
                .font: sizeToken.typography.font,
                .kern: sizeToken.typography.letterSpacing,
                .foregroundColor: colorToken.foreground
            ]
        )

        prefixImageView.tintColor = colorToken.foreground
        suffixImageView.tintColor = colorToken.foreground
    }
}

// MARK: - Size Token

private extension MDSActionButton {

    struct SizeToken {
        let height: CGFloat
        let cornerRadius: CGFloat
        let contentInsets: NSDirectionalEdgeInsets
        let iconGap: CGFloat
        let iconSize: CGFloat
        let typography: MDSFont

        init(size: MDSActionButton.Size) {
            switch size {
            case .xsmall:
                height = 32
                cornerRadius = BaseRadius.Base.r16
                contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
                iconGap = 2
                iconSize = 16
                typography = Typography.label4
            case .small:
                height = 36
                cornerRadius = BaseRadius.Base.r8
                contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14)
                iconGap = 4
                iconSize = 16
                typography = Typography.label3
            case .medium:
                height = 46
                cornerRadius = BaseRadius.Base.r10
                contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
                iconGap = 4
                iconSize = 20
                typography = Typography.label2
            case .large:
                height = 56
                cornerRadius = BaseRadius.Base.r12
                contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
                iconGap = 4
                iconSize = 24
                typography = Typography.label1
            }
        }
    }
}

// MARK: - Color Token

private extension MDSActionButton {

    struct ColorToken {
        let background: UIColor
        let foreground: UIColor

        init(variant: MDSActionButton.Variant, isHighlighted: Bool, isEnabled: Bool) {
            guard isEnabled else {
                background = SemanticColor.Bg.Neutral.Default.disabled
                foreground = SemanticColor.Fg.Neutral.Default.disabled
                return
            }
            switch variant {
            case .primary:
                background = isHighlighted
                    ? SemanticColor.Bg.Neutral.Inverse.hover
                    : SemanticColor.Bg.Neutral.inverse
                foreground = SemanticColor.Fg.Neutral.inverse
            case .secondary:
                background = isHighlighted
                    ? SemanticColor.Bg.Neutral.Subtle.hover
                    : SemanticColor.Bg.Neutral.subtle
                foreground = SemanticColor.Fg.Neutral.bold
            case .danger:
                background = isHighlighted
                    ? SemanticColor.Bg.Danger.Default.pressed
                    : SemanticColor.Bg.Danger.default
                foreground = SemanticColor.Fg.Neutral.bold
            }
        }
    }
}
