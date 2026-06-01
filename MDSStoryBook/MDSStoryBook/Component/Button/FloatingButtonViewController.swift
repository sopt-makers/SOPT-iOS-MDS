//
//  FloatingButtonViewController.swift
//  MDSStoryBook
//
//  Created by yungu0010 on 5/31/26.
//

import UIKit
import MDS

final class FloatingButtonViewController: UIViewController {

    // MARK: - Subviews

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delaysContentTouches = false
        return scrollView
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 24, left: 20, bottom: 40, right: 20)
        return stackView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Floating Button"
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        setupContent()
    }

    // MARK: - Setup

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
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
        contentStackView.addArrangedSubview(makeSizeSection(size: .default))
        contentStackView.addArrangedSubview(makeSizeSection(size: .extended))
    }

    // MARK: - Section Builders

    private func makeSizeSection(size: MDSFloatingButton.Size) -> UIView {
        let sectionTitle = size == .default ? "Default" : "Extended"

        let titleLabel = UILabel()
        titleLabel.text = sectionTitle
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .label

        let icon = UIImage(systemName: "plus")
        let label = size == .extended ? "추가하기" : nil

        let defaultButton = MDSFloatingButton(size: size, icon: icon, label: label)
        let disabledButton = MDSFloatingButton(size: size, icon: icon, label: label)
        disabledButton.isEnabled = false

        let rows: [(String, MDSFloatingButton)] = [
            ("Default", defaultButton),
            ("Disabled", disabledButton),
        ]

        let sectionStack = UIStackView()
        sectionStack.axis = .vertical
        sectionStack.spacing = 8
        sectionStack.addArrangedSubview(titleLabel)
        for (label, button) in rows {
            sectionStack.addArrangedSubview(makeRow(label: label, button: button))
        }

        return sectionStack
    }

    private func makeRow(label: String, button: MDSFloatingButton) -> UIView {
        let stateLabel = UILabel()
        stateLabel.text = label
        stateLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        stateLabel.textColor = .secondaryLabel

        let card = UIView()
        card.backgroundColor = SemanticColor.Bg.Dim.default
        card.layer.cornerRadius = 12

        button.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            button.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),
            button.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
        ])

        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 6
        container.addArrangedSubview(stateLabel)
        container.addArrangedSubview(card)
        return container
    }
}
