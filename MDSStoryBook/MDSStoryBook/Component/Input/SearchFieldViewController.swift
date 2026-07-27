//
//  SearchFieldViewController.swift
//  MDSStoryBook
//

import UIKit
import MDS

final class SearchFieldViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
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
        title = "Search Field"
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
        let variants: [(title: String, variant: MDSSearchField.Variant)] = [
            ("Default", .default),
            ("Bold", .bold),
        ]
        variants.forEach { item in
            contentStack.addArrangedSubview(makeVariantSection(title: item.title, variant: item.variant))
        }
    }

    private func makeVariantSection(title: String, variant: MDSSearchField.Variant) -> UIView {
        let sectionTitle = UILabel()
        sectionTitle.text = title
        sectionTitle.font = .systemFont(ofSize: 20, weight: .bold)
        sectionTitle.textColor = .label

        let field = MDSSearchField(variant: variant, placeholder: "Placeholder")
        field.translatesAutoresizingMaskIntoConstraints = false

        let card = UIView()
        card.backgroundColor = SemanticColor.Bg.Dim.default
        card.layer.cornerRadius = 12
        card.addSubview(field)

        NSLayoutConstraint.activate([
            field.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            field.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            field.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            field.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),
        ])

        let section = UIStackView(arrangedSubviews: [sectionTitle, card])
        section.axis = .vertical
        section.spacing = 10
        return section
    }
}
