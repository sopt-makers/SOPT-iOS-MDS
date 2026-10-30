//
//  MDSTextMenuItem.swift
//  MDS
//

import UIKit

/// `MDSTextMenu`의 한 줄. 모바일에는 hover가 없어서 누르고 있는 동안(`isHighlighted`)을 Hover로 표현한다.
final class MDSTextMenuItem: UIControl {

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

    var isChecked: Bool {
        didSet { updateAppearance() }
    }

    // MARK: - Subviews

    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
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

        addSubview(contentStackView)
        contentStackView.addArrangedSubview(textStackView)
        contentStackView.addArrangedSubview(checkImageView)
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(descriptionLabel)

        // 체크 여부로 메뉴 폭이 바뀌지 않도록 체크 아이콘 자리는 항상 확보하고, 체크가 아닐 때는 투명하게만 둔다.
        textStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        checkImageView.setContentHuggingPriority(.required, for: .horizontal)
        checkImageView.setContentCompressionResistancePriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),

            widthAnchor.constraint(greaterThanOrEqualToConstant: LayoutToken.minWidth),

            checkImageView.widthAnchor.constraint(equalToConstant: LayoutToken.checkIconSize),
            checkImageView.heightAnchor.constraint(equalToConstant: LayoutToken.checkIconSize),
        ])

        checkImageView.setIcon(.checkOutlined, tintColor: SemanticColor.Fg.Secondary.default)
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

        checkImageView.alpha = isChecked ? 1 : 0
    }
}

// MARK: - Layout Token

private extension MDSTextMenuItem {

    enum LayoutToken {
        static let minWidth: CGFloat = 80
        static let checkIconSize: CGFloat = 20
        static let contentInsets = UIEdgeInsets(
            top: BaseSpacing.Base.s8,
            left: BaseSpacing.Base.s12,
            bottom: BaseSpacing.Base.s8,
            right: BaseSpacing.Base.s8
        )
    }
}
