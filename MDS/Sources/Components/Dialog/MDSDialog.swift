//
//  MDSDialog.swift
//  MDS
//
//  Created by 최주리 on 7/5/26.
//

import UIKit

public final class MDSDialog: UIView {
    
    private let title: String
    private let subTitle: String?
    private let checkBox: MDSCheckbox?
    
    // primary (or danger) button
    public var onPrimaryTap: (() -> Void)?
    // secondary (취소) button
    public var onSecondaryTap: (() -> Void)?
    
    private let variant: Variant
    
    private let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = SemanticColor.Fg.Neutral.bold
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = SemanticColor.Fg.Neutral.default
        label.numberOfLines = 0
        label.textAlignment = .left
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    
    private let buttonStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var primaryButton: MDSActionButton = {
        let button = MDSActionButton(variant: .primary, size: .medium)
        button.addTarget(self, action: #selector(primaryTapped), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var secondaryButton: MDSActionButton = {
        let button = MDSActionButton(variant: .secondary, size: .medium)
        button.addTarget(self, action: #selector(secondaryTapped), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var dangerButton: MDSActionButton = {
        let button = MDSActionButton(variant: .danger, size: .medium)
        button.addTarget(self, action: #selector(primaryTapped), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    public init(
        variant: Variant,
        title: String,
        description: String? = nil,
        checkBoxTitle: String?
    ) {
        self.variant = variant
        self.title = title
        self.subTitle = description
        if let checkBoxTitle {
            self.checkBox = MDSCheckbox(size: .small, title: checkBoxTitle)
        } else {
            self.checkBox = nil
        }

        super.init(frame: .zero)
    
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        layer.cornerRadius = BaseRadius.Base.r14
        layer.masksToBounds = true
        
        backgroundColor = SemanticColor.Bg.Neutral.ghost
        
        titleLabel.text = title
        titleLabel.setTypography(Typography.heading3)
        descriptionLabel.text = subTitle
        descriptionLabel.setTypography(Typography.body2)
        
        switch variant {
        case let .default(primaryTitle, primaryPrefix, primarySuffix, secondaryTitle, secondaryPrefix, secondarySuffix):
            
            primaryButton.title = primaryTitle
            primaryButton.prefixIcon = primaryPrefix
            primaryButton.suffixIcon = primarySuffix
            secondaryButton.title = secondaryTitle
            secondaryButton.prefixIcon = secondaryPrefix
            secondaryButton.suffixIcon = secondarySuffix
            
            primaryButton.isHidden = false
            secondaryButton.isHidden = false
        case let .information(primaryTitle, primaryPrefix, primarySuffix):
            primaryButton.title = primaryTitle
            primaryButton.prefixIcon = primaryPrefix
            primaryButton.suffixIcon = primarySuffix
            
            primaryButton.isHidden = false
        case let .danger(primaryTitle, primaryPrefix, primarySuffix, secondaryTitle, secondaryPrefix, secondarySuffix):
            dangerButton.title = primaryTitle
            dangerButton.prefixIcon = primaryPrefix
            dangerButton.suffixIcon = primarySuffix
            secondaryButton.title = secondaryTitle
            secondaryButton.prefixIcon = secondaryPrefix
            secondaryButton.suffixIcon = secondarySuffix
            
            dangerButton.isHidden = false
            secondaryButton.isHidden = false
        }
    }
    
    private func setLayout() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)

        if subTitle != nil {
            stackView.addArrangedSubview(descriptionLabel)
            stackView.setCustomSpacing(8, after: titleLabel)
        }

        if let checkBox {
            stackView.setCustomSpacing(24, after: subTitle != nil ? descriptionLabel : titleLabel)
            stackView.addArrangedSubview(checkBox)
        }
        
        stackView.addArrangedSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(secondaryButton)
        buttonStackView.addArrangedSubview(primaryButton)
        buttonStackView.addArrangedSubview(dangerButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func primaryTapped() {
        onPrimaryTap?()
    }
    
    @objc private func secondaryTapped() {
        onSecondaryTap?()
    }
}
