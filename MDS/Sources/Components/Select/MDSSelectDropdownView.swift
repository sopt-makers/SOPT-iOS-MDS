//
//  MDSSelectDropdown.swift
//  MDS
//

import UIKit

/// `MDSSelect` 아래에 떠서 메뉴를 보여주는 드롭다운. 아래 공간이 모자라고 위가 더 넓으면 위로 연다.
/// 너비(고정 또는 글자에 맞춤), 최대 높이를 넘었을 때의 스크롤, 화면을 덮는 overlay로 띄우고 바깥 탭으로 닫는 일을 맡는다.
/// 메뉴 자체(모양, 탭, 선택 상태)는 넘겨받은 공개 메뉴(`MDSTextMenu` 등)가 맡는다.
final class MDSSelectDropdownView: UIView {

    // MARK: - Properties

    /// `dismiss()`로든 바깥 탭으로든 메뉴가 닫히면 호출된다.
    var onDismiss: (() -> Void)?

    private let menu: UIView
    private let width: CGFloat?
    private let maxHeight: CGFloat?
    private var overlay: UIView?

    // MARK: - Subviews

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    /// - Parameters:
    ///   - menu: 드롭다운 안에 넣을 메뉴
    ///   - width: 메뉴 너비. `nil`이면 글자 길이에 맞춘다(메뉴의 최소 너비는 지킨다).
    ///   - maxHeight: 메뉴 최대 높이. `nil`이면 화면에 들어가는 만큼 늘어난다.
    init(menu: UIView, width: CGFloat?, maxHeight: CGFloat?) {
        self.menu = menu
        self.width = width
        self.maxHeight = maxHeight
        super.init(frame: .zero)
        setupLayout(menu: menu, width: width, maxHeight: maxHeight)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupLayout(menu: UIView, width: CGFloat?, maxHeight: CGFloat?) {
        // 스크롤될 때도 메뉴 모서리가 유지되도록 바깥에서 자른다.
        layer.cornerRadius = MenuLayoutToken.containerRadius
        clipsToBounds = true

        embed(scrollView)
        menu.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(menu)

        let content = scrollView.contentLayoutGuide
        let frame = scrollView.frameLayoutGuide

        // 최대 높이 안에서는 내용 높이만큼만 차지한다.
        let fitHeight = frame.heightAnchor.constraint(equalTo: content.heightAnchor)
        fitHeight.priority = .defaultLow

        NSLayoutConstraint.activate([
            menu.topAnchor.constraint(equalTo: content.topAnchor),
            menu.bottomAnchor.constraint(equalTo: content.bottomAnchor),
            menu.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            menu.trailingAnchor.constraint(equalTo: content.trailingAnchor),
            menu.widthAnchor.constraint(equalTo: frame.widthAnchor),
            fitHeight,
        ])

        if let width {
            // 화면보다 넓게 지정되면 화면 여백 제약이 이기도록 필수보다 낮춘다.
            let fixedWidth = widthAnchor.constraint(equalToConstant: width)
            fixedWidth.priority = .defaultHigh
            fixedWidth.isActive = true
        } else {
            // 글자 길이에 맞추도록 가능한 한 좁게 당긴다. 글자는 이 제약보다 우선해서 줄어들지 않는다.
            let fitWidth = widthAnchor.constraint(equalToConstant: 0)
            fitWidth.priority = .fittingSizeLevel
            fitWidth.isActive = true
        }

        if let maxHeight {
            heightAnchor.constraint(lessThanOrEqualToConstant: maxHeight).isActive = true
        }
    }

    // MARK: - Interface

    /// `anchor`의 window에 overlay를 깔고 `anchor` 바로 아래에 메뉴를 띄운다. 이미 떠 있거나 window가 없으면 무시한다.
    /// 아래 공간에 메뉴가 다 들어가지 않고 위 공간이 더 넓으면 `anchor` 바로 위에 띄운다.
    func present(below anchor: UIView) {
        guard overlay == nil, let window = anchor.window else { return }

        let overlay = UIControl(frame: window.bounds)
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlay.accessibilityViewIsModal = true
        overlay.addAction(UIAction { [weak self] _ in
            self?.dismiss()
        }, for: .touchDown)

        translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(self)
        window.addSubview(overlay)

        // ponytail: 띄우는 순간의 위치로 고정한다. 회전 등으로 anchor가 움직이면 메뉴는 따라가지 않는다.
        let anchorFrame = anchor.convert(anchor.bounds, to: window)
        let safeArea = window.safeAreaLayoutGuide
        let gap = BaseSpacing.Base.s10
        let margin = BaseSpacing.Base.s16

        // 들어갈 공간이 없으면 높이가 0에 가깝게 눌려서 메뉴가 안 보인다. 위아래 중 넓은 쪽을 고른다.
        let safeFrame = window.bounds.inset(by: window.safeAreaInsets)
        let spaceBelow = safeFrame.maxY - margin - (anchorFrame.maxY + gap)
        let spaceAbove = (anchorFrame.minY - gap) - (safeFrame.minY + margin)
        let fittingSize = menu.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let menuHeight = min(fittingSize.height, maxHeight ?? .greatestFiniteMagnitude)
        let opensUpward = menuHeight > spaceBelow && spaceAbove > spaceBelow

        let verticalConstraints = opensUpward ? [
            bottomAnchor.constraint(equalTo: overlay.topAnchor, constant: anchorFrame.minY - gap),
            topAnchor.constraint(greaterThanOrEqualTo: safeArea.topAnchor, constant: margin),
        ] : [
            topAnchor.constraint(equalTo: overlay.topAnchor, constant: anchorFrame.maxY + gap),
            bottomAnchor.constraint(lessThanOrEqualTo: safeArea.bottomAnchor, constant: -margin),
        ]

        // 기본은 anchor 왼쪽 끝에 맞추고, 오른쪽 화면 끝을 넘으면 넘는 만큼 왼쪽으로 당긴다.
        // 화면보다 넓으면 왼쪽 여백에 붙이고 너비는 오른쪽 여백 제약으로 줄어든다.
        let menuWidth = width ?? fittingSize.width
        let minX = safeFrame.minX + margin
        let maxX = safeFrame.maxX - margin - menuWidth
        let originX = max(min(anchorFrame.minX, maxX), minX)

        NSLayoutConstraint.activate(verticalConstraints + [
            leadingAnchor.constraint(equalTo: overlay.leadingAnchor, constant: originX),
            trailingAnchor.constraint(lessThanOrEqualTo: safeArea.trailingAnchor, constant: -margin),
        ])

        self.overlay = overlay
    }

    /// 메뉴와 overlay를 내리고 `onDismiss`를 호출한다.
    func dismiss() {
        guard let overlay else { return }
        overlay.removeFromSuperview()
        self.overlay = nil
        onDismiss?()
    }
}
