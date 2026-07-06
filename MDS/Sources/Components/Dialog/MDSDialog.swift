//
//  MDSDialog.swift
//  MDS
//
//  Created by 최주리 on 7/5/26.
//

import UIKit

public final class MDSDialog: UIView {
    
    public var title: String
    public var subTitle: String
    
    // primary (or danger) button
    public var onPrimaryTap: (() -> Void)?
    // disable button
    public var onSecondaryTap: (() -> Void)?
    
    private let variant: Variant
    private let hasCheckbox: Bool
    
    private let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = Typography.heading3.font
        label.textColor = SemanticColor.Fg.Neutral.bold
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.body2.font
        label.textColor = SemanticColor.Fg.Neutral.default
        label.numberOfLines = 0
        label.textAlignment = .left
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    
    public var checkBox: MDSCheckbox = {
        let checkbox = MDSCheckbox(size: .small)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        return checkbox
    }()
    
    private let buttonStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 9
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
    
    private let disableButton: MDSActionButton = {
        let button = MDSActionButton(variant: .secondary, size: .medium)
        button.addTarget(self, action: #selector(secondaryTapped), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let dangerButton: MDSActionButton = {
        let button = MDSActionButton(variant: .danger, size: .medium)
        button.addTarget(self, action: #selector(primaryTapped), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    public init(
        variant: Variant,
        title: String,
        subTitle: String,
        hasCheckbox: Bool
    ) {
        self.variant = variant
        self.title = title
        self.subTitle = subTitle
        self.hasCheckbox = hasCheckbox
        
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
        descriptionLabel.text = subTitle
        
        switch variant {
        case .default(let primaryButtonTitle, let disableButtonTitle):
            primaryButton.title = primaryButtonTitle
            disableButton.title = disableButtonTitle
            
            primaryButton.isHidden = false
            disableButton.isHidden = false
        case .information(let primaryButtonTitle):
            primaryButton.title = primaryButtonTitle
            
            primaryButton.isHidden = false
        case .danger(let primaryButtonTitle, let disableButtonTitle):
            dangerButton.title = primaryButtonTitle
            disableButton.title = disableButtonTitle
            
            dangerButton.isHidden = false
            disableButton.isHidden = false
        }
    }
    
    private func setLayout() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.setCustomSpacing(8, after: titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        if hasCheckbox {
            stackView.setCustomSpacing(24, after: descriptionLabel)
            stackView.addArrangedSubview(checkBox)
        }
        
        stackView.addArrangedSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(disableButton)
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
