//
//  MDSUserListMenuItem.swift
//  MDS
//

import UIKit

/// `MDSUserListMenu`의 한 줄. 아바타, 제목, 설명(옵션)을 보여준다.
final class MDSUserListMenuItem: MDSMenuItemControl {

    // MARK: - Properties

    var title: String {
        get { textView.title }
        set { textView.title = newValue }
    }

    var itemDescription: String? {
        get { textView.descriptionText }
        set { textView.descriptionText = newValue }
    }

    var image: UIImage? {
        didSet { avatar.image = image }
    }

    // MARK: - Subviews

    private let avatar: MDSAvatar
    private let textView: MDSMenuTextView

    // MARK: - Init

    init(title: String, description: String?, image: UIImage?) {
        self.textView = MDSMenuTextView(title: title, description: description)
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

        contentStackView.addArrangedSubview(avatar)
        contentStackView.addArrangedSubview(textView)
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
