//
//  MDSMenuItemControl.swift
//  MDS
//

import UIKit

/// Menu 아이템의 공통 베이스. 모서리, 클리핑, 최소 크기, 내용 스택 배치와 Hover 배경을 맡는다.
/// 모바일에는 hover가 없어서 누르고 있는 동안(`isHighlighted`)을 Hover로 표현한다.
/// 서브클래스는 `contentStackView`에 자기 내용(아이콘, 텍스트, 체크 등)만 넣는다.
class MDSMenuItemControl: UIControl {

    // MARK: - Properties

    override var isHighlighted: Bool {
        didSet { updateHighlightBackground() }
    }

    /// 서브클래스가 요소(아이콘, 텍스트 영역, 체크 등)를 넣는 가로 스택. 터치는 아이템(`UIControl`)이 받는다.
    let contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.isLayoutMarginsRelativeArrangement = true
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    /// - Parameters:
    ///   - spacing: 아이템 안의 요소들(아이콘, 텍스트 영역, 체크 등) 사이 간격
    ///   - insets: 아이템 가장자리와 요소들 사이의 안쪽 padding
    ///   - minWidth: 최소 너비. `nil`이면 제한하지 않는다.
    ///   - minHeight: 최소 높이(터치 영역). `nil`이면 내용 높이를 따른다.
    init(
        spacing: CGFloat,
        insets: UIEdgeInsets,
        minWidth: CGFloat? = MenuLayoutToken.itemMinWidth,
        minHeight: CGFloat? = nil
    ) {
        super.init(frame: .zero)

        layer.cornerRadius = MenuLayoutToken.itemRadius
        clipsToBounds = true

        contentStackView.spacing = spacing
        contentStackView.layoutMargins = insets
        addSubview(contentStackView)

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        if let minWidth {
            widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth).isActive = true
        }

        if let minHeight {
            // 내용이 작으면 minHeight, 내용이 더 크면 내용만큼 커진다.
            heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight).isActive = true
        }

        updateHighlightBackground()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Highlight

    /// `isHighlighted`는 배경색만 바꾼다. 내용 갱신은 서브클래스가 따로 한다.
    private func updateHighlightBackground() {
        backgroundColor = isHighlighted ? SemanticColor.Bg.Neutral.Ghost.hover : .clear
    }
}
