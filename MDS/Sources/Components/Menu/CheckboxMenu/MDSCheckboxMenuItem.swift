//
//  MDSCheckboxMenuItem.swift
//  MDS
//

import UIKit

/// `MDSCheckboxMenu`의 한 줄. 행 전체가 터치 영역이고, 안의 `MDSCheckbox`는 모양만 그린다.
/// 선택(`isSelected`)되면 체크박스가 켜진다.
final class MDSCheckboxMenuItem: MDSMenuItemControl {

    // MARK: - Properties

    override var isSelected: Bool {
        didSet { checkbox.isSelected = isSelected }
    }

    var title: String {
        didSet { checkbox.title = title }
    }

    // MARK: - Subviews

    private let checkbox: MDSCheckbox = {
        let checkbox = MDSCheckbox(size: .large)
        // 터치는 행 전체가 받고, 체크 토글은 컨테이너가 처리한다.
        checkbox.isUserInteractionEnabled = false
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        return checkbox
    }()

    // MARK: - Init

    init(title: String, isChecked: Bool) {
        self.title = title
        super.init(
            spacing: 0,
            insets: LayoutToken.contentInsets,
            minWidth: nil,
            minHeight: LayoutToken.minHeight
        )
        contentStackView.addArrangedSubview(checkbox)
        checkbox.title = title
        isSelected = isChecked
    }
}

// MARK: - Layout Token

private extension MDSCheckboxMenuItem {

    enum LayoutToken {
        static let minHeight: CGFloat = 40
        static let contentInsets = UIEdgeInsets(
            top: BaseSpacing.Base.s8,
            left: BaseSpacing.Base.s10,
            bottom: BaseSpacing.Base.s8,
            right: BaseSpacing.Base.s12
        )
    }
}
