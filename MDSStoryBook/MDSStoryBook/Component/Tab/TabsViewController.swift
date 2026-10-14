//
//  TabsViewController.swift
//  MDSStoryBook
//

import UIKit
import MDS

final class TabsViewController: UIViewController {

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

    private let demoContentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = SemanticColor.Fg.Neutral.default
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "선택된 화면: 0"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tabs"
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        setupDemo()
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

    // MARK: - 화면 전환 데모

    private func setupDemo() {
        let tabs = MDSTabs(
            items: [.init(title: "Tab"), .init(title: "Tab"), .init(title: "Tab")],
            variant: .fixed,
            size: .large
        )
        tabs.onSelectionChanged = { [weak self] index in
            self?.demoContentLabel.text = "선택된 화면: \(index)\n(onSelectionChanged 호출됨)"
        }

        let button = UIButton(type: .system)
        button.setTitle("setSelectedIndex(2) — 콜백 호출 안 됨", for: .normal)
        button.addAction(UIAction { [weak self, weak tabs] _ in
            tabs?.setSelectedIndex(2)
            self?.demoContentLabel.text = "setSelectedIndex(2)로 변경\n(onSelectionChanged 호출 안 됨)"
        }, for: .touchUpInside)

        let contentArea = UIView()
        contentArea.addSubview(demoContentLabel)
        demoContentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentArea.heightAnchor.constraint(equalToConstant: 96),
            demoContentLabel.centerYAnchor.constraint(equalTo: contentArea.centerYAnchor),
            demoContentLabel.leadingAnchor.constraint(equalTo: contentArea.leadingAnchor),
            demoContentLabel.trailingAnchor.constraint(equalTo: contentArea.trailingAnchor),
        ])

        contentStack.addArrangedSubview(makeSection(
            title: "화면 전환 (onSelectionChanged)",
            rows: [tabs, contentArea, button]
        ))
    }

    // MARK: - Variant / Size / Divider

    private func setupTabs() {
        let variants: [(title: String, variant: MDSTabs.Variant)] = [
            ("Scrollable", .scrollable),
            ("Fixed", .fixed),
        ]
        let sizes: [(title: String, size: MDSTabs.Size)] = [
            ("Large", .large),
            ("Medium", .medium),
            ("Small", .small),
        ]

        variants.forEach { variantItem in
            sizes.forEach { sizeItem in
                contentStack.addArrangedSubview(makeSection(
                    title: "\(variantItem.title) / \(sizeItem.title)",
                    rows: [
                        makeRow(caption: "divider ON", variant: variantItem.variant, size: sizeItem.size, divider: true),
                        makeRow(caption: "divider OFF", variant: variantItem.variant, size: sizeItem.size, divider: false),
                    ]
                ))
            }
        }
    }

    private func makeItems(variant: MDSTabs.Variant) -> [MDSTabs.Item] {
        switch variant {
        case .scrollable:
            return (0..<8).map { index in
                MDSTabs.Item(
                    title: "Tab",
                    tag: index == 1 ? .init(text: "TAG") : nil,
                    isEnabled: index != 5
                )
            }
        case .fixed:
            return [
                MDSTabs.Item(title: "Tab"),
                MDSTabs.Item(title: "Tab", tag: .init(text: "TAG")),
                MDSTabs.Item(title: "Tab", isEnabled: false),
            ]
        }
    }

    private func makeRow(caption: String, variant: MDSTabs.Variant, size: MDSTabs.Size, divider: Bool) -> UIView {
        let captionLabel = UILabel()
        captionLabel.text = caption
        captionLabel.font = .systemFont(ofSize: 12, weight: .medium)
        captionLabel.textColor = SemanticColor.Fg.Neutral.subtle

        let captionStack = UIStackView(arrangedSubviews: [captionLabel])
        captionStack.isLayoutMarginsRelativeArrangement = true
        captionStack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        let tabs = MDSTabs(items: makeItems(variant: variant), variant: variant, size: size, divider: divider)

        let row = UIStackView(arrangedSubviews: [captionStack, tabs])
        row.axis = .vertical
        row.spacing = 8
        return row
    }

    private func makeSection(title: String, rows: [UIView]) -> UIView {
        let sectionTitle = UILabel()
        sectionTitle.text = title
        sectionTitle.font = .systemFont(ofSize: 13, weight: .semibold)
        sectionTitle.textColor = .secondaryLabel

        let card = UIStackView(arrangedSubviews: rows)
        card.axis = .vertical
        card.spacing = 16
        card.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        card.isLayoutMarginsRelativeArrangement = true
        card.backgroundColor = SemanticColor.Bg.Layer.basement
        card.layer.cornerRadius = 12
        card.clipsToBounds = true

        let sectionStack = UIStackView(arrangedSubviews: [sectionTitle, card])
        sectionStack.axis = .vertical
        sectionStack.spacing = 8
        return sectionStack
    }
}
