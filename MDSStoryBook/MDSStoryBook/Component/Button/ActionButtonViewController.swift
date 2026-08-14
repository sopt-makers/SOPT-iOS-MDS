//
//  ActionButtonViewController.swift
//  MDSStoryBook
//
//  Created by yungu0010 on 5/25/26.
//

import UIKit
import MDS

final class ActionButtonViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delaysContentTouches = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let contentStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 32
        view.layoutMargins = UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
        view.isLayoutMarginsRelativeArrangement = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Action Button"
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        setupContent()
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }

    private func setupContent() {
        let variants: [(title: String, variant: MDSActionButton.Variant)] = [
            ("Primary", .primary),
            ("Secondary", .secondary),
            ("Danger", .danger),
        ]
        variants.forEach { item in
            contentStack.addArrangedSubview(makeVariantSection(title: item.title, variant: item.variant))
        }
    }
}

// MARK: - Section Builders

private extension ActionButtonViewController {

    // variant 단위 섹션: 타이틀 + Default / Disabled / With Icon 행으로 구성
    func makeVariantSection(title: String, variant: MDSActionButton.Variant) -> UIView {
        let sectionTitle = UILabel()
        sectionTitle.text = title
        sectionTitle.font = .systemFont(ofSize: 20, weight: .bold)
        sectionTitle.textColor = .label

        let sectionStack = UIStackView()
        sectionStack.axis = .vertical
        sectionStack.spacing = 10
        sectionStack.addArrangedSubview(sectionTitle)

        let isDanger = variant == .danger
        let sizes: [MDSActionButton.Size] = isDanger ? [.small, .medium, .large] : [.xsmall, .small, .medium, .large]

        sectionStack.addArrangedSubview(makeRow(label: "Default", variant: variant, sizes: sizes, isEnabled: true))
        sectionStack.addArrangedSubview(makeRow(label: "Disabled", variant: variant, sizes: sizes, isEnabled: false))
        sectionStack.addArrangedSubview(makeIconRow(label: "With Icon", variant: variant, sizes: sizes))
        sectionStack.addArrangedSubview(makeFullWidthRow(variant: variant, size: sizes[sizes.count - 1]))
        sectionStack.addArrangedSubview(makeIconTintRow(variant: variant, size: sizes[sizes.count - 1]))

        return sectionStack
    }

    // 버튼을 카드 폭 전체로 늘려 아이콘-타이틀 간격이 iconGap 스펙대로 유지되는지 확인하는 행.
    func makeFullWidthRow(variant: MDSActionButton.Variant, size: MDSActionButton.Size) -> UIView {
        let button = MDSActionButton(
            variant: variant,
            size: size,
            title: "Button",
            prefixIcon: .plusOutlined,
            suffixIcon: .chevronRightOutlined
        )
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return makeCardRow(label: "Full Width", buttons: [button], alignment: .fill)
    }

    // 같은 아이콘을 tint 모드만 바꿔 나란히 배치해 양방향 제어를 확인하는 행
    func makeIconTintRow(variant: MDSActionButton.Variant, size: MDSActionButton.Size) -> UIView {
        let cases: [(title: String, icon: MDSIcon, tint: MDSIcon.Tint)] = [
            ("automatic", .googleColorFilled, .automatic),
            ("original", .googleColorFilled, .original),
            ("bell auto", .bellActiveFilled, .automatic),
        ]
        let buttons: [MDSActionButton] = cases.map { item in
            let button = MDSActionButton(
                variant: variant,
                size: size,
                title: item.title,
                prefixIcon: item.icon,
                prefixIconTint: item.tint
            )
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            return button
        }
        return makeCardRow(label: "Icon Tint", buttons: buttons)
    }

    // 지정된 sizes와 enabled 상태의 버튼들을 한 행으로 구성
    func makeRow(
        label: String,
        variant: MDSActionButton.Variant,
        sizes: [MDSActionButton.Size],
        isEnabled: Bool
    ) -> UIView {
        let buttons: [MDSActionButton] = sizes.map { size in
            let button = MDSActionButton(variant: variant, size: size, title: "Button")
            button.isEnabled = isEnabled
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            return button
        }
        return makeCardRow(label: label, buttons: buttons)
    }

    // 지원되는 sizes별로 prefix + suffix 아이콘이 적용된 버튼을 한 행으로 구성
    func makeIconRow(label: String, variant: MDSActionButton.Variant, sizes: [MDSActionButton.Size]) -> UIView {
        let buttons: [MDSActionButton] = sizes.map { size in
            let button = MDSActionButton(
                variant: variant,
                size: size,
                title: "Button",
                prefixIcon: .plusOutlined,
                suffixIcon: .chevronRightOutlined
            )
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            return button
        }
        return makeCardRow(label: label, buttons: buttons)
    }

    // 레이블 + 카드 컨테이너 + 버튼 목록을 하나의 행으로 조합하는 공통 헬퍼.
    // alignment가 .fill이면 버튼이 카드 폭 전체로 늘어난다 (full-width 확인용).
    func makeCardRow(
        label: String,
        buttons: [MDSActionButton],
        alignment: UIStackView.Alignment = .leading
    ) -> UIView {
        let rowLabel = UILabel()
        rowLabel.text = label
        rowLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        rowLabel.textColor = .secondaryLabel

        let card = UIView()
        card.backgroundColor = SemanticColor.Bg.Dim.default
        card.layer.cornerRadius = 12

        let buttonRow = UIStackView()
        buttonRow.axis = .vertical
        buttonRow.spacing = 12
        buttonRow.alignment = alignment
        buttonRow.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        buttonRow.isLayoutMarginsRelativeArrangement = true
        buttonRow.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(buttonRow)

        NSLayoutConstraint.activate([
            buttonRow.topAnchor.constraint(equalTo: card.topAnchor),
            buttonRow.bottomAnchor.constraint(equalTo: card.bottomAnchor),
            buttonRow.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            // .fill일 때는 카드 폭을 꽉 채워야 버튼이 실제로 늘어난다
            alignment == .fill
                ? buttonRow.trailingAnchor.constraint(equalTo: card.trailingAnchor)
                : buttonRow.trailingAnchor.constraint(lessThanOrEqualTo: card.trailingAnchor),
        ])

        buttons.forEach { buttonRow.addArrangedSubview($0) }

        let rowStack = UIStackView()
        rowStack.axis = .vertical
        rowStack.spacing = 6
        rowStack.addArrangedSubview(rowLabel)
        rowStack.addArrangedSubview(card)
        return rowStack
    }
}

// MARK: - Actions

private extension ActionButtonViewController {

    @objc func buttonTapped(_ sender: MDSActionButton) { }
}
