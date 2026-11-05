//
//  MDSMenuListView.swift
//  MDS
//

import UIKit

/// Menu 컨테이너 공통. 배경, 모서리, padding, 아이템 배치, 탭 연결과 다중 선택 상태를 맡는다.
/// 공개 메뉴(`MDSIconMenu` 등)가 이 뷰를 품고 자기 API로 감싼다.
final class MDSMenuListView: UIView {

    // MARK: - Nested Types

    enum Selection {
        /// 탭하면 바로 동작하고 선택 상태를 가지지 않는다. (Icon, UserList)
        case none
        /// 탭하면 `isSelected`가 토글되고 여러 항목을 동시에 선택할 수 있다. (Text, Checkbox)
        case multiple
    }

    // MARK: - Properties

    /// 항목을 탭(touchUpInside)했을 때 호출된다. 다중 선택이면 선택 상태가 바뀐 뒤 호출된다.
    var onSelect: ((Int) -> Void)?

    /// 현재 선택된 항목의 index.
    private(set) var checkedIndices: Set<Int>

    private let items: [MDSMenuItemControl]
    private let selection: Selection

    // MARK: - Init

    /// - Parameters:
    ///   - items: 위에서 아래로 쌓을 아이템. 처음에 `isSelected`인 항목이 선택된 상태로 시작한다.
    ///   - itemSpacing: 아이템 사이 간격
    ///   - minWidth: 컨테이너 최소 너비. `nil`이면 제한하지 않는다.
    init(
        items: [MDSMenuItemControl],
        itemSpacing: CGFloat = 0,
        minWidth: CGFloat? = nil,
        selection: Selection = .none
    ) {
        self.items = items
        self.selection = selection
        self.checkedIndices = Set(items.indices.filter { items[$0].isSelected })
        super.init(frame: .zero)

        backgroundColor = SemanticColor.Bg.Neutral.ghost
        layer.cornerRadius = MenuLayoutToken.containerRadius

        let stackView = UIStackView(arrangedSubviews: items)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = itemSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        let padding = MenuLayoutToken.containerPadding
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
        ])

        if let minWidth {
            widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth).isActive = true
        }

        items.enumerated().forEach { index, item in
            item.addAction(UIAction { [weak self] _ in
                self?.itemTapped(index)
            }, for: .touchUpInside)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Selection

    /// 코드로 선택 상태를 바꾼다. `onSelect`는 호출하지 않으며 범위를 벗어난 index는 무시한다.
    func setChecked(_ isChecked: Bool, at index: Int) {
        guard items.indices.contains(index) else { return }
        items[index].isSelected = isChecked
        if isChecked {
            checkedIndices.insert(index)
        } else {
            checkedIndices.remove(index)
        }
    }

    private func itemTapped(_ index: Int) {
        if selection == .multiple {
            setChecked(!checkedIndices.contains(index), at: index)
        }
        onSelect?(index)
    }
}

// MARK: - Embedding

extension UIView {
    /// Auto Layout으로 배치되도록 autoresizing mask 제약은 끈다.
    func embed(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
