//
//  MDSTextButton.swift
//  MDS
//
//  Created by 최주리 on 6/3/26.
//

import UIKit

public final class MDSTextButton: UIControl {
    
    // MARK: - Properties
    
    public override var isEnabled: Bool {
        didSet { updateAppearance() }
    }
    
    public override var isHighlighted: Bool {
        didSet { updateAppearance() }
    }
    
    private let variant: Variant
    private let size: Size
    private let title: String
    
    // MARK: - Subviews
    
    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 0
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let textLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.textAlignment = .center
        return view
    }()
    
    private let chevronImageView: UIImageView = {
        let view = UIImageView()
        view.image = MDSIcon.chevronRightOutlined.image.withRenderingMode(.alwaysTemplate)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init
    
    public init(
        variant: Variant = .default,
        size: Size = .medium,
        title: String
    ) {
        self.variant = variant
        self.size = size
        self.title = title
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Setup
    
    private func setup() {
        setupHierarchy()
        setupLayout()
        updateAppearance()
    }
    
    private func setupHierarchy() {
        addSubview(contentStackView)
        contentStackView.addArrangedSubview(textLabel)
        contentStackView.addArrangedSubview(chevronImageView)
    }
    
    private func setupLayout() {
        let sizeToken = SizeToken(size: size)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            chevronImageView.widthAnchor.constraint(equalToConstant: sizeToken.iconSize),
            chevronImageView.heightAnchor.constraint(equalToConstant: sizeToken.iconSize),
        ])
    }
    
    // MARK: - Appearance
    
    private func updateAppearance() {
        backgroundColor = .clear
        
        let sizeToken = SizeToken(size: size)
        let colorToken = ColorToken(
            variant: variant,
            isEnabled: isEnabled,
            isHighlighted: isHighlighted
        )
        
        textLabel.attributedText = NSAttributedString(
            string: title,
            attributes: sizeToken.typography.attributedStringAttributes(
                foregroundColor: colorToken.foreground,
                alignment: .center
            )
        )
        chevronImageView.tintColor = colorToken.foreground
    }
}

// MARK: - Size Token

private extension MDSTextButton {
    
    struct SizeToken {
        let iconSize: CGFloat
        let typography: MDSFont
        
        init(size: MDSTextButton.Size) {
            switch size {
            case .small:
                iconSize = 16
                typography = Typography.label4
            case .medium:
                iconSize = 18
                typography = Typography.label3
            }
        }
    }
}

// MARK: - Color Token

private extension MDSTextButton {
    
    struct ColorToken {
        let foreground: UIColor
        
        init(variant: MDSTextButton.Variant, isEnabled: Bool, isHighlighted: Bool) {
            guard isEnabled else {
                foreground = SemanticColor.Fg.Neutral.Default.disabled
                return
            }
            
            if isHighlighted {
                foreground = SemanticColor.Fg.Neutral.default
                return
            }
            
            switch variant {
            case .emphasis:
                foreground = SemanticColor.Fg.Neutral.bold
            case .default:
                foreground = SemanticColor.Fg.Neutral.default
            }
        }
    }
}
