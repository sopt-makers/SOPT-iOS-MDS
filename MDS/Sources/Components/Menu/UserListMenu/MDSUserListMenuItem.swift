//
//  MDSUserListMenuItem.swift
//  MDS
//

import UIKit

/// `MDSUserListMenu`의 한 줄. 모바일에는 hover가 없어서 누르고 있는 동안(`isHighlighted`)을 Hover로 표현한다.
final class MDSUserListMenuItem: UIControl {

    // MARK: - Properties

    override var isHighlighted: Bool {
        didSet { updateAppearance() }
    }

    var title: String {
        didSet { updateAppearance() }
    }

    var itemDescription: String? {
        didSet { updateAppearance() }
    }

    var image: UIImage? {
        didSet { avatar.image = image }
    }

    // MARK: - Subviews

    private let avatar: MDSAvatar

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

    private let textStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    // MARK: - Init

    init(title: String, description: String?, image: UIImage?) {
        self.title = title
        self.itemDescription = description
        self.image = image
        self.avatar = MDSAvatar(size: LayoutToken.avatarSize, variant: .subtle, image: image)
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

        avatar.isUserInteractionEnabled = false

        addSubview(contentStackView)
        contentStackView.addArrangedSubview(avatar)
        contentStackView.addArrangedSubview(textStackView)
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),

            widthAnchor.constraint(greaterThanOrEqualToConstant: LayoutToken.minWidth),
        ])

        updateAppearance()
    }

    // MARK: - Appearance

    private func updateAppearance() {
        backgroundColor = isHighlighted ? SemanticColor.Bg.Neutral.Ghost.hover : .clear

        titleLabel.text = title
        titleLabel.setTypography(Typography.label2, textColor: SemanticColor.Fg.Neutral.bold)

        let hasDescription = !(itemDescription ?? "").isEmpty
        descriptionLabel.isHidden = !hasDescription
        if hasDescription {
            descriptionLabel.text = itemDescription
            descriptionLabel.setTypography(Typography.label3, textColor: SemanticColor.Fg.Neutral.subtle)
        }
    }
}

// MARK: - Layout Token

private extension MDSUserListMenuItem {

    enum LayoutToken {
        static let minWidth: CGFloat = 80
        static let avatarSize: CGFloat = 32
        static let contentSpacing = BaseSpacing.Base.s12
        static let contentInsets = UIEdgeInsets(
            top: BaseSpacing.Base.s8,
            left: BaseSpacing.Base.s8,
            bottom: BaseSpacing.Base.s8,
            right: BaseSpacing.Base.s12
        )
    }
}
