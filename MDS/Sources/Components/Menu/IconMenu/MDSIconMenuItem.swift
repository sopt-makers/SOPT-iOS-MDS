//
//  MDSIconMenuItem.swift
//  MDS
//

import UIKit

/// `MDSIconMenu`의 한 줄. 아이콘과 제목(설명은 옵션)을 보여준다.
final class MDSIconMenuItem: MDSMenuItemControl {

    // MARK: - Properties

    var icon: MDSIcon? {
        didSet { updateIcon() }
    }

    // MARK: - Subviews

    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let textView: MDSMenuTextView

    // MARK: - Init

    init(title: String, description: String? = nil, icon: MDSIcon?) {
        self.textView = MDSMenuTextView(title: title, description: description)
        self.icon = icon
        super.init(spacing: LayoutToken.contentSpacing, insets: LayoutToken.contentInsets)
        setupContent()
    }

    // MARK: - Setup

    private func setupContent() {
        contentStackView.addArrangedSubview(iconImageView)
        contentStackView.addArrangedSubview(textView)

        // 아이콘이 숨겨지면 UIStackView가 너비 0 제약을 추가하므로 충돌하지 않도록 우선순위를 낮춘다.
        let iconWidthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: LayoutToken.iconSize)
        iconWidthConstraint.priority = .required - 1

        NSLayoutConstraint.activate([
            iconWidthConstraint,
            iconImageView.heightAnchor.constraint(equalToConstant: LayoutToken.iconSize),
        ])

        updateIcon()
    }

    // MARK: - Content

    private func updateIcon() {
        iconImageView.setIcon(icon, tintColor: SemanticColor.Fg.Neutral.bold)
    }
}

// MARK: - Layout Token

private extension MDSIconMenuItem {

    enum LayoutToken {
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
