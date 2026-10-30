//
//  MDSCheckboxMenuItem.swift
//  MDS
//

import UIKit

/// `MDSCheckboxMenu`의 한 줄. 행 전체가 터치 영역이고, 안의 `MDSCheckbox`는 모양만 그린다.
/// 모바일에는 hover가 없어서 누르고 있는 동안(`isHighlighted`)을 Hover로 표현한다.
final class MDSCheckboxMenuItem: UIControl {

    // MARK: - Properties

    override var isHighlighted: Bool {
        didSet { updateAppearance() }
    }

    var title: String {
        didSet { checkbox.title = title }
    }

    var isChecked: Bool {
        didSet { checkbox.isSelected = isChecked }
    }

    // MARK: - Subviews

    private let checkbox: MDSCheckbox = {
        let checkbox = MDSCheckbox(size: .large)
        // 터치는 행 전체가 받고, 체크 토글은 컨테이너가 처리한다.
        checkbox.isUserInteractionEnabled = false
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        return checkbox
    }()

    // MARK: - Init

    init(title: String, isChecked: Bool) {
        self.title = title
        self.isChecked = isChecked
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        layer.cornerRadius = BaseRadius.Base.r8
        clipsToBounds = true

        addSubview(checkbox)
        checkbox.title = title
        checkbox.isSelected = isChecked

        // 높이는 기본 40(터치 영역)이고, 내용이 더 크면 커진다.
        let heightConstraint = heightAnchor.constraint(equalToConstant: LayoutToken.minHeight)
        heightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            checkbox.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LayoutToken.leadingInset),
            checkbox.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -LayoutToken.trailingInset),
            checkbox.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkbox.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: LayoutToken.verticalInset),
            checkbox.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -LayoutToken.verticalInset),

            heightAnchor.constraint(greaterThanOrEqualToConstant: LayoutToken.minHeight),
            heightConstraint,
        ])

        updateAppearance()
    }

    // MARK: - Appearance

    private func updateAppearance() {
        backgroundColor = isHighlighted ? SemanticColor.Bg.Neutral.Ghost.hover : .clear
    }
}

// MARK: - Layout Token

private extension MDSCheckboxMenuItem {

    enum LayoutToken {
        static let minHeight: CGFloat = 40
        static let leadingInset = BaseSpacing.Base.s8
        static let trailingInset = BaseSpacing.Base.s12
        static let verticalInset = BaseSpacing.Base.s8
    }
}
