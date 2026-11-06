//
//  MDSIconMenu.swift
//  MDS
//

import UIKit

/// 아이콘과 텍스트로 이뤄진 메뉴 목록. 항목을 탭하면 `onSelect`로 index를 전달하며, 선택 상태는 가지지 않는다.
public final class MDSIconMenu: UIView {

    // MARK: - Properties

    /// 항목을 탭(touchUpInside)했을 때 호출된다.
    public var onSelect: ((Int) -> Void)? {
        get { listView.onSelect }
        set { listView.onSelect = newValue }
    }

    private let listView: MDSMenuListView

    // MARK: - Init

    public init(items: [Item], onSelect: ((Int) -> Void)? = nil) {
        self.listView = MDSMenuListView(
            items: items.map { MDSIconMenuItem(title: $0.title, description: $0.description, icon: $0.icon) },
            itemSpacing: LayoutToken.itemSpacing
        )
        super.init(frame: .zero)
        listView.onSelect = onSelect
        embed(listView)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout Token

private extension MDSIconMenu {

    enum LayoutToken {
        static let itemSpacing = BaseSpacing.Base.s4
    }
}
