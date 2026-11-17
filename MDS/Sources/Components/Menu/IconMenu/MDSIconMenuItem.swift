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

    /// 제목 한 줄 높이의 영역. 아이콘이 설명까지 포함한 두 줄 전체가 아니라 제목 줄의 가운데에 놓이게 한다.
    private let iconContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let textStackView: MDSMenuTextStackView

    // MARK: - Init

    init(title: String, description: String? = nil, icon: MDSIcon?) {
        self.textStackView = MDSMenuTextStackView(title: title, description: description)
        self.icon = icon
        super.init(spacing: LayoutToken.contentSpacing, insets: LayoutToken.contentInsets)
        setupContent()
    }

    // MARK: - Setup

    private func setupContent() {
        // 아이콘과 제목은 제목 줄 기준으로 위쪽에 맞춘다.
        contentStackView.alignment = .top

        iconContainerView.addSubview(iconImageView)
        contentStackView.addArrangedSubview(iconContainerView)
        contentStackView.addArrangedSubview(textStackView)

        // 아이콘이 숨겨지면 UIStackView가 너비 0 제약을 추가하므로 충돌하지 않도록 우선순위를 낮춘다.
        let iconWidthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: LayoutToken.iconSize)
        iconWidthConstraint.priority = .required - 1

        NSLayoutConstraint.activate([
            iconWidthConstraint,
            iconImageView.heightAnchor.constraint(equalToConstant: LayoutToken.iconSize),

            iconContainerView.heightAnchor.constraint(equalToConstant: MDSMenuTextStackView.titleLineHeight),
            iconContainerView.widthAnchor.constraint(equalTo: iconImageView.widthAnchor),

            iconImageView.leadingAnchor.constraint(equalTo: iconContainerView.leadingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
        ])

        updateIcon()
    }

    // MARK: - Content

    private func updateIcon() {
        iconImageView.setIcon(icon, tintColor: SemanticColor.Fg.Neutral.bold)
        iconContainerView.isHidden = icon == nil
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
