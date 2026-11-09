//
//  MDSTextMenuItem.swift
//  MDS
//

import UIKit

/// `MDSTextMenu`의 한 줄. 제목, 설명(옵션), 체크 아이콘을 보여준다. 선택(`isSelected`)되면 체크가 보인다.
final class MDSTextMenuItem: MDSMenuItemControl {

    // MARK: - Properties

    override var isSelected: Bool {
        didSet { updateCheck() }
    }

    // MARK: - Subviews

    private let textStackView: MDSMenuTextStackView

    private let checkImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    init(title: String, description: String?, isChecked: Bool) {
        self.textStackView = MDSMenuTextStackView(
            title: title,
            description: description,
            trailingPadding: LayoutToken.textTrailingPadding
        )
        super.init(spacing: 0, insets: LayoutToken.contentInsets)
        setupContent()
        isSelected = isChecked
    }

    // MARK: - Setup

    private func setupContent() {
        contentStackView.addArrangedSubview(textStackView)
        contentStackView.addArrangedSubview(checkImageView)

        // 선택 여부로 메뉴 폭이 바뀌지 않도록 체크 아이콘 자리는 항상 확보하고, 선택이 아닐 때는 투명하게만 둔다.
        checkImageView.setContentHuggingPriority(.required, for: .horizontal)
        checkImageView.setContentCompressionResistancePriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            checkImageView.widthAnchor.constraint(equalToConstant: LayoutToken.checkIconSize),
            checkImageView.heightAnchor.constraint(equalToConstant: LayoutToken.checkIconSize),
        ])

        checkImageView.setIcon(.checkOutlined, tintColor: SemanticColor.Fg.Secondary.default)
        updateCheck()
    }

    // MARK: - Content

    private func updateCheck() {
        checkImageView.alpha = isSelected ? 1 : 0
    }
}

// MARK: - Layout Token

private extension MDSTextMenuItem {

    enum LayoutToken {
        static let checkIconSize: CGFloat = 20
        static let contentInsets = UIEdgeInsets(
            top: BaseSpacing.Base.s8,
            left: BaseSpacing.Base.s12,
            bottom: BaseSpacing.Base.s8,
            right: BaseSpacing.Base.s8
        )
        // 제목과 설명을 감싼 영역의 오른쪽 안쪽 padding. 텍스트가 체크 아이콘에 붙지 않게 한다.
        static let textTrailingPadding = BaseSpacing.Base.s10
    }
}
