//
//  MDSUserListMenuItem.swift
//  MDS
//

import UIKit

/// `MDSUserListMenu`의 한 줄. 아바타, 제목, 설명(옵션)을 보여준다.
final class MDSUserListMenuItem: MDSMenuItemControl {

    // MARK: - Properties

    var title: String {
        didSet { updateContent() }
    }

    var itemDescription: String? {
        didSet { updateContent() }
    }

    var image: UIImage? {
        didSet { avatar.image = image }
    }

    // MARK: - Subviews

    private let avatar: MDSAvatar

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
        super.init(spacing: LayoutToken.contentSpacing, insets: LayoutToken.contentInsets)
        setupContent()
    }

    // MARK: - Setup

    private func setupContent() {
        avatar.isUserInteractionEnabled = false

        // 텍스트가 길어도 아바타는 줄어들거나 늘어나지 않고, 텍스트가 먼저 줄어들도록 우선순위를 둔다.
        avatar.setContentHuggingPriority(.required, for: .horizontal)
        avatar.setContentCompressionResistancePriority(.required, for: .horizontal)
        textStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        contentStackView.addArrangedSubview(avatar)
        contentStackView.addArrangedSubview(textStackView)
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(descriptionLabel)

        updateContent()
    }

    // MARK: - Content

    private func updateContent() {
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
