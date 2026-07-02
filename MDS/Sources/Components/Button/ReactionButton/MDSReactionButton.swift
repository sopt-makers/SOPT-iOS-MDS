//
//  MDSReactionButton.swift
//  MDS
//
//  Created by 최주리 on 6/4/26.
//

import UIKit

public final class MDSReactionButton: UIControl {
    
    // MARK: - Properties
    
    public var count: Int? {
        didSet {
            updateAppearance()
        }
    }
    
    public override var isSelected: Bool {
        didSet { updateAppearance() }
    }
    
    public override var isEnabled: Bool {
        didSet { updateAppearance() }
    }
    
    private let size: Size
    private let title: String
    private let icon: UIImage?
    private let trailingIcon: UIImage?
    
    // MARK: - Subviews
    
    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let leadingImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.textAlignment = .center
        return view
    }()
    
    private let countLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.textAlignment = .center
        return view
    }()
    
    private let trailingImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    // MARK: - Init
    
    public init(
        size: Size = .medium,
        icon: UIImage? = nil,
        trailingIcon: UIImage? = nil,
        title: String,
        count: Int? = nil,
        isSelected: Bool = false
    ) {
        self.size = size
        self.icon = icon?.withRenderingMode(.alwaysTemplate)
        self.trailingIcon = trailingIcon?.withRenderingMode(.alwaysTemplate)
        self.title = title
        self.count = count
        
        super.init(frame: .zero)
        
        self.isSelected = isSelected
        
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
        contentStackView.addArrangedSubview(leadingImageView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(countLabel)
        contentStackView.addArrangedSubview(trailingImageView)
    }
    
    private func setupLayout() {
        let sizeToken = SizeToken(size: size)
        let insets = sizeToken.contentInsets
        let iconSize = sizeToken.iconSize
        
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        countLabel.setContentHuggingPriority(.required, for: .horizontal)
        countLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.leading),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.trailing),
            
            leadingImageView.widthAnchor.constraint(equalToConstant: iconSize),
            leadingImageView.heightAnchor.constraint(equalToConstant: iconSize),
            trailingImageView.widthAnchor.constraint(equalToConstant: iconSize),
            trailingImageView.heightAnchor.constraint(equalToConstant: iconSize),
        ])
    }
    
    // MARK: - Appearance
    
    private func updateAppearance() {
        let sizeToken = SizeToken(size: size)
        let colorToken = ColorToken(isSelected: isSelected, isEnabled: isEnabled)
        let textAttributes = sizeToken.typography.attributedStringAttributes(foregroundColor: colorToken.foreground)
        
        contentStackView.spacing = sizeToken.itemGap
        
        leadingImageView.image = icon
        leadingImageView.tintColor = colorToken.foreground
        
        trailingImageView.image = trailingIcon
        trailingImageView.tintColor = colorToken.foreground
        
        titleLabel.attributedText = NSAttributedString(string: title, attributes: textAttributes)
        
        if let icon {
            leadingImageView.isHidden = false
        } else {
            leadingImageView.isHidden = true
        }
        
        if let trailingIcon {
            trailingImageView.isHidden = false
        } else {
            trailingImageView.isHidden = true
        }
        
        if let count {
            countLabel.isHidden = false
            countLabel.attributedText = NSAttributedString(string: "\(count)", attributes: textAttributes)
            accessibilityLabel = "\(title) \(count)"
        } else {
            countLabel.isHidden = true
            accessibilityLabel = title
        }
        
        if size != .xsmall {
            layer.cornerRadius = sizeToken.height / 2
            layer.masksToBounds = true
            layer.borderWidth = 1
            layer.borderColor = colorToken.stroke.cgColor
            backgroundColor = colorToken.background
        } else {
            layer.borderWidth = 0
            backgroundColor = .clear
        }
        
        
    }
}

// MARK: - Size Token

private extension MDSReactionButton {
    
    struct SizeToken {
        let height: CGFloat
        let contentInsets: NSDirectionalEdgeInsets
        let iconSize: CGFloat
        let itemGap: CGFloat
        let typography: MDSFont
        
        init(size: MDSReactionButton.Size) {
            switch size {
            case .xsmall:
                height = 20
                contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4)
                iconSize = 16
                itemGap = 4
                typography = Typography.label4
            case .small:
                height = 32
                contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14)
                iconSize = 16
                itemGap = 4
                typography = Typography.label4
            case .medium:
                height = 38
                contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
                iconSize = 16
                itemGap = 4
                typography = Typography.label3
            case .large:
                height = 54
                contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 24, bottom: 15, trailing: 24)
                iconSize = 24
                itemGap = 6
                typography = Typography.label1
            }
        }
    }
}

// MARK: - Color Token

private extension MDSReactionButton {
    
    struct ColorToken {
        let background: UIColor
        let foreground: UIColor
        let stroke: UIColor
        
        init(isSelected: Bool, isEnabled: Bool) {
            guard isEnabled else {
                background = SemanticColor.Bg.Neutral.Default.disabled
                foreground = SemanticColor.Fg.Neutral.Default.disabled
                stroke = SemanticColor.Stroke.Neutral.Default.disabled
                return
            }
            
            if isSelected {
                background = .clear
                foreground = SemanticColor.Fg.Neutral.bold
                stroke = SemanticColor.Stroke.Neutral.default
            } else {
                background = .clear
                foreground = SemanticColor.Fg.Neutral.default
                stroke = SemanticColor.Stroke.Neutral.default
            }
        }
    }
}
