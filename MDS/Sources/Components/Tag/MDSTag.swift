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
        icon: UIImage? = nil
    ) {
        super.init(frame: .zero)
        setupViews()
        apply(text: text, size: size, shape: shape, variant: variant, style: style, icon: icon)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupViews() {
        addSubview(stackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(label)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    // MARK: - Apply

    private func apply(
        text: String,
        size: Size,
        shape: Shape,
        variant: Variant,
        style: Style,
        icon: UIImage?
    ) {
        let sizeToken = SizeToken(size: size, shape: shape)
        let colorToken = ColorToken(variant: variant, style: style)

        heightAnchor.constraint(equalToConstant: sizeToken.height).isActive = true

        stackView.layoutMargins = UIEdgeInsets(
            top: 0,
            left: sizeToken.horizontalPadding,
            bottom: 0,
            right: sizeToken.horizontalPadding
        )
        stackView.spacing = sizeToken.gap

        layer.cornerRadius = shape == .pill ? sizeToken.height / 2 : 4
        layer.masksToBounds = true

        backgroundColor = colorToken.background
        label.textColor = colorToken.foreground
        label.text = text
        label.setTypography(sizeToken.font)

        applyIcon(icon, size: sizeToken.iconSize, tintColor: colorToken.foreground)
    }

    private func applyIcon(_ icon: UIImage?, size: CGFloat, tintColor: UIColor) {
        guard let icon else {
            iconImageView.isHidden = true
            return
        }

        iconImageView.isHidden = false
        iconImageView.image = icon.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = tintColor

        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: size),
            iconImageView.heightAnchor.constraint(equalToConstant: size)
        ])
    }
}

// MARK: - Size Token

private extension MDSTag {

    struct SizeToken {
        let height: CGFloat
        let horizontalPadding: CGFloat
        let iconSize: CGFloat
        let gap: CGFloat
        let font: MDSFont

        init(size: MDSTag.Size, shape: MDSTag.Shape) {
            let isPill = shape == .pill
            switch size {
            case .small:
                height = 22
                horizontalPadding = isPill ? 8 : 6
                iconSize = 14
                gap = 2
                font = Typography.label4
            case .medium:
                height = 24
                horizontalPadding = isPill ? 8 : 6
                iconSize = 16
                gap = 2
                font = Typography.label3
            case .large:
                height = 28
                horizontalPadding = isPill ? 8 : 6
                iconSize = 18
                gap = 4
                font = Typography.label2
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
