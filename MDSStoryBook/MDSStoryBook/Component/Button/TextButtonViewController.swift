//
//  TextButtonViewController.swift
//  MDS
//
//  Created by 최주리 on 6/4/26.
//

import UIKit
import MDS

final class TextButtonViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delaysContentTouches = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 32
        view.layoutMargins = UIEdgeInsets(top: 24, left: 20, bottom: 40, right: 20)
        view.isLayoutMarginsRelativeArrangement = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Text Button"
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        setupContent()
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }

    private func setupContent() {
        let sizes: [(title: String, size: MDSTextButton.Size)] = [
            ("Small", .small),
            ("Medium", .medium),
        ]

        sizes.forEach { item in
            contentStackView.addArrangedSubview(makeSizeSection(title: item.title, size: item.size))
        }
    }
}

private extension TextButtonViewController {

    func makeSizeSection(title: String, size: MDSTextButton.Size) -> UIView {
        let sectionTitle = UILabel()
        sectionTitle.text = title
        sectionTitle.font = .systemFont(ofSize: 20, weight: .bold)
        sectionTitle.textColor = .label

        let sectionStack = UIStackView()
        sectionStack.axis = .vertical
        sectionStack.spacing = 10
        sectionStack.addArrangedSubview(sectionTitle)

        let variants: [(label: String, variant: MDSTextButton.Variant, isEnabled: Bool)] = [
            ("Emphasis", .emphasis, true),
            ("Default", .default, true),
            ("Disabled", .default, false),
        ]

        variants.forEach { item in
            sectionStack.addArrangedSubview(
                makeRow(label: item.label, variant: item.variant, size: size, isEnabled: item.isEnabled)
            )
        }

        return sectionStack
    }

    func makeRow(
        label: String,
        variant: MDSTextButton.Variant,
        size: MDSTextButton.Size,
        isEnabled: Bool
    ) -> UIView {
        let rowLabel = UILabel()
        rowLabel.text = label
        rowLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        rowLabel.textColor = .secondaryLabel

        let card = UIView()
        card.backgroundColor = SemanticColor.Bg.Dim.default
        card.layer.cornerRadius = 12

        let button = MDSTextButton(variant: variant, size: size, title: "Text button")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(textButtonTapped(_:)), for: .touchUpInside)
        button.isEnabled = isEnabled
        card.addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            button.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            button.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),
        ])

        let rowStack = UIStackView()
        rowStack.axis = .vertical
        rowStack.spacing = 6
        rowStack.addArrangedSubview(rowLabel)
        rowStack.addArrangedSubview(card)
        return rowStack
    }
}

private extension TextButtonViewController {

    @objc func textButtonTapped(_ sender: MDSTextButton) { }
}
