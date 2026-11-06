//
//  MDSMenuTextView.swift
//  MDS
//

import UIKit

/// Menu 아이템의 제목과 설명(옵션) 영역. 설명이 `nil`이거나 비어 있으면 제목만 보인다.
/// 긴 텍스트는 이 영역이 먼저 줄어들어서 옆의 아이콘, 아바타, 체크를 밀어내지 않는다.
final class MDSMenuTextView: UIStackView {

    // MARK: - Properties

    var title: String {
        didSet { updateContent() }
    }

    var descriptionText: String? {
        didSet { updateContent() }
    }

    // MARK: - Subviews

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

    /// - Parameter trailingPadding: 이 영역의 오른쪽 안쪽 padding. 옆의 체크 아이콘 등에 텍스트가 붙지 않게 한다.
    init(title: String, description: String?, trailingPadding: CGFloat = 0) {
        self.title = title
        self.descriptionText = description
        super.init(frame: .zero)

        axis = .vertical
        alignment = .leading
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: trailingPadding)

        addArrangedSubview(titleLabel)
        addArrangedSubview(descriptionLabel)

        // 남는 폭은 이 영역이 채우고, 폭이 모자라면 이 영역(텍스트)이 먼저 줄어든다.
        setContentHuggingPriority(.defaultLow, for: .horizontal)
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        updateContent()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Content

    private func updateContent() {
        titleLabel.text = title
        titleLabel.setTypography(Typography.label2, textColor: SemanticColor.Fg.Neutral.bold)

        let hasDescription = !(descriptionText ?? "").isEmpty
        descriptionLabel.isHidden = !hasDescription
        if hasDescription {
            descriptionLabel.text = descriptionText
            descriptionLabel.setTypography(Typography.label3, textColor: SemanticColor.Fg.Neutral.subtle)
        }
    }
}
