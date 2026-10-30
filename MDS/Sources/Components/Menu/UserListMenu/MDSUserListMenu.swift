//
//  MDSUserListMenu.swift
//  MDS
//

import UIKit

/// 아바타, 제목, 설명(옵션)으로 이뤄진 유저 목록 메뉴. 항목을 탭하면 `onSelect`로 index를 전달하며, 선택 상태는 가지지 않는다.
public final class MDSUserListMenu: UIView {

    // MARK: - Properties

    /// 항목을 탭(touchUpInside)했을 때 호출된다.
    public var onSelect: ((Int) -> Void)?

    // MARK: - Subviews

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    public init(items: [Item], onSelect: ((Int) -> Void)? = nil) {
        self.onSelect = onSelect
        super.init(frame: .zero)
        setup(items: items)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup(items: [Item]) {
        backgroundColor = SemanticColor.Bg.Neutral.ghost
        layer.cornerRadius = BaseRadius.Base.r12

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: LayoutToken.containerPadding),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -LayoutToken.containerPadding),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LayoutToken.containerPadding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -LayoutToken.containerPadding),
        ])

        items.enumerated().forEach { index, item in
            let menuItem = MDSUserListMenuItem(title: item.title, description: item.description, image: item.image)
            menuItem.addAction(UIAction { [weak self] _ in
                self?.onSelect?(index)
            }, for: .touchUpInside)
            stackView.addArrangedSubview(menuItem)
        }
    }
}

// MARK: - Layout Token

private extension MDSUserListMenu {

    enum LayoutToken {
        static let containerPadding = BaseSpacing.Base.s8
    }
}
