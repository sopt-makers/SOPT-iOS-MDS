//
//  MDSTag.swift
//  MDS
//
//  Created by yungu0010 on 5/18/26.
//

import UIKit

public final class MDSTag: UIView {

    // MARK: - Private Views

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    // MARK: - Init

    public init(
        text: String,
        size: Size,
        shape: Shape,
        variant: Variant,
        style: Style,
        icon: MDSIcon? = nil
    ) {
        super.init(frame: .zero)
        setupViews(iconSize: SizeToken(size: size).iconSize)
        apply(text: text, size: size, shape: shape, variant: variant, style: style, icon: icon)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupViews(iconSize: CGFloat) {
        addSubview(stackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(label)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),

            iconImageView.widthAnchor.constraint(equalToConstant: iconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: iconSize)
        ])
    }

    // MARK: - Apply

    private func apply(
        text: String,
        size: Size,
        shape: Shape,
        variant: Variant,
        style: Style,
        icon: MDSIcon?
    ) {
        let sizeToken = SizeToken(size: size)
        let colorToken = ColorToken(variant: variant, style: style)

        heightAnchor.constraint(equalToConstant: sizeToken.height).isActive = true

        stackView.layoutMargins = UIEdgeInsets(
            top: sizeToken.verticalPadding,
            left: sizeToken.horizontalPadding,
            bottom: sizeToken.verticalPadding,
            right: sizeToken.horizontalPadding
        )
        stackView.spacing = sizeToken.gap

        layer.cornerRadius = shape == .pill ? sizeToken.height / 2 : BaseRadius.Base.r4
        layer.masksToBounds = true

        backgroundColor = colorToken.background
        label.text = text
        label.setTypography(sizeToken.font, textColor: colorToken.foreground)

        iconImageView.setIcon(icon, tintColor: colorToken.foreground)
    }
}

// MARK: - Size Token

private extension MDSTag {

    struct SizeToken {
        let height: CGFloat
        let horizontalPadding: CGFloat
        let verticalPadding: CGFloat
        let iconSize: CGFloat
        let gap: CGFloat
        let font: MDSFont

        init(size: MDSTag.Size) {
            horizontalPadding = BaseSpacing.Base.s8
            verticalPadding = BaseSpacing.Base.s4
            gap = BaseSpacing.Base.s4

            switch size {
            case .small:
                height = 24
                iconSize = 12
                font = Typography.label4
            case .medium:
                height = 26
                iconSize = 14
                font = Typography.label3
            }
        }
    }
}

// MARK: - Color Token

private extension MDSTag {

    struct ColorToken {
        let background: UIColor
        let foreground: UIColor

        init(variant: MDSTag.Variant, style: MDSTag.Style) {
            switch (variant, style) {
            case (.default, .solid):
                background = SemanticColor.Bg.Neutral.subtle
                foreground = SemanticColor.Fg.Neutral.bold
            case (.default, .subtle):
                background = SemanticColor.Bg.Neutral.subtle
                foreground = SemanticColor.Fg.Neutral.subtle
            case (.primary, .solid):
                background = SemanticColor.Bg.Brand.default
                foreground = SemanticColor.Fg.Neutral.inverse
            case (.primary, .subtle):
                background = SemanticColor.Bg.Brand.ghost
                foreground = SemanticColor.Fg.Brand.default
            case (.secondary, .solid):
                background = SemanticColor.Bg.Secondary.default
                foreground = SemanticColor.Fg.Neutral.bold
            case (.secondary, .subtle):
                background = SemanticColor.Bg.Secondary.subtle
                foreground = SemanticColor.Fg.Secondary.default
            }
        }
    }
}
