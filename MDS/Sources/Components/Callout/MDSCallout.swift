//
//  MDSCallout.swift
//  MDS
//
//  Created by 최주리 on 5/20/26.
//

import UIKit

public final class MDSCallout: UIView {
    public var onButtonTap: (() -> Void)?

    private let containerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        view.alignment = .top
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 14, left: 18, bottom: 14, right: 14)
        view.layer.cornerRadius = BaseRadius.Base.r10
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = BaseSpacing.Base.s16
        view.alignment = .leading
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.setTypography(Typography.body2, textColor: SemanticColor.Fg.Neutral.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.isHidden = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var textButton: MDSTextButton?

    public init(
        style: Style,
        text: String,
        icon: MDSIcon?,
        buttonTitle: String?,
        buttonIcon: MDSIcon? = .chevronRightOutlined,
        onButtonTap: (() -> Void)? = nil
    ) {
        super.init(frame: .zero)
        
        setupLayout()
        apply(style: style, text: text, icon: icon, buttonTitle: buttonTitle, buttonIcon: buttonIcon)
        self.onButtonTap = onButtonTap
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MDSCallout {
    private func setupLayout() {
        addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(iconImageView)
        containerStackView.addArrangedSubview(contentStackView)
        
        contentStackView.addArrangedSubview(label)

        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),

            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    private func apply(
        style: Style,
        text: String,
        icon: MDSIcon?,
        buttonTitle: String?,
        buttonIcon: MDSIcon?
    ) {
        let colorToken = ColorToken(style: style)
        label.text = text
        label.setTypography(Typography.body2)

        containerStackView.backgroundColor = colorToken.background
        containerStackView.layer.borderColor = colorToken.stroke.cgColor
        
        iconImageView.setIcon(icon, tintColor: colorToken.foreground)
        
        textButton?.removeFromSuperview()
        textButton = nil

        if let buttonTitle {
            let button = MDSTextButton(
                variant: .emphasis,
                size: .small,
                title: buttonTitle,
                icon: buttonIcon
            )
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            contentStackView.addArrangedSubview(button)
            textButton = button
        }
    }

    @objc private func buttonTapped() {
        onButtonTap?()
    }
}

extension MDSCallout {
    struct ColorToken {
        let background: UIColor
        let stroke: UIColor
        let foreground: UIColor
        
        init(style: Style) {
            switch style {
            case .danger:
                background = SemanticColor.Bg.Danger.ghost
                stroke = SemanticColor.Stroke.Danger.default
                foreground = SemanticColor.Fg.Danger.default
            case .information:
                background = SemanticColor.Bg.Information.ghost
                stroke = SemanticColor.Stroke.Information.subtle
                foreground = SemanticColor.Fg.Information.default
            }
        }
    }
}
