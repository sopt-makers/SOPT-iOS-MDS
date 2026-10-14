//
//  MDSTabs.swift
//  MDS
//

import UIKit

public final class MDSTabs: UIView {

    // MARK: - Properties

    /// 사용자가 탭을 눌러 선택이 바뀔 때만 호출된다. `setSelectedIndex`로 바꾼 경우에는 호출되지 않는다.
    public var onSelectionChanged: ((Int) -> Void)?

    public private(set) var selectedIndex: Int

    private let variant: Variant
    private let tabs: [MDSTab]
    private var needsInitialScroll = true

    // MARK: - Subviews

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.isLayoutMarginsRelativeArrangement = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = SemanticColor.Stroke.Neutral.ghost
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    public init(
        items: [Item],
        variant: Variant,
        size: Size,
        divider: Bool = true,
        selectedIndex: Int = 0
    ) {
        self.variant = variant
        self.tabs = items.map {
            let tab = MDSTab(
                title: $0.title,
                variant: variant == .scrollable ? .hug : .fill,
                size: size,
                tag: $0.tag
            )
            tab.isEnabled = $0.isEnabled
            return tab
        }
        self.selectedIndex = items.isEmpty ? 0 : min(max(selectedIndex, 0), items.count - 1)
        super.init(frame: .zero)
        setup(divider: divider)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Interface

    /// 코드로 선택을 바꾼다. 화면 전환과 탭을 맞출 때 쓰며 `onSelectionChanged`는 호출하지 않는다.
    public func setSelectedIndex(_ index: Int, animated: Bool = true) {
        guard tabs.indices.contains(index) else { return }
        select(index, animated: animated)
    }

    // MARK: - Setup

    private func setup(divider: Bool) {
        let token = LayoutToken(variant: variant)

        stackView.spacing = token.spacing
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: token.horizontalMargin, bottom: 0, right: token.horizontalMargin)
        dividerView.isHidden = !divider

        tabs.enumerated().forEach { index, tab in
            tab.hitTestOutset = UIEdgeInsets(top: 0, left: token.hitTestOutset, bottom: 0, right: token.hitTestOutset)
            tab.isSelected = (index == selectedIndex)
            tab.addAction(UIAction { [weak self] _ in
                self?.tabTapped(index)
            }, for: .touchUpInside)
            stackView.addArrangedSubview(tab)
        }

        // 구분선을 먼저 넣어 탭(선택 밑줄) 아래에 그린다.
        addSubview(dividerView)
        NSLayoutConstraint.activate([
            dividerView.heightAnchor.constraint(equalToConstant: LayoutToken.dividerThickness),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -LayoutToken.verticalInset),
        ])

        switch variant {
        case .scrollable:
            setupScrollable()
        case .fixed:
            setupFixed()
        }
    }

    private func setupScrollable() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: LayoutToken.verticalInset),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -LayoutToken.verticalInset),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scrollView.heightAnchor.constraint(equalTo: stackView.heightAnchor),
        ])
    }

    private func setupFixed() {
        stackView.distribution = .fillEqually
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: LayoutToken.verticalInset),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -LayoutToken.verticalInset),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()
        if needsInitialScroll, bounds.width > 0 {
            needsInitialScroll = false
            scrollToSelected(animated: false)
        }
    }

    // MARK: - Selection

    private func tabTapped(_ index: Int) {
        guard index != selectedIndex else { return }
        select(index, animated: true)
        onSelectionChanged?(index)
    }

    private func select(_ index: Int, animated: Bool) {
        selectedIndex = index
        tabs.enumerated().forEach { $1.isSelected = ($0 == index) }
        scrollToSelected(animated: animated)
    }

    // 선택한 탭이 화면 밖이면 이웃 탭이 조금 보이도록 스크롤한다.
    private func scrollToSelected(animated: Bool) {
        guard variant == .scrollable, tabs.indices.contains(selectedIndex) else { return }
        let tab = tabs[selectedIndex]
        let rect = tab.convert(tab.bounds, to: scrollView).insetBy(dx: -LayoutToken.scrollRevealPadding, dy: 0)
        scrollView.scrollRectToVisible(rect, animated: animated)
    }
}

// MARK: - Layout Token

private extension MDSTabs {

    struct LayoutToken {
        static let verticalInset: CGFloat = 1
        static let dividerThickness = BaseSpacing.Base.s2
        static let scrollRevealPadding = BaseSpacing.Base.s20

        let spacing: CGFloat
        let horizontalMargin: CGFloat

        // 이웃 탭과 터치 영역이 겹치지 않고 맞닿도록 간격의 절반만큼 넓힌다.
        var hitTestOutset: CGFloat { spacing / 2 }

        init(variant: MDSTabs.Variant) {
            switch variant {
            case .scrollable:
                spacing = BaseSpacing.Base.s20
                horizontalMargin = BaseSpacing.Base.s10
            case .fixed:
                spacing = BaseSpacing.Base.s16
                horizontalMargin = BaseSpacing.Base.s8
            }
        }
    }
}
