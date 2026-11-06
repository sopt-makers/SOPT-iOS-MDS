//
//  MDSCheckboxMenuItem.swift
//  MDS
//

import UIKit

/// `MDSCheckboxMenu`의 한 줄. 행 전체가 터치 영역이고, 안의 `MDSCheckbox`는 박스 모양만 그린다.
/// 선택(`isSelected`)되면 체크박스가 켜진다. 제목과 설명(옵션)은 `MDSMenuTextView`가 보여준다.
final class MDSCheckboxMenuItem: MDSMenuItemControl {

    // MARK: - Properties

    override var isSelected: Bool {
        didSet { checkbox.isSelected = isSelected }
    }

    // MARK: - Subviews

    private let checkbox: MDSCheckbox = {
        // 제목은 MDSMenuTextView가 보여주므로 박스만 그린다.
        let checkbox = MDSCheckbox(size: .large)
        // 터치는 행 전체가 받고, 체크 토글은 컨테이너가 처리한다.
        checkbox.isUserInteractionEnabled = false
        return checkbox
    }()

    private let textView: MDSMenuTextView

    // MARK: - Init

    init(title: String, description: String? = nil, isChecked: Bool) {
        self.textView = MDSMenuTextView(title: title, description: description)
        super.init(
            spacing: LayoutToken.contentSpacing,
            insets: LayoutToken.contentInsets,
            minWidth: nil,
            minHeight: LayoutToken.minHeight
        )
        contentStackView.addArrangedSubview(checkbox)
        contentStackView.addArrangedSubview(textView)
        isSelected = isChecked
    }
}

// MARK: - Layout Token

private extension MDSCheckboxMenuItem {

    enum LayoutToken {
        static let minHeight: CGFloat = 40
        // 체크박스(20)와 텍스트 사이 간격. MDSCheckbox(large)의 박스-라벨 간격과 같다.
        static let contentSpacing = BaseSpacing.Base.s10
        static let contentInsets = UIEdgeInsets(
            top: BaseSpacing.Base.s8,
            left: BaseSpacing.Base.s10,
            bottom: BaseSpacing.Base.s8,
            right: BaseSpacing.Base.s12
        )
    }
}
