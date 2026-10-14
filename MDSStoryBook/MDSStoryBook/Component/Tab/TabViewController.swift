//
//  TabViewController.swift
//  MDSStoryBook
//

import UIKit
import MDS

final class TabViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 32
        stack.layoutMargins = UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tab"
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        setupTabs()
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

    private func setupTabs() {
        let variants: [(title: String, variant: MDSTab.Variant)] = [
            ("Hug", .hug),
            ("Fill", .fill),
        ]
        let sizes: [(title: String, size: MDSTab.Size)] = [
            ("Large", .large),
            ("Medium", .medium),
            ("Small", .small),
        ]

        variants.forEach { variantItem in
            sizes.forEach { sizeItem in
                contentStack.addArrangedSubview(makeSection(
                    title: "\(variantItem.title) / \(sizeItem.title)",
                    rows: [
                        makeRow(variant: variantItem.variant, size: sizeItem.size, hasTag: false),
                        makeRow(variant: variantItem.variant, size: sizeItem.size, hasTag: true),
                        makeRow(variant: variantItem.variant, size: sizeItem.size, hasTag: true, isEnabled: false),
                    ]
                ))
            }
        }
    }

    private func makeSection(title: String, rows: [UIView]) -> UIView {
        let sectionTitle = UILabel()
        sectionTitle.text = title
        sectionTitle.font = .systemFont(ofSize: 13, weight: .semibold)
        sectionTitle.textColor = .secondaryLabel

        let card = UIStackView(arrangedSubviews: rows)
        card.axis = .vertical
        card.spacing = 16
        card.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        card.isLayoutMarginsRelativeArrangement = true
        card.backgroundColor = SemanticColor.Bg.Layer.basement
        card.layer.cornerRadius = 12

        let sectionStack = UIStackView(arrangedSubviews: [sectionTitle, card])
        sectionStack.axis = .vertical
        sectionStack.spacing = 8
        return sectionStack
    }

    private func makeRow(variant: MDSTab.Variant, size: MDSTab.Size, hasTag: Bool, isEnabled: Bool = true) -> UIView {
        let titles = variant == .hug ? ["Tab", "Tab", "Tab"] : ["Tab", "Tab"]
        let tabs = titles.enumerated().map { index, title in
            MDSTab(
                title: title,
                variant: variant,
                size: size,
                tag: hasTag ? .init(text: "TAG") : nil,
                isSelected: index == 0
            )
        }

        tabs.forEach { tab in
            tab.isEnabled = isEnabled
            tab.addAction(UIAction { _ in
                tabs.forEach { $0.isSelected = ($0 === tab) }
            }, for: .touchUpInside)
        }

        let row = UIStackView(arrangedSubviews: tabs)
        row.axis = .horizontal
        row.spacing = variant == .hug ? 20 : 0

        switch variant {
        case .hug:
            row.addArrangedSubview(UIView())
        case .fill:
            row.distribution = .fillEqually
        }
        return makeScrollableRow(row)
    }

    // 행이 카드 폭을 넘으면 가로로 스크롤되고, 넘지 않으면 카드 폭을 채운다.
    private func makeScrollableRow(_ row: UIStackView) -> UIView {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        row.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(row)

        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            row.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            row.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            row.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            row.widthAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: row.heightAnchor),
        ])
        return scrollView
    }
}
