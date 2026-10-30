//
//  MDSIconMenuItem.swift
//  MDS
//

import UIKit

/// `MDSIconMenu`의 한 줄. 모바일에는 hover가 없어서 누르고 있는 동안(`isHighlighted`)을 Hover로 표현한다.
final class MDSIconMenuItem: UIControl {

    // MARK: - Properties

    override var isHighlighted: Bool {
        didSet { updateAppearance() }
    }

    var title: String {
        didSet { updateAppearance() }
    }

    var icon: MDSIcon? {
        didSet { updateAppearance() }
    }

    // MARK: - Subviews

    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = LayoutToken.contentSpacing
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = LayoutToken.contentInsets
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    // MARK: - Init

    init(title: String, icon: MDSIcon?) {
        self.title = title
        self.icon = icon
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

        addSubview(contentStackView)
        contentStackView.addArrangedSubview(iconImageView)
        contentStackView.addArrangedSubview(titleLabel)

        // 아이콘이 숨겨지면 UIStackView가 너비 0 제약을 추가하므로 충돌하지 않도록 우선순위를 낮춘다.
        let iconWidthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: LayoutToken.iconSize)
        iconWidthConstraint.priority = .required - 1

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),

            widthAnchor.constraint(greaterThanOrEqualToConstant: LayoutToken.minWidth),

            iconWidthConstraint,
            iconImageView.heightAnchor.constraint(equalToConstant: LayoutToken.iconSize),
        ])

        updateAppearance()
    }

    // MARK: - Appearance

    private func updateAppearance() {
        backgroundColor = isHighlighted ? SemanticColor.Bg.Neutral.Ghost.hover : .clear

        titleLabel.text = title
        titleLabel.setTypography(Typography.label2, textColor: SemanticColor.Fg.Neutral.bold)
        iconImageView.setIcon(icon, tintColor: SemanticColor.Fg.Neutral.bold)
    }
}

// MARK: - Layout Token

private extension MDSIconMenuItem {

    enum LayoutToken {
        static let minWidth: CGFloat = 80
        static let iconSize: CGFloat = 16
        static let contentSpacing = BaseSpacing.Base.s8
        static let contentInsets = UIEdgeInsets(
            top: BaseSpacing.Base.s8,
            left: BaseSpacing.Base.s10,
            bottom: BaseSpacing.Base.s8,
            right: BaseSpacing.Base.s12
        )
    }
}
