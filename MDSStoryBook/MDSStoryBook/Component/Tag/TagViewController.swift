//
//  TagViewController.swift
//  MDSStoryBook
//

import UIKit
import MDS

final class TagViewController: UIViewController {

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
        title = "Tag"
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        setupTags()
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

    private func setupTags() {
        let sizes: [(title: String, size: MDSTag.Size)] = [
            ("Small (h=24)", .small),
            ("Medium (h=26)", .medium),
        ]

        sizes.forEach { item in
            contentStack.addArrangedSubview(makeSizeSection(title: item.title, size: item.size))
        }
    }

    private func makeSizeSection(title: String, size: MDSTag.Size) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .label

        let sectionStack = UIStackView()
        sectionStack.axis = .vertical
        sectionStack.spacing = 8
        sectionStack.addArrangedSubview(titleLabel)

        let combinations: [(variant: MDSTag.Variant, style: MDSTag.Style, name: String)] = [
            (.default, .solid, "Default / Solid"),
            (.default, .subtle, "Default / Subtle"),
            (.primary, .solid, "Primary / Solid"),
            (.primary, .subtle, "Primary / Subtle"),
            (.secondary, .solid, "Secondary / Solid"),
            (.secondary, .subtle, "Secondary / Subtle"),
        ]

        combinations.forEach { combo in
            sectionStack.addArrangedSubview(
                makeVariantRow(
                    label: combo.name,
                    size: size,
                    variant: combo.variant,
                    style: combo.style
                )
            )
        }

        return sectionStack
    }

    private func makeVariantRow(
        label: String,
        size: MDSTag.Size,
        variant: MDSTag.Variant,
        style: MDSTag.Style
    ) -> UIView {
        let rowLabel = UILabel()
        rowLabel.text = label
        rowLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        rowLabel.textColor = .secondaryLabel

        let card = UIView()
        card.backgroundColor = SemanticColor.Bg.Dim.default
        card.layer.cornerRadius = 12

        let tagRow = UIStackView()
        tagRow.axis = .horizontal
        tagRow.spacing = 16
        tagRow.alignment = .center
        tagRow.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        tagRow.isLayoutMarginsRelativeArrangement = true
        tagRow.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(tagRow)

        NSLayoutConstraint.activate([
            tagRow.topAnchor.constraint(equalTo: card.topAnchor),
            tagRow.bottomAnchor.constraint(equalTo: card.bottomAnchor),
            tagRow.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            tagRow.trailingAnchor.constraint(lessThanOrEqualTo: card.trailingAnchor),
        ])

        let icon = UIImage(systemName: "star.fill")
        let shapes: [(MDSTag.Shape, String)] = [(.rect, "Rect"), (.pill, "Pill")]
        shapes.forEach { shape, shapeName in
            tagRow.addArrangedSubview(makeTagItem(
                size: size, shape: shape, variant: variant, style: style,
                icon: nil, description: shapeName
            ))
            tagRow.addArrangedSubview(makeTagItem(
                size: size, shape: shape, variant: variant, style: style,
                icon: icon, description: "\(shapeName)+Icon"
            ))
        }

        let rowStack = UIStackView()
        rowStack.axis = .vertical
        rowStack.spacing = 6
        rowStack.addArrangedSubview(rowLabel)
        rowStack.addArrangedSubview(card)
        return rowStack
    }

    private func makeTagItem(
        size: MDSTag.Size,
        shape: MDSTag.Shape,
        variant: MDSTag.Variant,
        style: MDSTag.Style,
        icon: UIImage?,
        description: String
    ) -> UIView {
        let itemStack = UIStackView()
        itemStack.axis = .vertical
        itemStack.spacing = 6
        itemStack.alignment = .center

        let tag = MDSTag(text: "Tag", size: size, shape: shape, variant: variant, style: style, icon: icon)

        let descLabel = UILabel()
        descLabel.text = description
        descLabel.font = .systemFont(ofSize: 9)
        descLabel.textColor = SemanticColor.Fg.Neutral.subtle
        descLabel.textAlignment = .center

        itemStack.addArrangedSubview(tag)
        itemStack.addArrangedSubview(descLabel)
        return itemStack
    }
}
