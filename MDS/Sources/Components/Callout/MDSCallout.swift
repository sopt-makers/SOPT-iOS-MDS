//
//  MDSCallout.swift
//  MDS
//
//  Created by 최주리 on 5/20/26.
//

import UIKit

public final class MDSCallout: UIView {
    private let containerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        view.alignment = .top
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 14, left: 18, bottom: 14, right: 14)
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.alignment = .leading
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Typography.body2.font
        label.textColor = SemanticColor.Fg.Neutral.bold
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
    
    // TODO: button MDSButton으로 변경
    
    private let textButton: UIButton = {
        let view = UIButton()
        view.isHidden = true
        view.contentHorizontalAlignment = .leading
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
     
    public init(
        style: Style,
        text: String,
        icon: MDSIcon?,
        buttonTitle: String?
    ) {
        super.init(frame: .zero)

        setupLayout()
        apply(style: style, text: text, icon: icon, buttonTitle: buttonTitle)
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
        contentStackView.addArrangedSubview(textButton)
        
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
        buttonTitle: String?
    ) {
        let colorToken = ColorToken(style: style)
        label.text = text
        label.setTypography(Typography.body2)

        containerStackView.backgroundColor = colorToken.background
        containerStackView.layer.borderColor = colorToken.stroke.cgColor
        
        if let icon {
            iconImageView.isHidden = false
            iconImageView.tintColor = colorToken.foreground
            iconImageView.image = icon.image.withRenderingMode(.alwaysTemplate)
        } else {
            iconImageView.isHidden = true
            iconImageView.image = nil
        }
        
        if let buttonTitle {
            var config = UIButton.Configuration.plain()
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            config.attributedTitle = AttributedString(
                NSAttributedString(
                    string: buttonTitle,
                    attributes: Typography.label4.attributedStringAttributes(foregroundColor: SemanticColor.Fg.Neutral.bold)
                )
            )
            config.image = MDSIcon.chevronRightOutlined.image
                .resize(to: CGSize(width: 16, height: 16))
                .withRenderingMode(.alwaysTemplate)
            config.imagePlacement = .trailing
            config.imagePadding = 0
            config.baseForegroundColor = SemanticColor.Fg.Neutral.bold
            textButton.configuration = config
            textButton.isHidden = false
        } else {
            textButton.isHidden = true
            textButton.configuration = nil
        }
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

extension UIImage {
    func resize(to size: CGSize) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
