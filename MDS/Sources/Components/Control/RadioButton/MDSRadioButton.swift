//
//  MDSRadioButton.swift
//  MDS
//

import UIKit

public final class MDSRadioButton: UIControl {

    // MARK: - Properties

    public override var isSelected: Bool {
        didSet { updateCircle(colorToken: ColorToken(isEnabled: isEnabled, isSelected: isSelected)) }
    }

    public override var isEnabled: Bool {
        didSet {
            let colorToken = ColorToken(isEnabled: isEnabled, isSelected: isSelected)
            updateCircle(colorToken: colorToken)
            updateLabel(colorToken: colorToken)
        }
    }

    public var labelText: String? {
        didSet { updateLabel(colorToken: ColorToken(isEnabled: isEnabled, isSelected: isSelected)) }
    }

    private let sizeToken: SizeToken

    // MARK: - UI Components

    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.isUserInteractionEnabled = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let circleView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        return view
    }()

    private let dotView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.isUserInteractionEnabled = false
        return label
    }()

    // MARK: - Init

    public init(size: Size = .large, label: String? = nil) {
        self.sizeToken = SizeToken(size: size)
        super.init(frame: .zero)
        self.labelText = label
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        setupHierarchy()
        setupLayout()
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        let colorToken = ColorToken(isEnabled: isEnabled, isSelected: isSelected)
        updateCircle(colorToken: colorToken)
        updateLabel(colorToken: colorToken)
    }

    private func setupHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubview(circleView)
        stackView.addArrangedSubview(titleLabel)
        circleView.addSubview(dotView)
    }

    private func setupLayout() {
        stackView.spacing = sizeToken.gap

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),

            circleView.widthAnchor.constraint(equalToConstant: sizeToken.circleSize),
            circleView.heightAnchor.constraint(equalToConstant: sizeToken.circleSize),

            dotView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            dotView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            dotView.widthAnchor.constraint(equalToConstant: sizeToken.dotSize),
            dotView.heightAnchor.constraint(equalToConstant: sizeToken.dotSize),
        ])

        circleView.layer.cornerRadius = sizeToken.circleSize / 2
        dotView.layer.cornerRadius = sizeToken.dotSize / 2
    }

    @objc private func handleTap() {
        guard !isSelected else { return }
        isSelected = true
        sendActions(for: .valueChanged)
    }

    // MARK: - Appearance

    private func updateCircle(colorToken: ColorToken) {
        circleView.backgroundColor = colorToken.circleFillColor
        circleView.layer.borderColor = colorToken.circleBorderColor.cgColor
        circleView.layer.borderWidth = colorToken.circleBorderWidth
        dotView.backgroundColor = colorToken.dotColor
        dotView.isHidden = !isSelected
    }

    private func updateLabel(colorToken: ColorToken) {
        guard let text = labelText, !text.isEmpty else {
            titleLabel.isHidden = true
            return
        }
        titleLabel.isHidden = false
        titleLabel.text = text
        titleLabel.textColor = colorToken.labelColor
        titleLabel.setTypography(sizeToken.typography)
    }
}

// MARK: - SizeToken

extension MDSRadioButton {
    struct SizeToken {
        let circleSize: CGFloat
        let dotSize: CGFloat
        let gap: CGFloat
        let typography: MDSFont

        init(size: Size) {
            switch size {
            case .small:
                circleSize = 16
                dotSize = 8
                gap = 7
                typography = Typography.label3
            case .large:
                circleSize = 22
                dotSize = 10
                gap = 10
                typography = Typography.label2
            }
        }
    }
}

// MARK: - ColorToken

extension MDSRadioButton {
    struct ColorToken {
        let circleFillColor: UIColor
        let circleBorderColor: UIColor
        let circleBorderWidth: CGFloat
        let dotColor: UIColor
        let labelColor: UIColor

        init(isEnabled: Bool, isSelected: Bool) {
            switch (isEnabled, isSelected) {
            case (true, false):
                circleFillColor = .clear
                circleBorderColor = SemanticColor.Stroke.Neutral.default
                circleBorderWidth = 1
                dotColor = .clear
                labelColor = SemanticColor.Fg.Neutral.bold
            case (true, true):
                circleFillColor = SemanticColor.Fg.Secondary.default
                circleBorderColor = .clear
                circleBorderWidth = 0
                dotColor = SemanticColor.Fg.Neutral.bold
                labelColor = SemanticColor.Fg.Neutral.bold
            case (false, false):
                circleFillColor = .clear
                circleBorderColor = SemanticColor.Stroke.Neutral.Default.disabled
                circleBorderWidth = 1
                dotColor = .clear
                labelColor = SemanticColor.Fg.Neutral.Default.disabled
            case (false, true):
                circleFillColor = SemanticColor.Fg.Neutral.Ghost.disabled
                circleBorderColor = .clear
                circleBorderWidth = 0
                dotColor = SemanticColor.Fg.Neutral.ghost
                labelColor = SemanticColor.Fg.Neutral.Default.disabled
            }
        }
    }
}
