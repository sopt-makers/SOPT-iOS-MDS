//
//  MDSToggle.swift
//  MDS
//
//  Created by 최주리 on 6/14/26.
//

import UIKit

public final class MDSToggle: UIControl {

    // MARK: - Properties

    public var isOn: Bool = false {
        didSet {
            updateThumbPosition(animated: true)
            updateColors()
        }
    }

    public override var isEnabled: Bool {
        didSet {
            updateColors()
        }
    }

    private let toggleSize: Size
    private var thumbLeadingConstraint: NSLayoutConstraint?

    // MARK: - UI Components

    private let trackView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        return view
    }()

    private let thumbView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = BaseRadius.Base.r2
        return view
    }()

    // MARK: - Init

    public init(size: Size = .large) {
        self.toggleSize = size
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        setupHierarchy()
        setupLayout()
        setupAction()
        updateThumbPosition(animated: true)
        updateColors()
    }

    private func setupHierarchy() {
        addSubview(trackView)
        trackView.addSubview(thumbView)
    }

    private func setupLayout() {
        let sizeToken = SizeToken(size: toggleSize)
        
        trackView.translatesAutoresizingMaskIntoConstraints = false
        thumbView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            trackView.topAnchor.constraint(equalTo: topAnchor),
            trackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            trackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            trackView.widthAnchor.constraint(equalToConstant: sizeToken.width),
            trackView.heightAnchor.constraint(equalToConstant: sizeToken.height),

            thumbView.centerYAnchor.constraint(equalTo: trackView.centerYAnchor),
            thumbView.widthAnchor.constraint(equalToConstant: sizeToken.thumbSize),
            thumbView.heightAnchor.constraint(equalToConstant: sizeToken.thumbSize)
        ])
        
        thumbLeadingConstraint = thumbView.leadingAnchor.constraint(equalTo: trackView.leadingAnchor, constant: 2)
        thumbLeadingConstraint?.isActive = true

        trackView.layer.cornerRadius = sizeToken.height / 2
        thumbView.layer.cornerRadius = sizeToken.thumbSize / 2
    }

    private func setupAction() {
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }

    @objc private func handleTap() {
        isOn.toggle()
    }

    // MARK: - Appearance
    
    private func updateColors() {
        let colorToken = ColorToken(isEnabled: isEnabled, isSelected: isOn)
        trackView.backgroundColor = colorToken.trackColor
        thumbView.backgroundColor = colorToken.thumbColor
    }
    
    private func updateThumbPosition(animated: Bool) {
        let sizeToken = SizeToken(size: toggleSize)
        let constant: CGFloat = isOn ? (sizeToken.width - sizeToken.thumbSize - BaseSpacing.Base.s2) : BaseSpacing.Base.s2

        guard animated, window != nil else {
            thumbLeadingConstraint?.constant = constant
            return
        }

        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.thumbLeadingConstraint?.constant = constant
            self?.trackView.layoutIfNeeded()
        }
    }
}

extension MDSToggle {
    struct SizeToken {
        let width: CGFloat
        let height: CGFloat
        let thumbSize: CGFloat
        
        init(size: Size) {
            switch size {
            case .small:
                width = 26
                height = 16
                thumbSize = 12
            case .large:
                width = 36
                height = 20
                thumbSize = 16
            }
        }
    }
    
    struct ColorToken {
        let trackColor: UIColor
        let thumbColor: UIColor
        
        init(isEnabled: Bool, isSelected: Bool) {
            switch (isEnabled, isSelected) {
            case (true, true):
                trackColor = SemanticColor.Fg.Secondary.default
                thumbColor = SemanticColor.Fg.Neutral.bold
            case (true, false):
                trackColor = SemanticColor.Fg.Neutral.ghost
                thumbColor = SemanticColor.Fg.Neutral.bold
            case (false, true):
                trackColor = SemanticColor.Fg.Neutral.Ghost.disabled
                thumbColor = SemanticColor.Fg.Neutral.Default.disabled
            case (false, false):
                trackColor = SemanticColor.Fg.Neutral.Ghost.disabled
                thumbColor = SemanticColor.Fg.Neutral.Default.disabled
            }
        }
    }
}
