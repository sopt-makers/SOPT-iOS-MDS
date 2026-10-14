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

    private var dismissWorkItem: DispatchWorkItem?
    private var isDismissing = false

    private let containerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.isLayoutMarginsRelativeArrangement = true
        view.insetsLayoutMarginsFromSafeArea = false
        view.layoutMargins = UIEdgeInsets(
            top: 14,
            left: 16,
            bottom: 14,
            right: 16
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

    private let button: MDSTextButton = {
        let button = MDSTextButton(variant: .emphasis, size: .medium)
        button.titleColor = SemanticColor.Fg.Secondary.default
        return button
    }()

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

        // 아이콘이 숨겨지면 UIStackView가 너비 0 제약을 추가하므로 충돌하지 않도록 우선순위를 낮춥니다.
        let iconWidthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: 20)
        iconWidthConstraint.priority = .required - 1

        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),

            iconWidthConstraint,
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
    private struct Request {
        let snackBar: MDSSnackBar
        weak var view: UIView?
        let duration: TimeInterval
    }

    private static var queue: [Request] = []
    private static weak var current: MDSSnackBar?

    /// `view` 상단에서 스낵바가 내려오고 `duration`초 뒤 다시 올라가며 사라집니다.
    /// 이미 노출 중인 스낵바가 있으면 큐에서 대기하다가 앞의 스낵바가 사라지면 노출됩니다.
    public func show(in view: UIView, duration: TimeInterval = 4) {
        Self.queue.append(Request(snackBar: self, view: view, duration: duration))
        Self.showNextIfNeeded()
    }

    public func dismiss() {
        guard Self.current === self else {
            Self.queue.removeAll { $0.snackBar === self }
            return
        }
        guard !isDismissing else { return }
        isDismissing = true
        dismissWorkItem?.cancel()
        dismissWorkItem = nil

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.transform = self.hiddenTransform
        }, completion: { _ in
            self.removeFromSuperview()
            self.isDismissing = false
            Self.current = nil
            Self.showNextIfNeeded()
        })
    }

    private static func showNextIfNeeded() {
        guard current == nil else { return }

        while !queue.isEmpty {
            let request = queue.removeFirst()
            guard let view = request.view else { continue }
            current = request.snackBar
            request.snackBar.present(in: view, duration: request.duration)
            return
        }
    }

    private func present(in view: UIView, duration: TimeInterval) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
        ])

        view.layoutIfNeeded()
        transform = hiddenTransform
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.transform = .identity
        }

        let workItem = DispatchWorkItem { [weak self] in
            self?.dismiss()
        }
        dismissWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: workItem)
    }

    /// 화면 상단 밖으로 완전히 밀어 올린 위치
    private var hiddenTransform: CGAffineTransform {
        CGAffineTransform(translationX: 0, y: -frame.maxY)
    }
}
