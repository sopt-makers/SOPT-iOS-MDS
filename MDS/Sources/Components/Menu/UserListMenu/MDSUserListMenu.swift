//
//  MDSUserListMenu.swift
//  MDS
//

import UIKit

/// 아바타, 제목, 설명(옵션)으로 이뤄진 유저 목록 메뉴. 항목을 탭하면 `onSelect`로 index를 전달하며, 선택 상태는 가지지 않는다.
public final class MDSUserListMenu: UIView {

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
            items: items.map {
                MDSUserListMenuItem(title: $0.title, description: $0.description, image: $0.image)
            }
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
