//
//  MDSSelect.swift
//  MDS
//
//  Created by 최주리 on 11/10/26.
//

import UIKit

/// 탭하면 아래에 드롭다운(`MDSSelectDropdownView`)으로 메뉴가 열리는 선택 필드.
public final class MDSSelect: UIControl {

    // MARK: - Properties

    /// 사용자가 메뉴에서 선택을 바꾼 뒤 호출된다. `selectedIndices`를 코드로 바꾼 경우에는 호출되지 않는다.
    public var onSelectionChanged: ((Set<Int>) -> Void)?

    /// 선택된 항목의 index. 범위를 벗어난 index는 버리고, `.single`이면 가장 앞의 하나만 남긴다.
    public var selectedIndices: Set<Int> = [] {
        didSet {
            let normalized = normalize(selectedIndices)
            if normalized != selectedIndices { selectedIndices = normalized }
            syncMenuChecks()
            updateAppearance()
        }
    }

    private let type: SelectType
    private let menuType: MenuType
    private let placeholder: String
    private let titles: [String]
    private let menuWidth: CGFloat?
    private let menuMaxHeight: CGFloat?

    private var dropdown: MDSSelectDropdownView?

    /// 열려 있는 다중 선택 메뉴의 체크를 바꾸는 함수. 메뉴가 닫혀 있거나 단일 선택이면 `nil`이다.
    private var setMenuChecked: ((Bool, Int) -> Void)?

    private var isOpen: Bool { dropdown != nil }

    // MARK: - Subviews

    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = LayoutToken.contentSpacing
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = LayoutToken.contentInsets
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private let countTag = MDSTag(
        size: .small,
        shape: .rect,
        variant: .secondary,
        style: .subtle
    )

    private let chevronImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    // MARK: - Init

    /// - Parameters:
    ///   - type: 선택 방식. `.icon`, `.userList` 메뉴는 `.single`만 쓸 수 있다.
    ///   - menuType: 열리는 메뉴의 종류와 항목. Text, Checkbox 항목의 `isChecked`가 처음 선택 상태가 된다.
    ///   - menuWidth: 메뉴 너비. `nil`이면 글자 길이에 맞춘다(최소 너비는 지킨다).
    ///   - menuMaxHeight: 메뉴 최대 높이. 넘치면 메뉴 안에서 스크롤된다. `nil`이면 화면에 들어가는 만큼 늘어난다.
    public init(
        type: SelectType = .single,
        menuType: MenuType,
        placeholder: String,
        menuWidth: CGFloat? = nil,
        menuMaxHeight: CGFloat? = nil
    ) {
        // Icon, UserList 메뉴는 선택 상태가 없어서 다중 선택을 표시할 수 없다.
        assert(type == .single || menuType.supportsMultiple, "\(menuType) 메뉴는 .single만 지원합니다.")
        
        self.type = menuType.supportsMultiple ? type : .single
        self.menuType = menuType
        self.placeholder = placeholder
        self.titles = menuType.titles
        self.menuWidth = menuWidth
        self.menuMaxHeight = menuMaxHeight
        super.init(frame: .zero)
        
        // init 안에서는 didSet이 불리지 않아서 직접 정리한다.
        selectedIndices = normalize(menuType.checkedIndices)
        setupLayout()
        updateAppearance()

        addAction(UIAction { [weak self] _ in
            self?.openMenu()
        }, for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    public override func didMoveToWindow() {
        super.didMoveToWindow()
        // 메뉴가 열린 채로 화면에서 빠지면 window에 올린 overlay가 남아 다음 화면의 터치를 막는다.
        if window == nil { dropdown?.dismiss() }
    }

    // MARK: - Setup

    private func setupLayout() {
        backgroundColor = SemanticColor.Bg.Neutral.ghost
        layer.cornerRadius = LayoutToken.radius
        layer.borderColor = SemanticColor.Stroke.Neutral.inverse.cgColor
        clipsToBounds = true

        isAccessibilityElement = true
        accessibilityTraits = .button

        countTag.isUserInteractionEnabled = false
        countTag.setContentHuggingPriority(.required, for: .horizontal)
        countTag.setContentCompressionResistancePriority(.required, for: .horizontal)

        [titleLabel, countTag, chevronImageView].forEach(contentStackView.addArrangedSubview)
        addSubview(contentStackView)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: LayoutToken.height),
            widthAnchor.constraint(greaterThanOrEqualToConstant: LayoutToken.minWidth),

            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),

            chevronImageView.widthAnchor.constraint(equalToConstant: LayoutToken.chevronSize),
            chevronImageView.heightAnchor.constraint(equalToConstant: LayoutToken.chevronSize),
        ])
    }

    /// 범위를 벗어난 index는 버리고, `.single`이면 가장 앞의 하나만 남긴다.
    private func normalize(_ indices: Set<Int>) -> Set<Int> {
        let valid = indices.filter { titles.indices.contains($0) }
        guard type == .single else { return valid }
        return valid.min().map { [$0] } ?? []
    }

    // MARK: - Appearance

    /// 상태(Default / Active / Filled)에 맞춰 글자, 개수 태그, 테두리, chevron을 갱신한다.
    private func updateAppearance() {
        // Filled는 목록에서 가장 앞에 있는 선택 항목의 제목을 보여준다.
        let title = selectedIndices.min().map { titles[$0] }
        titleLabel.text = title ?? placeholder
        titleLabel.setTypography(
            Typography.label2,
            textColor: title == nil ? SemanticColor.Fg.Neutral.subtle : SemanticColor.Fg.Neutral.bold
        )

        countTag.isHidden = type == .single || selectedIndices.isEmpty
        countTag.text = "\(selectedIndices.count)"

        layer.borderWidth = isOpen ? LayoutToken.activeBorderWidth : 0
        chevronImageView.setIcon(
            isOpen ? .chevronUpOutlined : .chevronDownOutlined,
            tintColor: SemanticColor.Fg.Neutral.bold
        )

        accessibilityLabel = title ?? placeholder
        accessibilityValue = type == .multiple && !selectedIndices.isEmpty ? "\(selectedIndices.count)" : nil
    }

    // MARK: - Action

    /// 열 때마다 현재 선택 상태로 메뉴를 새로 만든다. 열려 있는 동안의 변경은 `syncMenuChecks()`가 맞춘다.
    private func openMenu() {
        // window가 없으면 띄우지 못하므로 열린 상태로 남지 않게 막는다.
        guard !isOpen, window != nil else { return }

        let dropdown = MDSSelectDropdownView(menu: makeMenu(), width: menuWidth, maxHeight: menuMaxHeight)
        dropdown.onDismiss = { [weak self] in
            self?.dropdown = nil
            self?.setMenuChecked = nil
            self?.updateAppearance()
        }

        dropdown.present(below: self)
        self.dropdown = dropdown
        updateAppearance()
    }

    private func menuItemTapped(_ index: Int) {
        switch type {
        case .single:
            // 메뉴 자체에는 선택 상태가 없다. 값을 채우고 바로 닫는다.
            // 이미 선택된 항목을 다시 탭하면 값이 바뀌지 않으므로 콜백은 호출하지 않는다.
            let isChanged = selectedIndices != [index]
            selectedIndices = [index]
            dropdown?.dismiss()
            guard isChanged else { return }
        case .multiple:
            // 선택 상태의 기준은 `selectedIndices` 하나다. 메뉴가 스스로 토글한 체크는 `didSet`의 동기화로 덮어쓴다.
            selectedIndices.formSymmetricDifference([index])
        }
        onSelectionChanged?(selectedIndices)
    }

    // MARK: - Menu

    /// 메뉴 종류에 맞는 공개 메뉴를 만든다. Text, Checkbox는 현재 선택 상태로 체크를 다시 정하고,
    /// 다중 선택이면 열려 있는 동안 체크를 맞출 수 있도록 `setMenuChecked`를 연결한다.
    private func makeMenu() -> UIView {
        let onSelect: (Int) -> Void = { [weak self] index in
            self?.menuItemTapped(index)
        }

        switch menuType {
        case .text(let items):
            let menu = MDSTextMenu(items: applyingSelection(to: items, isChecked: \.isChecked), onSelect: onSelect)
            setMenuChecked = type == .multiple ? { [weak menu] in menu?.setChecked($0, at: $1) } : nil
            return menu
        case .checkbox(let items):
            let menu = MDSCheckboxMenu(items: applyingSelection(to: items, isChecked: \.isChecked), onSelect: onSelect)
            setMenuChecked = type == .multiple ? { [weak menu] in menu?.setChecked($0, at: $1) } : nil
            return menu
        case .icon(let items):
            return MDSIconMenu(items: items, onSelect: onSelect)
        case .userList(let items):
            return MDSUserListMenu(items: items, onSelect: onSelect)
        }
    }

    /// 열려 있는 메뉴의 체크를 `selectedIndices`와 같게 맞춘다.
    /// 탭으로 바뀐 경우와 코드로 바뀐 경우(예: `onSelectionChanged`에서 개수 제한) 모두 여기서 맞춘다.
    private func syncMenuChecks() {
        guard let setMenuChecked else { return }
        titles.indices.forEach { setMenuChecked(selectedIndices.contains($0), $0) }
    }

    /// 단일 선택은 메뉴에 선택 표시를 남기지 않고, 다중 선택은 `selectedIndices`만 체크한다.
    ///
    /// `MDSTextMenu.Item`과 `MDSCheckboxMenu.Item`은 둘 다 `isChecked`가 있지만 공통 protocol이 없는 다른 타입이다.
    /// 그래서 `Item`을 제네릭으로 받고, 바꿀 프로퍼티는 keyPath(`\.isChecked`)로 넘겨서 함수 하나로 두 타입을 처리한다.
    /// `item[keyPath: isChecked] = true`는 `item.isChecked = true`와 같다.
    private func applyingSelection<Item>(to items: [Item], isChecked: WritableKeyPath<Item, Bool>) -> [Item] {
        items.enumerated().map { index, item in
            var item = item
            item[keyPath: isChecked] = type == .multiple && selectedIndices.contains(index)
            return item
        }
    }
}

// MARK: - Menu Type

private extension MDSSelect.MenuType {
    /// 선택 상태(체크)를 표시할 수 있는 메뉴인지. Icon, UserList는 선택 상태가 없다.
    var supportsMultiple: Bool {
        switch self {
        case .text, .checkbox: true
        case .icon, .userList: false
        }
    }

    var titles: [String] {
        switch self {
        case .text(let items): items.map(\.title)
        case .checkbox(let items): items.map(\.title)
        case .icon(let items): items.map(\.title)
        case .userList(let items): items.map(\.title)
        }
    }

    /// 처음 선택 상태. Icon, UserList 항목에는 선택 상태가 없다.
    var checkedIndices: Set<Int> {
        let isChecked: [Bool] = switch self {
        case .text(let items): items.map(\.isChecked)
        case .checkbox(let items): items.map(\.isChecked)
        case .icon, .userList: []
        }
        return Set(isChecked.indices.filter { isChecked[$0] })
    }
}

// MARK: - Layout Token

private extension MDSSelect {

    enum LayoutToken {
        static let height: CGFloat = 46
        static let minWidth: CGFloat = 100
        static let radius = BaseRadius.Base.r10
        static let activeBorderWidth: CGFloat = 1
        static let contentInsets = UIEdgeInsets(
            top: BaseSpacing.Base.s12,
            left: BaseSpacing.Base.s16,
            bottom: BaseSpacing.Base.s12,
            right: BaseSpacing.Base.s16
        )
        static let contentSpacing = BaseSpacing.Base.s12
        static let chevronSize: CGFloat = 20
    }
}
