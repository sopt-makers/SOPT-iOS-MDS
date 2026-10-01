//
//  MDSSnackBar.swift
//  MDS
//
//  Created by 최주리 on 10/1/26.
//

import UIKit

public final class MDSSnackBar: UIView {
    public var style: Style {
        didSet { updateAppearance() }
    }

    public var text: String {
        didSet { updateAppearance() }
    }

    public var buttonTitle: String? {
        didSet { updateAppearance() }
    }

    public var onButtonTap: (() -> Void)?

    private let containerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(
            top: BaseSpacing.Base.s14,
            left: BaseSpacing.Base.s16,
            bottom: BaseSpacing.Base.s14,
            right: BaseSpacing.Base.s16
        )
        view.backgroundColor = SemanticColor.Bg.Neutral.inverse
        view.layer.cornerRadius = BaseRadius.Base.r14
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let labelStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        view.alignment = .center
        return view
    }()

    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.isHidden = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()

    private let button = MDSTextButton(variant: .emphasis, size: .medium)

    public init(
        style: Style = .default,
        text: String,
        buttonTitle: String? = nil,
        onButtonTap: (() -> Void)? = nil
    ) {
        self.style = style
        self.text = text
        self.buttonTitle = buttonTitle
        self.onButtonTap = onButtonTap
        super.init(frame: .zero)

        setupLayout()
        updateAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MDSSnackBar {
    private func setupLayout() {
        addSubview(containerStackView)

        labelStackView.addArrangedSubview(iconImageView)
        labelStackView.addArrangedSubview(label)
        containerStackView.addArrangedSubview(labelStackView)
        containerStackView.addArrangedSubview(button)

        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),

            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
        ])
    }

    private func updateAppearance() {
        label.text = text
        label.setTypography(Typography.label3, textColor: SemanticColor.Fg.Neutral.inverse)

        let token = IconToken(style: style)
        iconImageView.setIcon(token.icon, tintColor: token.color)

        button.isHidden = buttonTitle == nil
        button.title = buttonTitle ?? ""
    }

    @objc private func buttonTapped() {
        onButtonTap?()
    }
}

// MARK: - Presentation

extension MDSSnackBar {
    // TODO: - 정책 확정 후 반영
    /// `view`의 safe area 상단에 스낵바를 띄우고 `duration`초 뒤 자동으로 내립니다.
    /// ponytail: 큐 없음. 이미 떠 있는 스낵바는 즉시 교체됩니다. 순차 노출이 필요해지면 큐 추가.
    public func show(in view: UIView, duration: TimeInterval = 5) {
        view.subviews.filter { $0 is MDSSnackBar }.forEach { $0.removeFromSuperview() }

        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: BaseSpacing.Base.s16),
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])

        alpha = 0
        transform = CGAffineTransform(translationX: 0, y: -16)
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
            self.transform = .identity
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.dismiss()
        }
    }

    public func dismiss() {
        guard superview != nil else { return }
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(translationX: 0, y: -16)
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}
