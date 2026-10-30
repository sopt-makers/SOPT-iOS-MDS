//
//  MDSCheckboxMenu.swift
//  MDS
//

import UIKit

/// 체크박스와 제목으로 이뤄진 메뉴 목록. 항목을 탭하면 체크가 토글되고 여러 항목을 동시에 체크할 수 있다.
public final class MDSCheckboxMenu: UIView {

    // MARK: - Properties

    /// 사용자가 항목을 탭(touchUpInside)해 체크가 바뀐 뒤 호출된다. `setChecked`로 바꾼 경우에는 호출되지 않는다.
    public var onSelect: ((Int) -> Void)?

    /// 현재 체크된 항목의 index.
    public private(set) var checkedIndices: Set<Int>

    private let menuItems: [MDSCheckboxMenuItem]

    // MARK: - Subviews

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = LayoutToken.itemSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    public init(items: [Item], onSelect: ((Int) -> Void)? = nil) {
        self.onSelect = onSelect
        self.checkedIndices = Set(items.indices.filter { items[$0].isChecked })
        self.menuItems = items.map { MDSCheckboxMenuItem(title: $0.title, isChecked: $0.isChecked) }
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Interface

    /// 코드로 체크를 바꾼다. `onSelect`는 호출하지 않으며 범위를 벗어난 index는 무시한다.
    public func setChecked(_ isChecked: Bool, at index: Int) {
        guard menuItems.indices.contains(index) else { return }
        menuItems[index].isChecked = isChecked
        if isChecked {
            checkedIndices.insert(index)
        } else {
            checkedIndices.remove(index)
        }
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = SemanticColor.Bg.Neutral.ghost
        layer.cornerRadius = BaseRadius.Base.r12

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: LayoutToken.containerPadding),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -LayoutToken.containerPadding),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LayoutToken.containerPadding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -LayoutToken.containerPadding),

            widthAnchor.constraint(greaterThanOrEqualToConstant: LayoutToken.minWidth),
        ])

        menuItems.enumerated().forEach { index, menuItem in
            menuItem.addAction(UIAction { [weak self] _ in
                self?.itemTapped(index)
            }, for: .touchUpInside)
            stackView.addArrangedSubview(menuItem)
        }
    }

    // MARK: - Selection

    private func itemTapped(_ index: Int) {
        setChecked(!checkedIndices.contains(index), at: index)
        onSelect?(index)
    }
}

// MARK: - Layout Token

private extension MDSCheckboxMenu {

    enum LayoutToken {
        static let minWidth: CGFloat = 125
        static let containerPadding = BaseSpacing.Base.s8
        static let itemSpacing = BaseSpacing.Base.s4
    }
}
