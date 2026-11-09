//
//  MDSTextMenu.swift
//  MDS
//

import UIKit

/// 제목과 설명(옵션)으로 이뤄진 메뉴 목록. 항목을 탭하면 체크가 토글되고 여러 항목을 동시에 체크할 수 있다.
public final class MDSTextMenu: UIView {

    // MARK: - Properties

    /// 사용자가 항목을 탭(touchUpInside)해 체크가 바뀐 뒤 호출된다. `setChecked`로 바꾼 경우에는 호출되지 않는다.
    public var onSelect: ((Int) -> Void)? {
        get { listView.onSelect }
        set { listView.onSelect = newValue }
    }

    /// 현재 체크된 항목의 index.
    public var checkedIndices: Set<Int> {
        listView.checkedIndices
    }

    private let listView: MDSMenuListView

    // MARK: - Init

    public init(items: [Item], onSelect: ((Int) -> Void)? = nil) {
        self.listView = MDSMenuListView(
            items: items.map {
                MDSTextMenuItem(title: $0.title, description: $0.description, isChecked: $0.isChecked)
            },
            minWidth: LayoutToken.minWidth,
            selection: .multiple
        )
        super.init(frame: .zero)
        listView.onSelect = onSelect
        embed(listView)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Interface

    /// 코드로 체크를 바꾼다. `onSelect`는 호출하지 않으며 범위를 벗어난 index는 무시한다.
    public func setChecked(_ isChecked: Bool, at index: Int) {
        listView.setChecked(isChecked, at: index)
    }
}

// MARK: - Layout Token

private extension MDSTextMenu {

    enum LayoutToken {
        static let minWidth: CGFloat = 100
    }
}
