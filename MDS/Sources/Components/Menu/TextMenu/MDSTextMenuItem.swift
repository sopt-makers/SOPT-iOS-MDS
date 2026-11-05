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

    var title: String {
        didSet { updateContent() }
    }

    var itemDescription: String? {
        didSet { updateContent() }
    }

    // MARK: - Subviews

    private let textStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = LayoutToken.textInsets
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

    private let checkImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    init(title: String, description: String?, isChecked: Bool) {
        self.title = title
        self.itemDescription = description
        super.init(spacing: 0, insets: LayoutToken.contentInsets)
        setupContent()
        isSelected = isChecked
    }

    // MARK: - Setup

    private func setupContent() {
        contentStackView.addArrangedSubview(textStackView)
        contentStackView.addArrangedSubview(checkImageView)
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(descriptionLabel)

        // 선택 여부로 메뉴 폭이 바뀌지 않도록 체크 아이콘 자리는 항상 확보하고, 선택이 아닐 때는 투명하게만 둔다.
        textStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        // 텍스트가 길면 체크 아이콘을 밀지 않고 텍스트가 먼저 줄어들도록 압축 우선순위를 낮춘다.
        textStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        checkImageView.setContentHuggingPriority(.required, for: .horizontal)
        checkImageView.setContentCompressionResistancePriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            checkImageView.widthAnchor.constraint(equalToConstant: LayoutToken.checkIconSize),
            checkImageView.heightAnchor.constraint(equalToConstant: LayoutToken.checkIconSize),
        ])

        checkImageView.setIcon(.checkOutlined, tintColor: SemanticColor.Fg.Secondary.default)
        updateContent()
        updateCheck()
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
        // 제목과 설명을 감싼 영역의 안쪽 padding. 텍스트가 체크 아이콘에 붙지 않게 오른쪽에 10을 둔다.
        static let textInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: BaseSpacing.Base.s10)
    }
}
